//
// Action.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// One action that can be triggered on the page. Actions compile
/// to JavaScript.
public protocol Action: Sendable {
    /// Convert this action into the equivalent JavaScript code.
    func compile() -> String
}

// Environment state handler
public class EnvironmentState {
    public static let shared = EnvironmentState()
    private(set) var values: [String: Any] = [:]
    
    private init() {}
    
    func setValue(_ value: Any, forKey key: String) {
        values[key] = value
    }
    
    func getValue<T>(_ key: String) -> T? {
        return values[key] as? T
    }
}

// Dark mode detector that updates our environment state
struct ColorSchemeDetectorAction: Action {
    func compile() -> String {
        // Set initial value to light
        EnvironmentState.shared.setValue(ColorScheme.light, forKey: EnvironmentValues.colorScheme.key)
        
        return """
        <script>
            function updateColorScheme() {
                const isDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
                document.documentElement.classList.toggle('dark', isDark);
                
                // Dispatch event for any components that need to react
                window.dispatchEvent(new CustomEvent('colorSchemeChange', { 
                    detail: { colorScheme: isDark ? 'dark' : 'light' } 
                }));
            }
            
            updateColorScheme();
            
            window.matchMedia('(prefers-color-scheme: dark)')
                .addEventListener('change', updateColorScheme);
        </script>
        """
    }
}
