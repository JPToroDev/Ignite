//
// InlineHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type-erasing wrapper that can hold any `HTML` content while maintaining protocol conformance.
/// This wrapper also handles unwrapping nested `AnyHTML` instances to prevent unnecessary wrapping layers.
public struct InlineHTML<Content: InlineElement>: HTML {
    /// The body of this HTML element, which is itself
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    var content: Content

    /// Creates a new AnyHTML instance that wraps the given HTML content.
    /// If the content is already an AnyHTML instance, it will be unwrapped to prevent nesting.
    /// - Parameter content: The HTML content to wrap
    init(_ content: Content) {
        self.content = content
    }

    /// Renders the wrapped HTML content using the given publishing context
    /// - Returns: The rendered HTML string
    public func markup() -> Markup {
        var content = content
        content.attributes.merge(attributes)
        return content.markup()
    }
}

extension InlineHTML: ImageElement where Content == Image {}

extension InlineHTML: LinkProvider where Content: LinkProvider {}

extension InlineHTML: NavigationElement where Content: NavigationElement {}

extension InlineHTML: NavigationItemConfigurable where Content: NavigationItemConfigurable {
    func configuredAsNavigationItem() -> NavigationItem {
        content.configuredAsNavigationItem()
    }
}
