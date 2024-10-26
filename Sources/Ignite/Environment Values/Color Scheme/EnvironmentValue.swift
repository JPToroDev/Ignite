//
// EnvironmentValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public enum ColorScheme: String {
    case light
    case dark
}

// The condition that gets generated when comparing environment values
public struct EnvironmentCondition {
    let key: String
    let value: String
    let trueValue: String
    let falseValue: String
    let property: String
}

// Simple equality operator that creates the condition
public func ==(lhs: ColorScheme, rhs: ColorScheme) -> EnvironmentCondition {
    EnvironmentCondition(
        key: "colorscheme",
        value: rhs.rawValue,
        trueValue: "none",
        falseValue: "block",
        property: "display"
    )
}

// Extension to add environment-aware modifiers
extension PageElement {
    public func hidden(_ condition: EnvironmentCondition) -> Self {
        var copy = self
        
        let values = [
            condition.value: condition.trueValue,
            "default": condition.falseValue
        ]
        
        let jsonData = try! JSONEncoder().encode([condition.property: values])
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        copy.attributes.customAttributes.append(
            AttributeValue(name: "data-env-\(condition.key)", value: jsonString)
        )
        
        return copy
    }
}

// Extension to add environment values to PublishingContext
extension PublishingContext {
    public var colorScheme: ColorScheme { .light }
    
    func environmentScript() -> String {
        """
        <script>
        const igniteEnv = {
            init() {
                const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');
                this.setColorScheme(prefersDark.matches);
                prefersDark.addListener(e => this.setColorScheme(e.matches));
            },
            
            setColorScheme(isDark) {
                const value = isDark ? 'dark' : 'light';
                
                document.querySelectorAll('[data-env-colorscheme]').forEach(el => {
                    const conditions = JSON.parse(el.dataset.envColorscheme);
                    Object.entries(conditions).forEach(([prop, values]) => {
                        el.style[prop] = values[value] || values['default'];
                    });
                });
            }
        };

        document.addEventListener('DOMContentLoaded', () => igniteEnv.init());
        </script>
        """
    }
}
