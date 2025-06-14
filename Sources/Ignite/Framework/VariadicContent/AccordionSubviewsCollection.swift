//
// AccordionSubviewsCollection.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct AccordionSubviewsCollection: AccordionElement, RandomAccessCollection {
    var body: Never { fatalError() }

    var attributes = CoreAttributes()

    nonisolated var elements = [AccordionSubview]()

    init(_ subviews: [AccordionSubview] = []) {
        self.elements = subviews
    }

    init(_ content: any AccordionElement) {
        self.elements = flattenedChildren(of: content)
    }

    func markup() -> Markup {
        elements.map { $0.attributes(attributes).markup() }.joined()
    }

    // MARK: - RandomAccessCollection Requirements

    typealias Element = AccordionSubview
    typealias Index = Array<AccordionSubview>.Index

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
}

private extension AccordionSubviewsCollection {
    func flattenedChildren<T: AccordionElement>(of html: T) -> [AccordionSubview] {
        var result: [AccordionSubview] = []
        collectFlattenedChildren(html, into: &result)
        return result
    }

    func collectFlattenedChildren<T: AccordionElement>(_ html: T, into result: inout [AccordionSubview]) {
        guard let subviewsProvider = html as? AccordionSubviewsProvider else {
            result.append(AccordionSubview(html))
            return
        }

        for child in subviewsProvider.children.elements.map(\.wrapped) {
            collectFlattenedChildren(child, into: &result)
        }
    }
}
