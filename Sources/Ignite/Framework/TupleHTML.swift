//
// TupleHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public struct TupleHTML<T>: HTML {

    public var attributes = CoreAttributes()

    public var isPrimitive = true

    var content: T

    public var body: some HTML { self }

    public init(_ content: T) {
        self.content = content
    }

    private var items: [any BodyElement] {
        // Use Mirror to inspect and iterate through tuple elements
        let mirror = Mirror(reflecting: content)
        return mirror.children.compactMap { child in
            guard let element = child.value as? any HTML else { return nil }
            return element
        }
    }

    var children: [any BodyElement] {
        items.map { $0.attributes(attributes) }
    }

    public func markup() -> Markup {
        children.map { $0.markup() }.joined()
    }
}

extension TupleHTML: HTMLCollection {}

@MainActor
protocol HTMLCollection {
    var children: [any BodyElement] { get }
}
