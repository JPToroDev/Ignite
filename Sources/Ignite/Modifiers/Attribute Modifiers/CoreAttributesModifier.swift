//
// CoreAttributesModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension HTML {
    /// Merges a complete set of core attributes into this element.
    /// - Parameter attributes: The CoreAttributes to merge with existing attributes
    /// - Returns: The modified `HTML` element
    /// - Note: Uses AttributeStore for persistent storage and merging
    func attributes(_ attributes: CoreAttributes) -> some HTML {
        var modified = ModifiedHTML(self)
        modified.attributes.merge(attributes)
        return modified
    }
}

extension InlineElement {
    /// Merges a complete set of core attributes into this element.
    /// - Parameter attributes: The CoreAttributes to merge with existing attributes
    /// - Returns: The modified `HTML` element
    /// - Note: Uses AttributeStore for persistent storagex and merging
    func attributes(_ attributes: CoreAttributes) -> some InlineElement {
        var modified = ModifiedInlineElement(self)
        modified.attributes.merge(attributes)
        return modified
    }
}
