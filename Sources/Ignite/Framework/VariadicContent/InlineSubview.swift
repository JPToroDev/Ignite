//
// InlineSubview.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An opaque value representing the child of another view.
struct InlineSubview: InlineElement {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    private var content: any InlineElement

    /// The underlying HTML content, with attributes.
    var wrapped: any InlineElement {
        var wrapped = content
        wrapped.attributes.merge(attributes)
        return wrapped
    }

    /// Creates a new `Child` instance that wraps the given HTML content.
    /// If the content is already an AnyHTML instance, it will be unwrapped to prevent nesting.
    /// - Parameter content: The HTML content to wrap
    init(_ wrapped: any InlineElement) {
        var content = wrapped
        // Make Child the single source of truth for attributes
        // and modified attributes directly to keep type unchanged
        attributes.merge(content.attributes)
        content.attributes.clear()
        self.content = content
    }

    nonisolated func markup() -> Markup {
        MainActor.assumeIsolated {
            var content = wrapped
            content.attributes.merge(attributes)
            return content.markup()
        }
    }
}

extension InlineSubview: Equatable {
    nonisolated static func == (lhs: InlineSubview, rhs: InlineSubview) -> Bool {
        lhs.markup() == rhs.markup()
    }
}
