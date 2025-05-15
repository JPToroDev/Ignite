//
// Label.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A form label with support for various styles
struct ControlLabel: InlineElement {
    /// The content and behavior of this HTML.
    var body: some InlineElement { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The text content of the label
    private let text: any InlineElement

    /// Creates a new control label with the specified text content.
    /// - Parameter text: The inline element to display within the label.
    init(_ text: any InlineElement) {
        self.text = text
    }

    func markup() -> Markup {
        let textHTML = text.markupString()
        return Markup("<label\(attributes)>\(textHTML)</label>")
    }
}
