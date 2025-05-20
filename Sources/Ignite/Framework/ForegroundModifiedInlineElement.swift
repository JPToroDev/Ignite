//
// ForegroundModifiedInlineElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct ForegroundModifiedInlineElement<Content: InlineElement>: InlineElement {
    var attributes = CoreAttributes()

    var body: some InlineElement { fatalError() }

    var content: Content
    var style: ForegroundStyleType

    init(_ content: Content, style: ForegroundStyleType) {
        self.content = content
        self.style = style
    }

    func markup() -> Markup {
        switch style {
        case .none:
            content
                .markup()
        case .gradient(let gradient):
            content
                .style(gradient.styles)
                .markup()
        case .string(let string):
            content
                .style(.color, string)
                .markup()
        case .color(let color):
            content
                .style(.color, color.description)
                .markup()
        case .style(let foregroundStyle):
            content
                .class(foregroundStyle.rawValue)
                .markup()
        }
    }
}
