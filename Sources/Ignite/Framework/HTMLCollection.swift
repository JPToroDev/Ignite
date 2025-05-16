//
// HTMLSequence.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that flattens and makes HTML content iterable.
///
/// `HTMLCollection` is used internally to handle opaque HTML content returned from result builders,
/// particularly in loops and other control flow situations. It converts potentially nested
/// structures into a flat, iterable collections of `HTML` elements.
struct VariadicHTML: HTML, @preconcurrency Sequence {
    /// The content and behavior of this HTML sequence
    var body: some HTML { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The array of HTML elements contained in this sequence
    private var items: [any HTML] = []

    /// The array of HTML elements with the container's attributes applied.
    var children: [any HTML] {
        items.map { $0.attributes(attributes) }
    }

    /// Creates a new HTML sequence using a result builder
    /// - Parameter content: A closure that returns HTML content
    init(@HTMLBuilder _ content: () -> some HTML) {
        let content = content()
        self.items = flatten(content)
    }

    /// Creates a new HTML sequence from an array of elements
    /// - Parameter elements: The array of HTML elements to include
    init(_ elements: [any HTML]) {
        self.items = elements.flatMap { flatten($0) }
    }

    /// Creates an iterator over the sequence's elements
    /// - Returns: An iterator that provides access to each HTML element
    func makeIterator() -> IndexingIterator<[any HTML]> {
        children.makeIterator()
    }

    /// Renders all elements in the sequence into HTML
    /// - Returns: The combined HTML string of all elements
    func markup() -> Markup {
        children.map { $0.markup() }.joined()
    }

    /// Recursively flattens nested HTML content into a single array, deconstructing wrapper types.
    /// - Parameter content: The content to flatten
    /// - Returns: An array of unwrapped HTML elements
    private func flatten(_ content: any HTML) -> [any HTML] {
        if let collection = content as? any HTMLCollection {
            collection.children.flatMap { flatten($0) }
        } else if content is EmptyHTML {
            []
        } else {
            [content]
        }
    }
}

extension VariadicHTML: HTMLCollection {}
