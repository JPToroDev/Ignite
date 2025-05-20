//
// Child.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An opaque value representing the child of another view.
struct Child: HTML {
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

    func markup() -> Markup {
        wrapped.markup()
    }
}

extension Child: NavigationItemConfigurable {
    func configuredAsNavigationItem() -> NavigationItem {
        if let wrapped = wrapped as? any NavigationItemConfigurable {
            wrapped.configuredAsNavigationItem()
        } else {
            NavigationItem(self)
        }
    }
}

extension Child: AccordionItemAssignable {
    func assigned(to parentID: String, openMode: AccordionOpenMode) -> Self {
        if let wrapped = wrapped as? any AccordionItemAssignable & HTML {
            Child(wrapped.assigned(to: parentID, openMode: openMode))
        } else {
           self
        }
    }
}

@MainActor
protocol AccordionItemAssignable {
    func assigned(to parentID: String, openMode: AccordionOpenMode) -> Self
}
