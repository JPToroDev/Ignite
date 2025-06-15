//
// Children.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct SubviewsCollection: HTML, RandomAccessCollection {
    var body: Never { fatalError() }

    var attributes = CoreAttributes()

    nonisolated var elements = [Subview]()

    init(_ children: [Subview] = []) {
        self.elements = children
    }

    init(_ children: [any HTML] = []) {
        self.elements = children.map(Subview.init)
    }

    init(_ content: any HTML) {
        self.elements = flattenedChildren(of: content)
    }

    func render() -> Markup {
        elements.map { $0.attributes(attributes).render() }.joined()
    }

    // MARK: - RandomAccessCollection Requirements

    typealias Element = Subview
    typealias Index = Array<Subview>.Index

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

private extension SubviewsCollection {
    func flattenedChildren<T: HTML>(of html: T) -> [Subview] {
        var result: [Subview] = []
        collectFlattenedChildren(html, into: &result)
        return result
    }

    func collectFlattenedChildren<T: HTML>(_ html: T, into result: inout [Subview]) {
        guard let subviewsProvider = html as? any SubviewsProvider else {
            result.append(Subview(html))
            return
        }

        for child in subviewsProvider.subviews.elements.map(\.wrapped) {
            collectFlattenedChildren(child, into: &result)
        }
    }
}
