//
// AttributeModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct AttributeModifier: HTMLModifier {
    var attribute: Attribute?
    func body(content: Content) -> some HTML {
        var content = content
        guard let attribute else { return content }
        content.attributes.append(customAttributes: attribute)
        return content
    }
}

@MainActor private func attributeModifier(
    _ attribute: Attribute?,
    content: some InlineElement
) -> some InlineElement {
    var modified = ModifiedInlineElement(content)
    guard let attribute else { return modified }
    modified.attributes.append(customAttributes: attribute)
    return modified
}

public extension HTML {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the attribute
    ///   - value: The value of the attribute
    /// - Returns: The modified element
    func attribute(_ name: String, _ value: String) -> some HTML {
        modifier(AttributeModifier(attribute: .init(name: name, value: value)))
    }

    /// Adds a custom boolean attribute to the element.
    /// - Parameter name: The name of the attribute
    /// - Returns: The modified element
    func attribute(_ name: String) -> some HTML {
        modifier(AttributeModifier(attribute: .init(name)))
    }
}

public extension InlineElement {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the attribute
    ///   - value: The value of the attribute
    /// - Returns: The modified element
    func attribute(_ name: String, _ value: String) -> some InlineElement {
        attributeModifier(.init(name: name, value: value), content: self)
    }

    /// Adds a custom boolean attribute to the element.
    /// - Parameter name: The name of the attribute
    /// - Returns: The modified element
    func attribute(_ name: String) -> some InlineElement {
       attributeModifier(.init(name), content: self)
    }
}

extension HTML {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(name: String, value: String) -> some HTML {
        modifier(AttributeModifier(attribute: .init(name: name, value: value)))
    }

    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(_ attribute: Attribute?) -> some HTML {
        modifier(AttributeModifier(attribute: attribute))
    }
}

extension InlineElement {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(name: String, value: String) -> some InlineElement {
       attributeModifier(.init(name: name, value: value), content: self)
    }

    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(_ attribute: Attribute?) -> some InlineElement {
        attributeModifier(attribute, content: self)
    }
}
