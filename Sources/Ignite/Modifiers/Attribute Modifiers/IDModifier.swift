//
// IDModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct IDModifier: HTMLModifier {
    var id: String
    func body(content: Content) -> some HTML {
        var content = content
        guard !id.isEmpty else { return content }
        content.attributes.id = id
        return content
    }
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
        modifier(IDModifier(id: id))
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
