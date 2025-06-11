//
// Children.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct Children: HTML, RandomAccessCollection {
    var body: Never { fatalError() }

    var attributes = CoreAttributes()

    nonisolated var elements = [Child]()

    // MARK: - RandomAccessCollection Requirements

    typealias Element = Child
    typealias Index = Array<Child>.Index

    nonisolated var startIndex: Index { elements.startIndex }
    nonisolated var endIndex: Index { elements.endIndex }

    nonisolated subscript(position: Index) -> Element {
        var child = elements[position]
        child.attributes.merge(attributes)
        return child
    }

    nonisolated func index(after i: Index) -> Index {
        elements.index(after: i)
    }

    nonisolated func index(before i: Index) -> Index {
        elements.index(before: i)
    }

    nonisolated func index(_ i: Index, offsetBy distance: Int) -> Index {
        elements.index(i, offsetBy: distance)
    }

    nonisolated func distance(from start: Index, to end: Index) -> Int {
        elements.distance(from: start, to: end)
    }

    // MARK: - Initializers

    init(_ children: [Child] = []) {
        self.elements = children
    }

    init(_ child: Child) {
        self.elements = [child]
    }

    init(_ child: Children) {
        self = child
    }

    init(_ content: any HTML) {
        self.elements = flattenedChildren(of: content)
    }

    init(_ content: any NavigationElement) {
        self.elements = flattenedChildren(of: content)
    }

    init(_ content: any AccordionElement) {
        if let variad = content as? any PackProvider {
            self.elements = variad.children.elements
        } else if let content = content as? any HTML {
            self.elements = [Child(content)]
        }
    }
    
    init(_ content: any DropdownElement) {
        if let variad = content as? any PackProvider {
            self.elements = variad.children.elements
        } else if let content = content as? any HTML {
            self.elements = [Child(content)]
        }
    }

    init(_ content: any ButtonElement) {
        if let variad = content as? any PackProvider {
            self.elements = variad.children.elements
        } else if let content = content as? any HTML {
            self.elements = [Child(content)]
        }
    }

    init(_ content: any TableRowElement) {
        if let variad = content as? any PackProvider {
            self.elements = variad.children.elements
        } else if let content = content as? any HTML {
            self.elements = [Child(content)]
        }
    }

    init(_ content: any SlideElement) {
        if let variad = content as? any PackProvider {
            self.elements = variad.children.elements
        } else if let content = content as? any HTML {
            self.elements = [Child(content)]
        }
    }

    // MARK: - HTML Requirements

    func markup() -> Markup {
        elements.map { $0.attributes(attributes).markup() }.joined()
    }

    // MARK: - Private Helpers

    private func flattenedChildren<T>(of html: T) -> [Child] {
        var result: [Child] = []
        collectFlattenedChildren(html, into: &result)
        return result
    }

    private func collectFlattenedChildren<T>(_ html: T, into result: inout [Child]) {
        // If this has children (PackProvider), recursively flatten them
        guard let packProvider = html as? PackProvider else {
            result.append(Child(html))
            return
        }

        for child in packProvider.children.elements.map(\.wrapped) {
            collectFlattenedChildren(child, into: &result)
        }
    }
}
