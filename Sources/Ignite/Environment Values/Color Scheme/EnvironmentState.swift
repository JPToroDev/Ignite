//
// EnvironmentState.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public class EnvironmentState {
    public static let shared = EnvironmentState()
    public var registeredValues: Set<String> = []
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
            state: new Map(),
            
            initialize() {
                // Restore any saved state from localStorage
                try {
                    const saved = localStorage.getItem('igniteEnvironment');
                    if (saved) {
                        const state = JSON.parse(saved);
                        Object.entries(state).forEach(([key, value]) => {
                            this.state.set(key, value);
                            this.updateElements(key, value);
                        });
                    }
                } catch (error) {
                    console.warn('Failed to restore environment state:', error);
                }
            },
            
            setValue(key, value) {
                key = key.toLowerCase();
                if (this.state.get(key) === value) return;
                
                this.state.set(key, value);
                this.updateElements(key, value);
                this.notifyObservers(key, value);
                
                // Persist state changes
                try {
                    const state = Object.fromEntries(this.state);
                    localStorage.setItem('igniteEnvironment', JSON.stringify(state));
                } catch (error) {
                    console.warn('Failed to persist environment state:', error);
                }
            },
            
            updateElements(key, value) {
                requestAnimationFrame(() => {
                    document.querySelectorAll(`[data-ignite-env-${key}]`).forEach(element => {
                        try {
                            const conditions = JSON.parse(element.dataset[`igniteEnv${key}`] || '{}');
                            
                            // Remove all existing environment classes
                            Object.keys(conditions).forEach(state => {
                                element.classList.remove(`env-${key}-${state}`);
                            });
                            
                            // Add class for current state
                            element.classList.add(`env-${key}-${value}`);
                            
                            // Update visibility
                            const show = conditions[value] === true;
                            element.style.display = show ? '' : 'none';
                            
                            // Dispatch custom event for other JavaScript to hook into
                            element.dispatchEvent(new CustomEvent('igniteEnvironmentChange', {
                                detail: { key, value, show },
                                bubbles: true
                            }));
                        } catch (error) {
                            console.warn(`Failed to update element for ${key}:`, error);
                        }
                    });
                });
                
                // Update root element
                document.documentElement.dataset[key] = value;
                if (key === 'colorscheme') {
                    document.documentElement.classList.remove('light', 'dark');
                    document.documentElement.classList.add(value);
                }
            },
            
            observe(key, callback) {
                const observer = { key: key.toLowerCase(), callback };
                this.observers.add(observer);
                
                // Call immediately with current state if available
                const currentValue = this.state.get(key.toLowerCase());
                if (currentValue !== undefined) {
                    callback(currentValue);
                }
                
                return () => this.observers.delete(observer);
            },
            
            notifyObservers(key, value) {
                this.observers.forEach(observer => {
                    if (observer.key === key.toLowerCase()) {
                        try {
                            observer.callback(value);
                        } catch (error) {
                            console.warn(`Observer for ${key} failed:`, error);
                        }
                    }
                });
            }
        };
"""
        
        scriptCache = script
        return script
    }
}
