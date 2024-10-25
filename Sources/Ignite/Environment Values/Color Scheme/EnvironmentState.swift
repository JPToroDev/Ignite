//
// EnvironmentState.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public class EnvironmentState {
    public static let shared = EnvironmentState()
    private var registeredValues: Set<String> = []
    private var scriptCache: String?
    
    private init() {}
    
    func register(_ environmentValue: any EnvironmentValue) {
        registeredValues.insert(environmentValue.key)
    }
    
    func generateRuntimeScript() -> String {
        if let cached = scriptCache {
            return cached
        }
        
        let script = """
        window.igniteEnvironment = {
            observers: new Set(),
            
            setValue(key, value) {
                document.documentElement.dataset[key.toLowerCase()] = value;
                this.updateConditionalElements(key, value);
            },
            
            updateConditionalElements(key, value) {
                document.querySelectorAll(`[data-ignite-env-${key.toLowerCase()}]`).forEach(element => {
                    const conditions = JSON.parse(element.dataset[`igniteEnv${key}`] || '{}');
                    const show = conditions[value] === true;
                    element.style.display = show ? '' : 'none';
                });
            },
            
            observe(key, callback) {
                this.observers.add({ key, callback });
            },
            
            notifyObservers(key, value) {
                this.observers.forEach(observer => {
                    if (observer.key === key) observer.callback(value);
                });
            }
        };
        """
        
        scriptCache = script
        return script
    }
}
