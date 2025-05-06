//
// FixedSize.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Forces an element to be sized based on its content rather than expanding to fill its container.
    /// - Returns: A modified copy of the element with fixed sizing applied
    func fixedSize() -> some HTML {
        self.style(.width, "fit-content")
    }
}

public extension InlineElement {
    /// Forces an element to be sized based on its content rather than expanding to fill its container.
    /// - Returns: A modified copy of the element with fixed sizing applied
    func fixedSize() -> some InlineElement {
        self.style(.width, "fit-content")
    }
}
