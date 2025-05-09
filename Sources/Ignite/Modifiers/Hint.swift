//
// Hint.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private func hintData(text: String) -> [Attribute] {
    [.init(name: "bs-toggle", value: "tooltip"),
     .init(name: "bs-title", value: text)]
}

private func hintData(html: String) -> [Attribute] {
    [.init(name: "bs-toggle", value: "tooltip"),
     .init(name: "bs-title", value: html),
     .init(name: "bs-html", value: "true")]
}

@MainActor private func hintData(markdown: String) -> [Attribute] {
    let site = PublishingContext.shared.site
    let config = site.syntaxHighlighterConfiguration
    var parser = MarkdownToHTML()

    parser.removeTitleFromBody = true
    parser.defaultHighlighter = config.defaultLanguage?.rawValue
    parser.highlightInlineCode = config.highlightInlineCode

    let components = parser.parse(markdown)
    let cleanedHTML = components.body.replacing(#/<\/?p>/#, with: "")
    return hintData(html: cleanedHTML)
}

@MainActor private func hintModifier(
    data: [Attribute],
    content: any HTML
) -> any HTML {
    data.reduce(content) { $0.data($1.name, $1.value!) }
}

@MainActor private func hintModifier(
    data: [Attribute],
    content: any InlineElement
) -> any InlineElement {
    data.reduce(content) { $0.data($1.name, $1.value!) }
}

public extension HTML {
    /// Creates a plain-text tooltip for this element.
    /// - Parameter text: The text to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(text: String) -> some HTML {
        AnyHTML(hintModifier(data: hintData(text: text), content: self))
    }

    /// Creates a HTML tooltip for this element.
    /// - Parameter html: The HTML to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(html: String) -> some HTML {
        AnyHTML(hintModifier(data: hintData(html: html), content: self))
    }

    /// Creates a Markdown tooltip for this element.
    /// - Parameter markdown: The Markdown text to parse.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(markdown: String) -> some HTML {
        AnyHTML(hintModifier(data: hintData(markdown: markdown), content: self))
    }
}

public extension InlineElement {
    /// Creates a plain-text tooltip for this element.
    /// - Parameter text: The text to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(text: String) -> some InlineElement {
        AnyInlineElement(hintModifier(data: hintData(text: text), content: self))
    }

    /// Creates a HTML tooltip for this element.
    /// - Parameter html: The HTML to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(html: String) -> some InlineElement {
        AnyInlineElement(hintModifier(data: hintData(html: html), content: self))
    }

    /// Creates a Markdown tooltip for this element.
    /// - Parameter markdown: The Markdown text to parse.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(markdown: String) -> some InlineElement {
        AnyInlineElement(hintModifier(data: hintData(markdown: markdown), content: self))
    }
}
