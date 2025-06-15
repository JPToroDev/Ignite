//
// InlineHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents the HTML representation of `InlineElement`.
public struct InlineHTML<Content: InlineElement>: HTML {
    /// The body of this HTML element.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    private var content: Content

    /// Creates a new `InlineHTML` instance that wraps the given HTML content.
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

extension InlineHTML: ImageProvider where Content: ImageProvider {}

extension InlineHTML: CardComponentConfigurable where Content: CardComponentConfigurable {
    func configuredAsCardComponent() -> CardComponent {
        content.configuredAsCardComponent()
    }
}

extension InlineHTML: @MainActor LinkProvider where Content: LinkProvider {
    var url: String {
        content.url
    }
}

extension InlineHTML: NavigationElement where Content: NavigationElement {}

extension InlineHTML: NavigationElementRepresentable where Content: NavigationElementRepresentable {
    func renderAsNavigationElement() -> Markup {
        content.renderAsNavigationElement()
    }
}
