//
// ForegroundModifiedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that applies foreground styling to HTML content.
struct ForegroundModifiedHTML<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    var body: some HTML { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The HTML content to be styled.
    var content: Content

    /// The foreground style to apply to the content.
    var style: ForegroundStyleType

    /// Creates a foreground-modified HTML element.
    /// - Parameters:
    ///   - content: The HTML content to apply foreground styling to.
    ///   - style: The type of foreground style to apply.
    init(_ content: Content, style: ForegroundStyleType) {
        self.content = content
        self.style = style
    }

    func markup() -> Markup {
        switch style {
        case .none:
            content
                .markup()
        case .gradient(let gradient) where content is any TextProvider:
            content
                .style(gradient.styles)
                .markup()
        case .gradient(let gradient):
            Section(content.class("color-inherit"))
                .style(gradient.styles)
                .markup()
        case .string(let string) where content is any TextProvider:
            content
                .style(.color, string)
                .markup()
        case .string(let string):
            Section(content.class("color-inherit"))
                .style(.color, string)
                .markup()
        case .color(let color) where content is any TextProvider:
            content
                .style(.color, color.description)
                .markup()
        case .color(let color):
            Section(content.class("color-inherit"))
                .style(.color, color.description)
                .markup()
        case .style(let foregroundStyle):
            content
                .class(foregroundStyle.rawValue)
                .markup()
        }
    }
}

extension ForegroundModifiedHTML: TextProvider where Content: TextProvider {
    var fontStyle: FontStyle {
        get { content.fontStyle }
        set { content.fontStyle = newValue }
    }
}
