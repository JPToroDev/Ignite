//
// CoreAttributesModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func coreAttributesModifier(
    _ attributes: CoreAttributes,
    content: any HTML
) -> any HTML {
    var copy = content.attributableContent
    copy.attributes.merge(attributes)
    return copy
}

@MainActor private func coreAttributesModifier(
    _ attributes: CoreAttributes,
    content: any InlineElement
) -> any InlineElement {
    var copy: any InlineElement = content.isPrimitive ? content : Span(content)
    copy.attributes.merge(attributes)
    return copy
}

@MainActor private func coreAttributesModifier(
    _ attributes: CoreAttributes,
    content: any BodyElement
) -> any BodyElement {
    var copy: any BodyElement = if let element = content as? any HTML {
        coreAttributesModifier(attributes, content: element)
    } else if let element = content as? any InlineElement {
        coreAttributesModifier(attributes, content: element)
    } else {
        content
    }
    copy.attributes.merge(attributes)
    return copy
}

public extension BodyElement where Self: HTML {
    /// Merges a complete set of core attributes into this element.
    /// - Parameter attributes: The CoreAttributes to merge with existing attributes
    /// - Returns: The modified `HTML` element
    /// - Note: Uses AttributeStore for persistent storage and merging
    func attributes(_ attributes: CoreAttributes) -> some HTML {
        AnyHTML(coreAttributesModifier(attributes, content: self))
    }
}

public extension BodyElement where Self: InlineElement {
    /// Merges a complete set of core attributes into this element.
    /// - Parameter attributes: The CoreAttributes to merge with existing attributes
    /// - Returns: The modified `HTML` element
    /// - Note: Uses AttributeStore for persistent storage and merging
    func attributes(_ attributes: CoreAttributes) -> some InlineElement {
        AnyInlineElement(coreAttributesModifier(attributes, content: self))
    }
}

extension BodyElement {
    /// Merges a complete set of core attributes into this element.
    /// - Parameter attributes: The CoreAttributes to merge with existing attributes
    /// - Returns: The modified HTML element
    /// - Note: Uses AttributeStore for persistent storage and merging
    func attributes(_ attributes: CoreAttributes) -> some BodyElement {
        AnyHTML(coreAttributesModifier(attributes, content: self))
    }
}
