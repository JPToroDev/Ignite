//
// DataModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func dataModifier(
    _ name: String,
    value: String, content: any RenderableElement
) -> any RenderableElement {
    guard !value.isEmpty else { return content }
    var copy: any RenderableElement = content.isPrimitive ? content : Section(content)
    copy.attributes.data.append(.init(name: name, value: value))
    return copy
}

@MainActor private func dataModifier(
    _ name: String,
    value: String,
    content: any InlineElement
) -> any InlineElement {
    guard !value.isEmpty else { return content }
    var copy: any InlineElement = content.isPrimitive ? content : Span(content)
    copy.attributes.data.append(.init(name: name, value: value))
    return copy
}

public extension HTML {
    /// Adds a data attribute to the element.
    /// - Parameters:
    ///   - name: The name of the data attribute
    ///   - value: The value of the data attribute
    /// - Returns: The modified `HTML` element
    func data(_ name: String, _ value: String) -> some HTML {
        AnyHTML(dataModifier(name, value: value, content: self))
    }
}

public extension InlineElement {
    /// Adds a data attribute to the element.
    /// - Parameters:
    ///   - name: The name of the data attribute
    ///   - value: The value of the data attribute
    /// - Returns: The modified `HTML` element
    func data(_ name: String, _ value: String) -> some InlineElement {
        AnyInlineElement(dataModifier(name, value: value, content: self))
    }
}

public extension HTML where Self: HeadElement {
    /// Adds a data attribute to the element.
    /// - Parameters:
    ///   - name: The name of the data attribute
    ///   - value: The value of the data attribute
    /// - Returns: The modified `HTML` element
    func data(_ name: String, _ value: String) -> some HeadElement {
        var copy = self
        copy.attributes.data.append(.init(name: name, value: value))
        return copy
    }
}

extension RenderableElement {
    /// Adds a data attribute to the element.
    /// - Parameters:
    ///   - name: The name of the data attribute
    ///   - value: The value of the data attribute
    /// - Returns: The modified `Element` element
    func data(_ name: String, _ value: String) -> some RenderableElement {
        AnyHTML(dataModifier(name, value: value, content: self))
    }
}
