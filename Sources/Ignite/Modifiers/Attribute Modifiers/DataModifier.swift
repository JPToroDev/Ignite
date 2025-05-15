//
// DataModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func dataModifier(
    _ name: String,
    value: String, content: some HTML
) -> some HTML {
    var modifiedHTML = ModifiedHTML(content)
    modifiedHTML.attributes.data.append(.init(name: name, value: value))
    return modifiedHTML
}

@MainActor private func dataModifier(
    _ name: String,
    value: String,
    content: some InlineElement
) -> some InlineElement {
    var modifiedHTML = ModifiedInlineElement(content)
    modifiedHTML.attributes.data.append(.init(name: name, value: value))
    return modifiedHTML
}

public extension HTML {
    /// Adds a data attribute to the element.
    /// - Parameters:
    ///   - name: The name of the data attribute
    ///   - value: The value of the data attribute
    /// - Returns: The modified `HTML` element
    func data(_ name: String, _ value: String) -> some HTML {
        dataModifier(name, value: value, content: self)
    }
}

public extension InlineElement {
    /// Adds a data attribute to the element.
    /// - Parameters:
    ///   - name: The name of the data attribute
    ///   - value: The value of the data attribute
    /// - Returns: The modified `HTML` element
    func data(_ name: String, _ value: String) -> some InlineElement {
        dataModifier(name, value: value, content: self)
    }
}
