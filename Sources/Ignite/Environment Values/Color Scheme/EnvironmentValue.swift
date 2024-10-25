//
// EnvironmentValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

//public struct EnvironmentKey {
//    let name: String
//    
//    public static let colorScheme = EnvironmentKey(name: "colorScheme")
//}

@propertyWrapper
public struct Environment<Value: Equatable> {
    let key: String
    let defaultValue: Value

    public init(_ key: String, default defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: Value {
        defaultValue
    }
}

extension BlockElement {
    func addEnvironmentCondition(key: String, value: String) -> Self {
        var copy = self
        copy.attributes.customAttributes.append(
            AttributeValue(name: "data-ignite-env-\(key)", value: value)
        )
        return copy
    }
}
