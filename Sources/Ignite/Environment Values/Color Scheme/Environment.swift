//
// Environment.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

@propertyWrapper
public struct Environment<Value> {
    private let keyPath: EnvironmentValues
    private let defaultValue: Value
    
    public var wrappedValue: Value {
        get {
            // Register the bridge for this environment value
            EnvironmentState.shared.registerJavaScriptBridge(
                key: keyPath.key,
                eventName: keyPath.eventName
            )
            
            // Get the build-time value or default
            if let value: Value = EnvironmentState.shared.getValue(keyPath.key) {
                return value
            } else {
                return defaultValue
            }
        }
    }
    
    public init(_ keyPath: EnvironmentValues, default: Value) {
        self.keyPath = keyPath
        self.defaultValue = `default`
    }
}
