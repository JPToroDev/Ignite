//
// NavigationChildren.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct NavigationSubviewsCollection: HTML, RandomAccessCollection {
    var body: Never { fatalError() }

    var attributes = CoreAttributes()

    nonisolated var elements = [NavigationSubview]()

    init(_ child: any NavigationElement) {
        self.elements = flattenedChildren(of: child)
    }
    
    init() {
        self.elements = []
    }

    func markup() -> Markup {
        elements.map { $0.markup() }.joined()
    }

    // MARK: - RandomAccessCollection Requirements

    typealias Element = NavigationSubview
    typealias Index = Array<NavigationSubview>.Index

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

private extension NavigationSubviewsCollection {
    func flattenedChildren<T: NavigationElement>(of html: T) -> [NavigationSubview] {
        var result: [NavigationSubview] = []
        collectFlattenedChildren(html, into: &result)
        return result
    }

    func collectFlattenedChildren<T: NavigationElement>(_ html: T, into result: inout [NavigationSubview]) {
        guard let subviewsProvider = html as? NavigationSubviewsProvider else {
            result.append(NavigationSubview(html))
            return
        }

        for child in subviewsProvider.children.elements.map(\.content) {
            collectFlattenedChildren(child, into: &result)
        }
    }
}
