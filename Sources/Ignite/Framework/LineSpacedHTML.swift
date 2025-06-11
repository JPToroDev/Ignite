//
// LineSpacedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct LineSpacedHTML<Content: HTML>: HTML {
    var attributes = CoreAttributes()

    var body: Never { fatalError() }

    var content: Content
    var spacing: Amount<Double, LineSpacing>

    init(_ content: Content, spacing: Amount<Double, LineSpacing>) {
        self.content = content
        self.spacing = spacing
    }

    func markup() -> Markup {
        if content is any TextProvider {
            switch spacing {
            case .exact(let spacing):
                content.style(.init(.lineHeight, value: spacing.formatted(.nonLocalizedDecimal)))
                    .markup()
            case .semantic(let spacing):
                content.class("lh-\(spacing.rawValue)")
                    .markup()
            default: content.markup()
            }
        } else {
            switch spacing {
            case .exact(let spacing):
                Section(content.class("line-height-inherit"))
                    .style(.lineHeight, spacing.formatted(.nonLocalizedDecimal))
                    .markup()
            case .semantic(let spacing):
                Section(content.class("line-height-inherit"))
                    .class("lh-\(spacing.rawValue)")
                    .markup()
            default: content.markup()
            }
        }
    }
}
