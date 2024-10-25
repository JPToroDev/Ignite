//
// Environment.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

@propertyWrapper
public struct Environment<Value> {
    private let keyPath: any EnvironmentValue
    private let defaultValue: Value
    
    public var wrappedValue: Value {
        get {
            defaultValue
        }
    }
    
    public init(_ keyPath: any EnvironmentValue, default: Value) {
        self.keyPath = keyPath
        self.defaultValue = `default`
        EnvironmentState.shared.register(keyPath)
    }
}
