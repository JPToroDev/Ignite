//
// FullHeightDocument.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An document whose `<body>` uses flex layout and has a height that matches the viewport.
/// This document type can be useful when designing complex flexbox and grid layouts.
public struct FlexDocument: Document {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    private var language: Language
    public var head: Head
    public var body: Body

    public init(@DocumentElementBuilder content: () -> (head: Head, body: Body)) {
        self.language = PublishingContext.shared.environment.language
        self.body = content().body
        self.head = content().head
    }

    public func render() -> Markup {
        var attributes = attributes
        attributes.append(customAttributes: .init(name: "lang", value: language.rawValue))
        if let themeAttribute {
            attributes.append(dataAttributes: themeAttribute)
        }

        var body = body
        body.attributes.append(classes: "d-flex", "flex-column", "min-vh-100")
        let bodyMarkup = body.markup()

        // Deferred head rendering to accommodate for context updates during body rendering
        let headMarkup = head.markup()

        var output = "<!doctype html>"
        output += "<html\(attributes)>"
        output += headMarkup.string
        output += bodyMarkup.string
        output += "</html>"
        return Markup(output)
    }
}
