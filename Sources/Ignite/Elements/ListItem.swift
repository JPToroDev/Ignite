//
// ListItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Creates one item in a list. This isn't always needed, because you can place other
/// elements directly into lists if you wish. Use `ListItem` when you specifically
/// need a styled HTML <li> element.
public struct ListItem<Content: HTML>: HTML, ListElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The content of this list item.
    private var content: Content

    /// The badge for this list item.
    private var badge: Badge?

    /// Configures this list item to properly display a badge.
    /// - Parameter badge: The badge to display.
    /// - Returns: A modified list item with proper badge styling.
    public func badge(_ badge: Badge) -> some HTML {
        var copy = self
        copy.badge = badge
        copy.class("d-flex", "justify-content-between", "align-items-center")
        return copy
    }

    /// Sets the role for this list item, which controls its appearance.
    /// - Parameter role: The new role to apply.
    /// - Returns: A new `ListItem` instance with the updated role.
    /// - Note: The role modifier only has an effect when the parent list's style is `.group`.
    public func role(_ role: Role) -> Self {
        var copy = self
        copy.attributes.append(classes: "list-group-item-\(role.rawValue)")
        return copy
    }

    /// Creates a new `ListItem` object using an inline element builder that
    /// returns an array of `HTML` objects to display in the list.
    /// - Parameter content: The content you want to display in your list.
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        let contentHTML = content.markupString()
        let badgeHTML = badge?.markupString() ?? ""
        return Markup("<li\(attributes)>\(contentHTML)\(badgeHTML)</li>")
    }
}
