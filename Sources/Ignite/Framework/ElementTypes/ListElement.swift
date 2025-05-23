//
// InlineElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An element that handles list rendering by placing its <li> tag manually.
@MainActor
protocol ListElement {
    /// The standard set of control attributes for HTML elements.
    var attributes: CoreAttributes { get set }

    /// Render this when we know for sure we're part of a `List`.
    func markupAsListItem() -> Markup
}

extension ListElement where Self: HTML {
    /// Renders this element inside a list.
    /// - Returns: The HTML for this element.
    func markupAsListItem() -> Markup {
        // For most items, we do nothing special here,
        // so by default, just send back the default markup.
        markup()
    }
}
