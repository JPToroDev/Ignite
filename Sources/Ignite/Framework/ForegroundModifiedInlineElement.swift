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

    func render() -> Markup {
        var content = content
        content.attributes.merge(attributes)

        return switch style {
        case .none:
            content
                .render()
        case .gradient(let gradient):
            content
                .style(gradient.styles)
                .render()
        case .string(let string):
            content
                .style(.color, string)
                .render()
        case .color(let color):
            content
                .style(.color, color.description)
                .render()
        case .style(let foregroundStyle):
            content
                .class(foregroundStyle.rawValue)
                .render()
        }
    }
}
