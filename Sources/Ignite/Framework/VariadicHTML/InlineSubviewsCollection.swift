//
// InlineSubviewsCollection.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct InlineSubviewsCollection: InlineElement, RandomAccessCollection {
    var body: Never { fatalError() }

    var attributes = CoreAttributes()

    nonisolated var elements = [InlineSubview]()

    init() {}

    init(_ content: any InlineElement) {
        self.elements = flattenedChildren(of: content)
    }

    func markup() -> Markup {
        elements.map { $0.attributes(attributes).markup() }.joined()
    }

    // MARK: - RandomAccessCollection Requirements

    typealias Element = InlineSubview
    typealias Index = Array<InlineSubview>.Index

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

private extension InlineSubviewsCollection {
    func flattenedChildren<T: InlineElement>(of html: T) -> [InlineSubview] {
        var result: [InlineSubview] = []
        collectFlattenedChildren(html, into: &result)
        return result
    }

    func collectFlattenedChildren<T: InlineElement>(_ html: T, into result: inout [InlineSubview]) {
        guard let subviewsProvider = html as? InlineSubviewsProvider else {
            result.append(InlineSubview(html))
            return
        }

        for child in subviewsProvider.children.elements.map(\.wrapped) {
            collectFlattenedChildren(child, into: &result)
        }
    }
}
