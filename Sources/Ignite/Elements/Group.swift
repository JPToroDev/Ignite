//
// Group.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public struct Group: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    var items: [any HTML] = []

    public init(@HTMLBuilder _ content: () -> some HTML) {
        self.items = flatUnwrap(content())
    }

    public init(_ items: any HTML) {
        self.items = flatUnwrap(items)
    }

    init(context: PublishingContext, items: [any HTML]) {
        self.items = flatUnwrap(items)
    }

    public func render(context: PublishingContext) -> String {
        return items.map {
            let item: any HTML = $0
            AttributeStore.default.merge(attributes, intoHTML: item.id)
            return item.render(context: context)
        }.joined()
    }
}
