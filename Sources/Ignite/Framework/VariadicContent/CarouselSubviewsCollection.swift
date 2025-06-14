//
// CarouselSubviewsCollection.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct CarouselSubviewsCollection: CarouselElement, RandomAccessCollection {
    var body: Never { fatalError() }

    var attributes = CoreAttributes()

    nonisolated var elements = [CarouselSubview]()

    init(_ subviews: [CarouselSubview] = []) {
        self.elements = subviews
    }

    init(_ content: any CarouselElement) {
        self.elements = flattenedChildren(of: content)
    }

    func markup() -> Markup {
        elements.map { $0.attributes(attributes).markup() }.joined()
    }

    // MARK: - RandomAccessCollection Requirements

    typealias Element = CarouselSubview
    typealias Index = Array<CarouselSubview>.Index

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

private extension CarouselSubviewsCollection {
    func flattenedChildren<T: CarouselElement>(of html: T) -> [CarouselSubview] {
        var result: [CarouselSubview] = []
        collectFlattenedChildren(html, into: &result)
        return result
    }

    func collectFlattenedChildren<T: CarouselElement>(_ html: T, into result: inout [CarouselSubview]) {
        guard let subviewsProvider = html as? CarouselSubviewsProvider else {
            result.append(CarouselSubview(html))
            return
        }

        for child in subviewsProvider.children.elements.map(\.wrapped) {
            collectFlattenedChildren(child, into: &result)
        }
    }
}
