//
// Children.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct Children: HTML, Sequence {
    var body: Never { fatalError() }

    var attributes = CoreAttributes()

    var elements = [Child]()

    init(_ children: [Child] = []) {
        self.elements = children
    }

    init(_ child: Child) {
        self.elements = [child]
    }

    init(_ content: any HTML) {
        if let variad = content as? any VariadicElement {
            self.elements = variad.children.elements
        } else {
            self.elements = [Child(content)]
        }
    }

    init(_ content: any NavigationElement) {
        if let variad = content as? any VariadicElement {
            self.elements = variad.children.elements
        } else if let content = content as? any HTML {
            self.elements = [Child(content)]
        }
    }

    init(_ content: any AccordionElement) {
        if let variad = content as? any VariadicElement {
            self.elements = variad.children.elements
        } else if let content = content as? any HTML {
            self.elements = [Child(content)]
        }
    }

    init(_ content: any ButtonElement) {
        if let variad = content as? any VariadicElement {
            self.elements = variad.children.elements
        } else if let content = content as? any HTML {
            self.elements = [Child(content)]
        }
    }

    init(_ content: any TableRowElement) {
        if let variad = content as? any VariadicElement {
            self.elements = variad.children.elements
        } else if let content = content as? any HTML {
            self.elements = [Child(content)]
        }
    }

    init(_ content: any SlideElement) {
        if let variad = content as? any VariadicElement {
            self.elements = variad.children.elements
        } else if let content = content as? any HTML {
            self.elements = [Child(content)]
        }
    }

    /// Creates an iterator over the sequence's elements
    /// - Returns: An iterator that provides access to each HTML element
    nonisolated func makeIterator() -> IndexingIterator<[Child]> {
        elements.map {
            var child = $0
            child.attributes.merge(attributes)
            return child
        }.makeIterator()
    }

    func markup() -> Markup {
        elements.map { $0.attributes(attributes).markup() }.joined()
    }
}
