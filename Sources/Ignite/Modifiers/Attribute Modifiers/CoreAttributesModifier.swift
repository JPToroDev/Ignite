//
// CoreAttributesModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func coreAttributesModifier(
    _ attributes: CoreAttributes,
    content: some HTML
) -> some HTML {
    var modified = ModifiedHTML(content)
    modified.attributes.merge(attributes)
    return modified
}

@MainActor private func coreAttributesModifier(
    _ attributes: CoreAttributes,
    content: some InlineElement
) -> some InlineElement {
    var modified = ModifiedInlineElement(content)
    modified.attributes.merge(attributes)
    return modified
}

//@MainActor private func coreAttributesModifier(
//    _ attributes: CoreAttributes,
//    content: any BodyElement
//) -> any BodyElement {
//    var copy = content
//    copy.attributes.merge(attributes)
//    return copy
//}

public extension HTML {
    /// Merges a complete set of core attributes into this element.
    /// - Parameter attributes: The CoreAttributes to merge with existing attributes
    /// - Returns: The modified `HTML` element
    /// - Note: Uses AttributeStore for persistent storage and merging
    func attributes(_ attributes: CoreAttributes) -> some HTML {
        coreAttributesModifier(attributes, content: self)
    }
}

public extension InlineElement {
    /// Merges a complete set of core attributes into this element.
    /// - Parameter attributes: The CoreAttributes to merge with existing attributes
    /// - Returns: The modified `HTML` element
    /// - Note: Uses AttributeStore for persistent storage and merging
    func attributes(_ attributes: CoreAttributes) -> some InlineElement {
        coreAttributesModifier(attributes, content: self)
    }
}

//extension BodyElement {
//    /// Merges a complete set of core attributes into this element.
//    /// - Parameter attributes: The CoreAttributes to merge with existing attributes
//    /// - Returns: The modified HTML element
//    /// - Note: Uses AttributeStore for persistent storage and merging
//    func attributes(_ attributes: CoreAttributes) -> some BodyElement {
//        AnyHTML(coreAttributesModifier(attributes, content: self))
//    }
//}
