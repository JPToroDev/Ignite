//
// InlineForEach.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structure that creates inline content by mapping over a sequence of data.
@MainActor
public struct InlineForEach<Data: Sequence>: InlineElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The sequence of data to iterate over.
    private let data: Data

    /// The child elements contained within this HTML element.
    var items: SubviewsCollection

    /// Creates a new InlineForEach instance that generates inline content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into inline content.
    public init(_ data: Data, @InlineElementBuilder content: @escaping (Data.Element) -> some InlineElement) {
        self.data = data
        var collection = SubviewsCollection()
        data.map(content).forEach { collection.elements.append(Subview(InlineHTML(AnyInlineElement($0)))) }
        self.items = collection
    }

    /// Renders the ForEach content.
    /// - Returns: The rendered HTML string.
    public func markup() -> Markup {
        items.map {
            var item: any HTML = $0
            item.attributes.merge(attributes)
            return item.markup()
        }.joined()
    }
}
