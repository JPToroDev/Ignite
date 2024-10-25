//
// ColorScheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

//public enum ColorScheme: String {
//    case light
//    case dark
//}

// EnvironmentValues.swift
public protocol EnvironmentValue {
    associatedtype Value: Equatable
    static var key: String { get }
    static var defaultValue: Value { get }
}

public enum ColorScheme: String, Equatable {
    case light
    case dark
}

public struct ColorSchemeEnvironmentValue: EnvironmentValue {
    public typealias Value = ColorScheme
    public static var key: String { "colorscheme" }
    public static var defaultValue: ColorScheme { .dark }
}

// Can easily add more environment values:
public enum Orientation: String, Equatable {
    case portrait, landscape
}

public struct OrientationEnvironmentValue: EnvironmentValue {
    public typealias Value = Orientation
    public static var key: String { "orientation" }
    public static var defaultValue: Orientation { .portrait }
}

public struct EnvironmentGroup: BlockElement {
    let condition: EnvironmentCondition
    let trueElements: [BlockElement]
    let falseElements: [BlockElement]
    
    public var attributes = CoreAttributes()
    public var columnWidth: ColumnWidth = .automatic
    public var horizontalAlignment: HorizontalAlignment = .leading
    
    public func width(_ width: Int) -> Self {
        var copy = self
        copy.columnWidth = .count(width)
        return copy
    }
    
    public func aligned(_ alignment: HorizontalAlignment) -> Self {
        var copy = self
        copy.horizontalAlignment = alignment
        return copy
    }
    
    public func render(context: PublishingContext) -> String {
        let trueContent = Group(items: trueElements, context: context).render(context: context)
        let falseContent = Group(items: falseElements, context: context).render(context: context)
        
        // Get the opposite value based on the environment key's possible values
        let oppositeValue = getOppositeValue(for: condition)
        
        let conditions = [
            condition.value: condition.comparison,
            oppositeValue: !condition.comparison
        ]
        
        let conditionsJSON = conditions.json ?? "{}"
        
        var classes = ["env-\(condition.key)-\(condition.value)"]
        
        if horizontalAlignment != .leading {
            classes.append(horizontalAlignment.rawValue)
        }
        
        if !attributes.classes.isEmpty {
            classes.append(contentsOf: attributes.classes)
        }
        
        let classAttribute = classes.isEmpty ? "" : " class='\(classes.joined(separator: " "))'"
        
        return """
        <div data-ignite-env-\(condition.key)='\(conditionsJSON)'\(classAttribute)>
            <div class="env-true">\(trueContent)</div>
            <div class="env-false">\(falseContent)</div>
        </div>
        """
    }
    
    private func getOppositeValue(for condition: EnvironmentCondition) -> String {
        // Add cases here for new environment values as needed
        switch condition.key {
        case ColorSchemeEnvironmentValue.key:
            return condition.value == "light" ? "dark" : "light"
        case OrientationEnvironmentValue.key:
            return condition.value == "portrait" ? "landscape" : "portrait"
        default:
            return "" // Default case for unknown environment values
        }
    }
}

// EnvironmentCondition.swift
public struct EnvironmentCondition {
    let key: String
    let value: String
    let comparison: Bool
}

// Environment.swift
@propertyWrapper
public struct Environment<Value: EnvironmentValue> {
    let defaultValue: Value.Value
    let valueType: Value.Type
    
    public init(_ type: Value.Type, default: Value.Value) {
        self.valueType = type
        self.defaultValue = `default`
    }
    
    public var wrappedValue: Value.Value {
        defaultValue // Only used at build time
    }
}

// Environment+Operators.swift
infix operator ~=: ComparisonPrecedence

extension Environment {
    public static func == (lhs: Self, rhs: Value.Value) -> EnvironmentCondition where Value.Value: RawRepresentable, Value.Value.RawValue == String {
        EnvironmentCondition(
            key: Value.key,
            value: rhs.rawValue,
            comparison: true
        )
    }
    
    public static func ~= (lhs: Self, rhs: Value.Value) -> EnvironmentCondition where Value.Value: RawRepresentable, Value.Value.RawValue == String {
        EnvironmentCondition(
            key: Value.key,
            value: rhs.rawValue,
            comparison: true
        )
    }
}

// ElementBuilder+Environment.swift
extension ElementBuilder {
    public static func buildIf(_ condition: EnvironmentCondition) -> EnvironmentBuildPhase {
        EnvironmentBuildPhase(condition: condition)
    }
}

public struct EnvironmentBuildPhase {
    let condition: EnvironmentCondition
    var trueElements: [BlockElement] = []
    var falseElements: [BlockElement] = []
    
    public static func buildBlock(_ elements: BlockElement...) -> [BlockElement] {
        elements
    }
}
