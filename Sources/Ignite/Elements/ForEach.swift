//
// ForEach.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structure that creates HTML content by mapping over a sequence of data.
@MainActor
public struct ForEach<Data: Sequence, Content>: Sendable {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The sequence of data to iterate over.
    private let data: Data

    /// The child elements contained within this HTML element.
    var subviews: SubviewsCollection
}

extension ForEach: HTML, VariadicHTML where Content: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// Creates a new ForEach instance that generates HTML content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into HTML content.
    public init(
        _ data: Data,
        @HTMLBuilder content: (Data.Element) -> Content
    ) {
        self.data = data
        let items = data.map(content)
        self.subviews = SubviewsCollection(items.map(Subview.init))
    }

    /// Renders the ForEach content when this isn't part of a list.
    /// - Returns: The rendered HTML string.
    public func markup() -> Markup {
        subviews.map { $0.attributes(attributes).markup() }.joined()
    }
}

extension ForEach: ListItemProvider where Content: ListItemProvider {}
extension ForEach: ColumnProvider where Content: ColumnProvider {}

extension ForEach: AccordionElement where Content: AccordionElement {
    /// Creates a new ForEach instance that generates HTML content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into HTML content.
    init(
        _ data: Data,
        @AccordionElementBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        let items = data.map(content).compactMap { $0 as? any HTML }
        self.subviews = SubviewsCollection(items.map { Subview($0) })
    }

    /// Renders the ForEach content when this isn't part of a list.
    /// - Returns: The rendered HTML string.
    public func markup() -> Markup {
        subviews.map { $0.attributes(attributes).markup() }.joined()
    }
}

extension ForEach: TableRowElement where Content: TableRowElement {
    /// Creates a new ForEach instance that generates HTML content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into HTML content.
    init(
        _ data: Data,
        @TableRowElementBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        let items = data.map(content).compactMap { $0 as? any HTML }
        self.subviews = SubviewsCollection(items.map { Subview($0) })
    }

    public func markup() -> Markup {
        subviews.map { $0.markup() }.joined()
    }
}

extension ForEach: DropdownElement where Content: DropdownElement {
    /// Creates a new ForEach instance that generates HTML content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into HTML content.
    init(
        _ data: Data,
        @DropdownElementBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        let items = data.map(content).compactMap { $0 as? any HTML }
        self.subviews = SubviewsCollection(items.map { Subview($0) })
    }
    
    public func markup() -> Markup {
        subviews.map { $0.markup() }.joined()
    }
}

extension ForEach: NavigationElement where Content: NavigationElement {
    /// Creates a new ForEach instance that generates HTML content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into HTML content.
    init(
        _ data: Data,
        @NavigationElementBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        let items = data.map(content).compactMap { $0 as? any HTML }
        self.subviews = SubviewsCollection(items.map { Subview($0) })
    }
    
    public func markup() -> Markup {
        subviews.map { $0.markup() }.joined()
    }
}

extension ForEach: CarouselElement where Content: CarouselElement {
    /// Creates a new ForEach instance that generates HTML content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into HTML content.
    init(
        _ data: Data,
        @TableRowElementBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        let items = data.map(content).compactMap { $0 as? any HTML }
        self.subviews = SubviewsCollection(items.map { Subview($0) })
    }
    
    public func markup() -> Markup {
        subviews.map { $0.markup() }.joined()
    }
}
