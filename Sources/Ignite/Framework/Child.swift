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

    init(_ wrapped: Any) {
        var content = wrapped
        // Make Child the single source of truth for attributes
        // and modified attributes directly to keep type unchanged
        if var html = content as? any HTML {
            attributes.merge(html.attributes)
            html.attributes.clear()
            self.content = html
        } else {
            self.content = EmptyHTML()
        }
    }

    nonisolated func markup() -> Markup {
        MainActor.assumeIsolated {
            var content = wrapped
            content.attributes.merge(attributes)
            return content.markup()
        }
    }
}

extension Child: Equatable {
    nonisolated static func == (lhs: Child, rhs: Child) -> Bool {
        lhs.markup() == rhs.markup()
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

extension Child {
    func configuredAsCardItem() -> Self {
        switch wrapped {
        case let text as any TextProvider & HTML where text.fontStyle == .body || text.fontStyle == .lead:
            var item = Child(text)
            item.attributes.append(classes: "card-text")
            return item
        case is any TextProvider:
            var item = Child(wrapped)
            item.attributes.append(classes: "card-title")
            return item
        case is any LinkProvider:
            var item = Child(wrapped)
            item.attributes.append(classes: "card-link")
            return item
        case is any ImageElement:
            var item = Child(wrapped)
            item.attributes.append(classes: "card-img")
            return item
        default:
            return self
        }
    }
}

extension Child {
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

extension DropdownElement {
    func configuredAsDropdownItem() -> DropdownItem {
        DropdownItem(self)
    }
}

struct DropdownItem: HTML {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    var content: any DropdownElement
    
    init(_ content: any DropdownElement) {
        self.content = content
    }
    
    func markup() -> Markup {
        if let link = content as? LinkProvider {
            let content = content
                .class("dropdown-item")
                .class(publishingContext.currentRenderingPath == link.url ? "active" : nil)
                .aria(.current, publishingContext.currentRenderingPath == link.url ? "page" : nil)
                
            return Markup("<li>\(content.markup().string)</li>")
        } else if let text = content as? any TextProvider {
            let content = content.class("dropdown-header")
            return Markup("<li>\(content.markup().string)</li>")
        } else {
            return content.markup()
        }
    }
}

private extension DropdownElement {
    func `class`(_ classes: String?...) -> Self {
        var copy = self
        copy.attributes.append(classes: classes.compactMap(\.self))
        return copy
    }
    
    func aria(_ key: AriaType, _ value: String?) -> Self {
        guard let value else { return self }
        var copy = self
        copy.attributes.append(aria: .init(name: key.rawValue, value: value))
        return copy
    }
}
