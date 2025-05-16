//
// TupleHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public struct TupleHTML<T>: HTML {

    public var body: some HTML { fatalError() }

    public var attributes = CoreAttributes()

    var content: T

    public init(_ content: T) {
        self.content = content
    }

    private var items: [any HTML] {
        // Use Mirror to inspect and iterate through tuple elements
        let mirror = Mirror(reflecting: content)
        return mirror.children.compactMap { child in
            guard let element = child.value as? any HTML else { return nil }
            return element
        }
    }

    var children: [any HTML] {
        items.map { $0.attributes(attributes) }
    }

    public func markup() -> Markup {
        children.map { $0.markup() }.joined()
    }
}

extension TupleHTML: HTMLCollection {}

@MainActor
protocol HTMLCollection {
    associatedtype Content: Sequence where Content.Element == any HTML
    var children: Content { get }
}
