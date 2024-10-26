//
// EnvironmentValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public struct EnvironmentKey {
    let name: String
    
    public static let colorScheme = EnvironmentKey(name: "colorScheme")
}

// Environment.swift
@propertyWrapper
public struct Environment<Value: Equatable> {
    let key: EnvironmentKey
    let defaultValue: Value
    
    public init(_ key: EnvironmentKey, default defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: Value {
        defaultValue
    }
}

// ElementBuilder.swift extension
extension ElementBuilder {
    static func buildExpression<Element: BaseElement, Value>(_ expression: (Element, Value)) -> [Element] where Value: Equatable {
        let (element, condition) = expression
        
        // Normalize the environment key
        let conditionKey = String(describing: type(of: condition))
            .replacingOccurrences(of: "Value", with: "")
            .lowercased()
        
        // Create the current value string
        let currentValue = String(describing: condition)
        
        // Create group to wrap the element
        let group = Group {
            element
        }
        
        // Add environment attribute
        var groupWithAttr = group.addCustomAttribute(
            name: "data-ignite-env-\(conditionKey)",
            value: currentValue
        )
        
        // Add visibility class
        groupWithAttr = groupWithAttr.class("env-\(conditionKey)")
        
        return [groupWithAttr as! Element]
    }
}
