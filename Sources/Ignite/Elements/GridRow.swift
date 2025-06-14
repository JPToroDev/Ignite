//
// GridRow.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
protocol GridItemProvider {
    func gridItems() -> [GridItem]
}

public struct GridRow<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    private var content: Content

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }

    init(_ content: Content) {
        self.content = content
    }

    public func markup() -> Markup {
        content.attributes(attributes).markup()
    }
}

extension GridRow: GridItemProvider {
    func gridItems() -> [GridItem] {
        content.subviews().map { GridItem($0) }
    }
}
