//
// Tag.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A struct able to become any HTML tag. Useful for when Ignite has not
/// implemented a specific tag you need.
public struct Tag<Content>: HTML {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The name of the tag to use.
    var name: String

    // The contents of this tag.
    var content: Content

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        "<\(name)\(attributes)>\(content)</\(name)>"
    }

    @discardableResult public func style(_ property: Property, _ value: String) -> some Stylable {
        AnyInlineElement("")
    }
}

extension Tag: Element, HeadElement where Content: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// Creates a new `Tag` instance from the name provided, along with a page
    /// element builder that returns an array of the content to place inside.
    /// - Parameters:
    ///   - name: The name of the HTML tag you want to create.
    ///   - content: The content to place inside the tag.
    public init(_ name: String, @HTMLBuilder content: @escaping () -> Content) {
        self.name = name
        self.content = content()
    }

    /// Creates a new `Tag` instance from the name provided, along with one
    /// page element to place inside.
    /// - Parameters:
    ///   - name: The name of the HTML tag you want to create.
    ///   - singleElement: The content to place inside the tag.
    public init(_ name: String, content singleElement: Content) {
        self.name = name
        self.content = singleElement
    }
}

public extension Tag where Content == EmptyHTML {
    /// Creates a new `Tag` instance from the name provided, with no content
    /// inside the tag.
    ///   - name: The name of the HTML tag you want to create.
    init(_ name: String) {
        self.name = name
        self.content = EmptyHTML()
    }
}
