//
// FormSubviewsCollection.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct ControlGroupSubviewsCollection: ControlGroupElement, RandomAccessCollection {
    var body: Never { fatalError() }

    var attributes = CoreAttributes()

    nonisolated var elements = [ControlGroupSubview]()

    init() {}

    init(_ content: any ControlGroupElement) {
        self.elements = flattenedChildren(of: content)
    }

    func markup() -> Markup {
        elements.map { $0.attributes(attributes).markup() }.joined()
    }

    // MARK: - RandomAccessCollection Requirements

    typealias Element = ControlGroupSubview
    typealias Index = Array<ControlGroupSubview>.Index

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

private extension ControlGroupSubviewsCollection {
    func flattenedChildren<T: ControlGroupElement>(of html: T) -> [ControlGroupSubview] {
        var result: [ControlGroupSubview] = []
        collectFlattenedChildren(html, into: &result)
        return result
    }

    func collectFlattenedChildren<T: ControlGroupElement>(_ html: T, into result: inout [ControlGroupSubview]) {
        guard let subviewsProvider = html as? FormSubviewsProvider else {
            result.append(ControlGroupSubview(html))
            return
        }

        for child in subviewsProvider.children.elements.map(\.wrapped) {
            collectFlattenedChildren(child, into: &result)
        }
    }
}
