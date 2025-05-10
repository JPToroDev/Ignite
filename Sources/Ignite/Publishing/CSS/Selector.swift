//
// Selector.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Represents different types of CSS selectors
struct Selector {
    let value: String

    private init(_ value: String) {
        self.value = value
    }

    /// Creates an attribute selector
    /// - Parameters:
    ///   - name: The attribute name
    ///   - value: The attribute value
    /// - Returns: A selector for the specified attribute
    static func attribute(_ name: String, value: String) -> Selector {
        .init("[\(name)=\"\(value)\"]")
    }

    /// Creates a class selector
    /// - Parameter name: The class name
    /// - Returns: A selector for the specified class
    static func `class`(_ name: String) -> Selector {
        .init(".\(name)")
    }

    /// Creates a pseudo-class selector
    /// - Parameter name: The pseudo-class name
    /// - Returns: A selector for the specified pseudo-class
    static func pseudoClass(_ name: String) -> Selector {
        .init(":\(name)")
    }

    /// Creates a pseudo-element selector
    /// - Parameter name: The pseudo-element name
    /// - Returns: A selector for the specified pseudo-element
    static func pseudoElement(_ name: String) -> Selector {
        .init("::\(name)")
    }

    /// Creates a type selector
    /// - Parameter name: The element type name
    /// - Returns: A selector for the specified element type
    static func type(_ name: String) -> Selector {
        .init(name)
    }

    /// Creates an ID selector
    /// - Parameter id: The ID value
    /// - Returns: A selector for the specified ID
    static func id(_ id: String) -> Selector {
        .init("#\(id)")
    }

    /// Creates a universal selector that matches all elements
    /// - Returns: A universal selector
    static func universal() -> Selector {
        .init("*")
    }

    /// Creates a selector list that matches any of the provided selectors
    /// - Parameter selectors: The selectors to include in the list
    /// - Returns: A combined selector using the comma separator
    static func list(_ selectors: Selector...) -> Selector {
        .init(selectors.map(\.value).joined(separator: ", "))
    }

    /// Creates a descendant combinator selector that matches elements at any depth inside another element
    /// - Parameter selectors: The sequence of selectors to combine
    /// - Returns: A combined selector using the space separator
    static func anyChild(_ selectors: Selector...) -> Selector {
        .init(selectors.map(\.value).joined(separator: " "))
    }

    /// Creates a child combinator selector that matches only immediate children of an element
    /// - Parameter selectors: The sequence of selectors to combine
    /// - Returns: A combined selector using the > operator
    static func directChild(_ selectors: Selector...) -> Selector {
        .init(selectors.map(\.value).joined(separator: " > "))
    }

    /// Creates a general sibling combinator selector that matches any siblings following an element
    /// - Parameter selectors: The sequence of selectors to combine
    /// - Returns: A combined selector using the ~ operator
    static func anySibling(_ selectors: Selector...) -> Selector {
        .init(selectors.map(\.value).joined(separator: " ~ "))
    }

    /// Creates an adjacent sibling combinator selector that matches only the immediate next sibling
    /// - Parameter selectors: The sequence of selectors to combine
    /// - Returns: A combined selector using the + operator
    static func directSibling(_ selectors: Selector...) -> Selector {
        .init(selectors.map(\.value).joined(separator: " + "))
    }

    /// Combines this selector with another selector without a space
    /// - Parameter other: The selector to combine with
    /// - Returns: A new selector that matches elements with both selectors
    func chaining(_ other: Selector) -> Selector {
        .init("\(value)\(other.value)")
    }
}
