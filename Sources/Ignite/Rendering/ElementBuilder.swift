//
// ElementBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

typealias BlockElementBuilder = ElementBuilder<BlockElement>
typealias HeadElementBuilder = ElementBuilder<HeadElement>
typealias HTMLRootElementBuilder = ElementBuilder<HTMLRootElement>
typealias InlineElementBuilder = ElementBuilder<InlineElement>
typealias PageElementBuilder = ElementBuilder<PageElement>
typealias StaticPageBuilder = ElementBuilder<any StaticPage>
typealias ContentPageBuilder = ElementBuilder<any ContentPage>

/// A result builder that lets us generically build arrays of some content.
@resultBuilder
public struct ElementBuilder<T> {
    /// Flattens into a one-dimensional array many arrays specified as a variadic parameter.
    /// - Parameter components: A variadic array of elements.
    /// - Returns: A one-dimensional array of elements.
    public static func buildBlock(_ components: [T]...) -> [T] {
        components.flatMap { $0 }
    }

    /// Flattens a two-dimensional array of values into into a one-dimensional array.
    /// This enables loops in our result builder.
    /// - Parameter components: An array of arrays of our type.
    /// - Returns: A one-dimensional array of our type.
    public static func buildArray(_ components: [[T]]) -> [T] {
        components.flatMap { $0 }
    }

    /// Converts a single object into an array of the same type, so we can flatten
    /// using the methods above.
    /// - Parameter expression: A single value of our type.
    /// - Returns: An array of our type, containing that single value.
    public static func buildExpression(_ expression: T) -> [T] {
        [expression]
    }

    /// Accepts an optional array of our type, either returning it if it exists, or
    /// returning an empty array otherwise.
    /// - Parameter component: An optional array of our type.
    /// - Returns: An array of our type, which may be empty.
    public static func buildOptional(_ component: [T]?) -> [T] {
        component ?? []
    }

    /// Returns its input value. Along with buildEither(second:) this enables conditions
    /// in our result builder.
    /// - Returns: The same array, unchanged.
    public static func buildEither(first component: [T]) -> [T] {
        component
    }

    /// Returns its input value. Along with buildEither(first:) this enables conditions
    /// in our result builder.
    /// - Parameter component: An array of our type.
    /// - Returns: The same array, unchanged.
    public static func buildEither(second component: [T]) -> [T] {
        component
    }
}

//extension ElementBuilder {
//    static func buildExpression<Element: BaseElement, Value>(_ expression: (Element, Value)) -> [Element] where Value: Equatable {
//        let (element, condition) = expression
//        
//        let conditionKey = String(describing: type(of: condition))
//            .replacingOccurrences(of: "Value", with: "")
//            .lowercased()
//        
//        // Create a map of all possible values to their visibility state
//        var conditions: [String: Bool] = [:]
//        
//        // For color scheme, we need both light and dark states
//        if conditionKey == "colorscheme" {
//            conditions = [
//                "light": String(describing: condition) == "light",
//                "dark": String(describing: condition) == "dark"
//            ]
//        } else {
//            conditions = [String(describing: condition): true]
//        }
//        
//        // Create group to wrap the element with environment conditions
//        let group = Group {
//            element
//        }
//        
//        // Add data attributes for environment state
//        var groupWithAttr = group.addCustomAttribute(
//            name: "data-ignite-env-\(conditionKey)",
//            value: conditions.json ?? "{}"
//        )
//        
//        // Add initial visibility class based on default value
//        let initialClass = conditions.first { $0.value == true }?.key ?? ""
//        groupWithAttr = groupWithAttr.class("env-\(conditionKey)-\(initialClass)")
//        
//        return [groupWithAttr as! Element]
//    }
//    
//    static func buildExpression<Element: BaseElement>(_ expression: Element) -> [Element] {
//        [expression]
//    }
//}

public extension Dictionary where Key == String, Value == Bool {
    var json: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self),
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        return string
    }
}
