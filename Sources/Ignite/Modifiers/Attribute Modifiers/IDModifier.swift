//
// IDModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func idModifier(
    _ id: String,
    content: some HTML
) -> some HTML {
    var modified = ModifiedHTML(content)
    guard !id.isEmpty else { return modified }
    modified.attributes.id = id
    return modified
}

@MainActor private func idModifier(
    _ id: String,
    content: some InlineElement
) -> some InlineElement {
    var modified = ModifiedInlineElement(content)
    guard !id.isEmpty else { return modified }
    modified.attributes.id = id
    return modified
}

public extension HTML {
    /// Sets the `HTML` id attribute of the element.
    /// - Parameter id: The HTML ID value to set
    /// - Returns: A modified copy of the element with the HTML id added
    func id(_ id: String) -> some HTML {
        idModifier(id, content: self)
    }
}

public extension InlineElement {
    /// Sets the `HTML` id attribute of the element.
    /// - Parameter id: The HTML ID value to set
    /// - Returns: A modified copy of the element with the HTML ID added
    func id(_ id: String) -> some InlineElement {
        idModifier(id, content: self)
    }
}
