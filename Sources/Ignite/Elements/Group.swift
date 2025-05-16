//
// Group.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A transparent grouping construct that propagates modifiers to its children.
///
/// Use `Group` when you want to apply shared modifiers to multiple elements
/// without introducing additional HTML structure. Unlike ``Section``, `Group`
/// doesn't wrap its children in a `div`; instead, it passes modifiers through
/// to each child element.
///
/// - Note: `Group` is particularly useful for applying shared styling or
///         attributes to multiple elements without affecting the document
///         structure. If you need a containing `div` element, use
///         ``Section`` instead.
public struct Group<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The child elements contained within this group.
    var content: Content

    /// Creates a new group containing the given HTML content.
    /// - Parameter content: A closure that creates the HTML content.
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }

    /// Creates a new group containing the given HTML content.
    /// - Parameter content: The HTML content to include.
    public init(_ content: Content) {
        self.content = content
    }

    public func markup() -> Markup {
        content.attributes(attributes).markup()
    }
}

extension Group: HTMLCollection {
    var children: VariadicHTML {
        VariadicHTML { content }
    }
}
