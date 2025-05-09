//
// Ruleset-Selector.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension Ruleset {
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
            Selector("[\(name)=\"\(value)\"]")
        }

        /// Creates a class selector
        /// - Parameter name: The class name
        /// - Returns: A selector for the specified class
        static func `class`(_ name: String) -> Selector {
            Selector(".\(name)")
        }

        /// Creates a pseudo-class selector
        /// - Parameter name: The pseudo-class name
        /// - Returns: A selector for the specified pseudo-class
        static func pseudoClass(_ name: String) -> Selector {
            Selector(":\(name)")
        }

        /// Creates a type selector
        /// - Parameter name: The element type name
        /// - Returns: A selector for the specified element type
        static func type(_ name: String) -> Selector {
            Selector(name)
        }

        /// Combines this selector with another selector using a comma
        /// - Parameter other: The selector to combine with
        /// - Returns: A new selector that matches either this selector or the other selector
        func or(_ other: Selector) -> Selector {
            Selector("\(value), \(other.value)")
        }

        /// Combines this selector with another selector using a space
        /// - Parameter other: The selector to combine with
        /// - Returns: A new selector that matches elements that are descendants of the current selector
        func and(_ other: Selector) -> Selector {
            Selector("\(value) \(other.value)")
        }

        /// Combines this selector with another selector without a space
        /// - Parameter other: The selector to combine with
        /// - Returns: A new selector that matches elements with both selectors
        func with(_ other: Selector) -> Selector {
            Selector("\(value)\(other.value)")
        }
    }
}
