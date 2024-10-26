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
    let matchValue: String
    let property: String
    let whenTrue: String
    let whenFalse: String
}

public func ==(lhs: ColorScheme, rhs: ColorScheme) -> EnvironmentCondition {
    EnvironmentCondition(
        key: "colorscheme",
        matchValue: rhs.rawValue,
        property: "display",
        whenTrue: "none",   // When condition matches, hide
        whenFalse: "block"  // When condition doesn't match, show
    )
}

// Extension to add environment-aware modifiers
extension PageElement {
    public func hidden(_ condition: EnvironmentCondition) -> Self {
        var copy = self
        
        // Create conditional styles that will show the element
        // only when the environment value DOESN'T match
        let values: [String: String]
        if condition.matchValue == "light" {
            values = [
                "light": condition.whenTrue,
                "dark": condition.whenFalse
            ]
        } else {
            values = [
                "dark": condition.whenTrue,
                "light": condition.whenFalse
            ]
        }
        
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
    
//    func environmentScript() -> String {
//        """
//        <script>
//        const igniteEnv = {
//            init() {
//                const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');
//                this.setColorScheme(prefersDark.matches);
//                prefersDark.addListener(e => this.setColorScheme(e.matches));
//            },
//            
//            setColorScheme(isDark) {
//                const value = isDark ? 'dark' : 'light';
//                
//                document.querySelectorAll('[data-env-colorscheme]').forEach(el => {
//                    const conditions = JSON.parse(el.dataset.envColorscheme);
//                    Object.entries(conditions).forEach(([prop, values]) => {
//                        el.style[prop] = values[value] || values['default'];
//                    });
//                });
//            }
//        };
//
//        document.addEventListener('DOMContentLoaded', () => igniteEnv.init());
//        </script>
//        """
//    }
}

extension HTML {
    public func render(context: PublishingContext) -> String {
        var output = "<!doctype html>"
        output += "<html lang=\"\(context.site.language.rawValue)\" data-bs-theme=\"light\"\(attributes.description)>"
        output += head?.render(context: context) ?? ""
        output += context.environmentScript()  // Add the script here
        output += body?.render(context: context) ?? ""
        output += "</html>"
        return output
    }
}

extension PublishingContext {
    func environmentScript() -> String {
        """
        <script>
        const igniteEnv = {
            init() {
                // Set up initial state
                const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');
                this.setColorScheme(prefersDark.matches);
                
                // Listen for changes
                prefersDark.addEventListener('change', e => this.setColorScheme(e.matches));
            },
            
            setColorScheme(isDark) {
                const value = isDark ? 'dark' : 'light';
                document.documentElement.dataset.scheme = value;
                
                // Update all elements with color scheme conditions
                document.querySelectorAll('[data-env-colorscheme]').forEach(el => {
                    const settings = JSON.parse(el.dataset.envColorscheme);
                    if (settings.display) {
                        el.style.display = settings.display[value];
                    }
                });
            }
        };

        // Initialize when page loads
        window.addEventListener('DOMContentLoaded', () => igniteEnv.init());
        </script>
        """
    }
}
