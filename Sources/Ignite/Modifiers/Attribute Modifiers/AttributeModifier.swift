//
// AttributeModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func attributeModifier(
    _ attribute: Attribute?,
    content: any HTML
) -> any HTML {
    guard let attribute else { return content }
    var copy = content.attributableContent
    copy.attributes.append(customAttributes: attribute)
    return copy
}

@MainActor private func attributeModifier(
    _ attribute: Attribute?,
    content: any InlineElement
) -> any InlineElement {
    guard let attribute else { return content }
    var copy: any InlineElement = content.isPrimitive ? content : Span(content)
    copy.attributes.append(customAttributes: attribute)
    return copy
}

public extension HTML {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the attribute
    ///   - value: The value of the attribute
    /// - Returns: The modified element
    func attribute(_ name: String, _ value: String) -> some HTML {
        AnyHTML(attributeModifier(.init(name: name, value: value), content: self))
    }

    /// Adds a custom boolean attribute to the element.
    /// - Parameter name: The name of the attribute
    /// - Returns: The modified element
    func attribute(_ name: String) -> some HTML {
        AnyHTML(attributeModifier(.init(name), content: self))
    }
}

public extension InlineElement {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the attribute
    ///   - value: The value of the attribute
    /// - Returns: The modified element
    func attribute(_ name: String, _ value: String) -> some InlineElement {
        AnyInlineElement(attributeModifier(.init(name: name, value: value), content: self))
    }

    /// Adds a custom boolean attribute to the element.
    /// - Parameter name: The name of the attribute
    /// - Returns: The modified element
    func attribute(_ name: String) -> some InlineElement {
        AnyInlineElement(attributeModifier(.init(name), content: self))
    }
}

extension HTML {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(name: String, value: String) -> some HTML {
        AnyHTML(attributeModifier(.init(name: name, value: value), content: self))
    }

    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(_ attribute: Attribute?) -> some HTML {
        AnyHTML(attributeModifier(attribute, content: self))
    }
}

extension InlineElement {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(name: String, value: String) -> some InlineElement {
        AnyInlineElement(attributeModifier(.init(name: name, value: value), content: self))
    }

    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(_ attribute: Attribute?) -> some InlineElement {
        AnyInlineElement(attributeModifier(attribute, content: self))
    }
}
