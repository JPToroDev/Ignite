//
// ForEach.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structure that creates HTML content by mapping over a sequence of data.
@MainActor
public struct ForEach<Data: Sequence>: HTML, ListableElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { fatalError() }
    
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The sequence of data to iterate over.
    private let data: Data

    /// The child elements contained within this HTML element.
    var items: [any BodyElement]

    /// Creates a new ForEach instance that generates HTML content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into HTML content.
    public init(
        _ data: Data,
        @HTMLBuilder content: @escaping (Data.Element) -> some BodyElement
    ) {
        self.data = data
        self.items = data.map(content)
    }

    /// Renders the ForEach content when this isn't part of a list.
    /// - Returns: The rendered HTML string.
    public func markup() -> Markup {
        items.map {
            var item: any BodyElement = $0
            item.attributes.merge(attributes)
            return item.markup()
        }.joined()
    }

    /// Renders the ForEach content when this isn't part of a list.
    /// - Returns: The rendered HTML string.
    func listMarkup() -> Markup {
        // ListableElement conformance ensures other views never wrap ForEach in <li> tags.
        markup()
    }
}
