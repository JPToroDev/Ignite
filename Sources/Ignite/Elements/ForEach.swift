//
// ForEach.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structure that creates HTML content by mapping over a sequence of data.
@MainActor
public struct ForEach<Data: Sequence, Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { fatalError() }
    
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The sequence of data to iterate over.
    private let data: Data

    /// The child elements contained within this HTML element.
    var children: Children

    /// Creates a new ForEach instance that generates HTML content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into HTML content.
    public init(
        _ data: Data,
        @HTMLBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        let items = data.map(content)
        self.children = Children(items.map { Child($0) })
    }

    /// Renders the ForEach content when this isn't part of a list.
    /// - Returns: The rendered HTML string.
    public func markup() -> Markup {
        children.map { $0.attributes(attributes).markup() }.joined()
    }
}

extension ForEach: ListElement where Content: ListElement {
    /// Renders the ForEach content when it's part of a `List` and
    /// its children aren't `ListItem`.
    /// - Returns: The rendered HTML string.
    func markupAsListItem() -> Markup {
        children.map { Markup("<li\(attributes)>\($0.markupString())</li>") }.joined()
    }
}

extension ForEach: VariadicElement {}
