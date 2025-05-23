//
// Code.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An inline snippet of programming code, embedded inside a larger part
/// of your page. For dedicated code blocks that sit on their own line, use
/// `CodeBlock` instead.
///
/// - Important: If your code contains angle brackets (`<`...`>`), such as Swift generics,
/// the prettifier will interpret these as HTML tags and break the code's formatting.
/// To avoid this issue, either set your site's `shouldPrettify` property to `false`,
/// or replace `<` and `>` with their character entity references, `&lt;` and `&gt;` respectively.
public struct Code: InlineElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The code to display.
    private var content: String

    /// The language used by the syntax highlighter.
    private var language: HighlighterLanguage?

    /// Creates a new `Code` instance from the given content.
    /// - Parameters
    ///   - content: The code you want to render.
    ///   - language: The programming language for the code.
    public init(_ content: String, language: HighlighterLanguage? = .automatic) {
        self.content = content
        self.language = language
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        let config = publishingContext.site.syntaxHighlighterConfiguration
        let resolvedLanguage = language == .automatic && config.highlightInlineCode ?
            config.defaultLanguage : language

        if let resolvedLanguage, resolvedLanguage != .automatic {
            publishingContext.environment.syntaxHighlighters.insert(resolvedLanguage)
            var attributes = attributes
            attributes.append(classes: "language-\(resolvedLanguage)")
            return Markup("<code\(attributes)>\(content)</code>")
        }

        return Markup("<code\(attributes)>\(content)</code>")
    }
}
