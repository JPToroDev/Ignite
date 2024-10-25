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
            EnvironmentState.shared.getValue(keyPath.key) ?? defaultValue
        }
    }
    
    public init(_ keyPath: EnvironmentValues, default: Value) {
        self.keyPath = keyPath
        self.defaultValue = `default`
    }
}
