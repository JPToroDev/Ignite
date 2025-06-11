//
// CoreAttributesModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct CoreAttributeModifier: HTMLModifier {
    var attributes: CoreAttributes
    func body(content: Content) -> some HTML {
        var content = content
        content.attributes.merge(attributes)
        return content
    }
}

extension HTML {
    /// Merges a complete set of core attributes into this element.
    /// - Parameter attributes: The CoreAttributes to merge with existing attributes
    /// - Returns: The modified `HTML` element
    func attributes(_ attributes: CoreAttributes) -> some HTML {
        modifier(CoreAttributeModifier(attributes: attributes))
    }
}

extension InlineElement {
    /// Merges a complete set of core attributes into this element.
    /// - Parameter attributes: The CoreAttributes to merge with existing attributes
    /// - Returns: The modified `HTML` element
    func attributes(_ attributes: CoreAttributes) -> some InlineElement {
        var modified = ModifiedInlineElement(self)
        modified.attributes.merge(attributes)
        return modified
    }
}
