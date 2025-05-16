//
// ForEach.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structure that creates HTML content by mapping over a sequence of data.
@MainActor
public struct ForEach<Content: HTML, Data: Sequence>: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { fatalError() }
    
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The sequence of data to iterate over.
    private let data: Data

    /// The child elements contained within this HTML element.
    var items: [any HTML]

    /// Creates a new ForEach instance that generates HTML content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into HTML content.
    public init(
        _ data: Data,
        @HTMLBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.items = data.map(content)
    }

    /// Renders the ForEach content when this isn't part of a list.
    /// - Returns: The rendered HTML string.
    public func markup() -> Markup {
        items.map { $0.attributes(attributes).markup() }.joined()
    }
}

extension ForEach: HTMLCollection {
    var children: VariadicHTML {
        VariadicHTML(items)
    }
}

extension ForEach: ListElement where Content: ListElement {
    /// Renders the ForEach content when it's part of a `List` and
    /// its children aren't `ListItem`.
    /// - Returns: The rendered HTML string.
    func markupAsListItem() -> Markup {
        items.map { Markup("<li\(attributes)>\($0.markupString())</li>") }.joined()
    }
}
