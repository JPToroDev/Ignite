//
// EnvironmentState.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public class EnvironmentState {
    public static let shared = EnvironmentState()
    private(set) var values: [String: Any] = [:]
    private var defaultValues: [String: Any] = [:]
    private var javascriptBridge: [String: String] = [:]
    private var scriptCache: String?
    
    private init() {}
    
    func setValue(_ value: Any, forKey key: String) {
        values[key] = value
    }
    
    func getValue<T>(_ key: String) -> T? {
        return values[key] as? T
    }
    
    // Register JavaScript bridge
    func registerJavaScriptBridge(key: String, eventName: String) {
        javascriptBridge[key] = eventName
    }
    
    // Generate JavaScript for all registered bridges
    func generateBridgeJavaScript() -> String {
        if let cached = scriptCache {
            return cached
        }
        
        var script = ""
        for (key, eventName) in javascriptBridge {
            script += """
                window.addEventListener('\(eventName)', function(event) {
                    document.documentElement.dataset.\(key.lowercased()) = event.detail.\(key.lowercased());
                    document.dispatchEvent(new CustomEvent('environment-\(key.lowercased())-change', {
                        detail: event.detail
                    }));
                });
                
            """
        }
        
        // Add runtime value getters
        script += """
            function getEnvironmentValue(key) {
                return document.documentElement.dataset[key.toLowerCase()];
            }
        """
        
        scriptCache = script
        return script
    }
    
    // Get the initialization script for a specific key
    func generateInitScript(for key: String) -> String {
        """
        <script>
            (function() {
                const value = document.documentElement.dataset.\(key.lowercased());
                if (value) {
                    const detail = {};
                    detail.\(key.lowercased()) = value;
                    document.dispatchEvent(new CustomEvent('environment-\(key.lowercased())-change', {
                        detail: detail
                    }));
                }
            })();
        </script>
        """
    }
}
