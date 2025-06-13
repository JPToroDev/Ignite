//
// Child.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An opaque value representing the child of another view.
struct Subview: HTML {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    private var content: any HTML

    /// The underlying HTML content, with attributes.
    var wrapped: any HTML {
        var wrapped = content
        wrapped.attributes.merge(attributes)
        return wrapped
    }

    /// Creates a new `Child` instance that wraps the given HTML content.
    /// If the content is already an AnyHTML instance, it will be unwrapped to prevent nesting.
    /// - Parameter content: The HTML content to wrap
    init(_ wrapped: any HTML) {
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

extension Subview: Equatable {
    nonisolated static func == (lhs: Subview, rhs: Subview) -> Bool {
        lhs.markup() == rhs.markup()
    }
}

extension Subview {
    func configuredAsCardItem() -> Self {
        switch wrapped {
        case let text as any TextProvider & HTML where text.fontStyle == .body || text.fontStyle == .lead:
            var item = Subview(text)
            item.attributes.append(classes: "card-text")
            return item
        case is any TextProvider:
            var item = Subview(wrapped)
            item.attributes.append(classes: "card-title")
            return item
        case is any LinkProvider:
            var item = Subview(wrapped)
            item.attributes.append(classes: "card-link")
            return item
        case is any ImageElement:
            var item = Subview(wrapped)
            item.attributes.append(classes: "card-img")
            return item
        default:
            return self
        }
    }
}

extension Subview {
    func resolvedToGridItems() -> [GridItem] {
        if let row = wrapped as? any GridItemProvider {
            return row.gridItems()
        } else {
            // Elements not wrapped in a GridRow will take up the full width
            var item = GridItem(self.wrapped)
            item.isFullWidth = true
            return [item]
        }
    }
}
