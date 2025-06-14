//
// FontStyleModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private struct FontStyleModifier: HTMLModifier {
    var style: FontStyle
    func body(content: Content) -> some HTML {
        FontStyleModifiedHTML(content: content, style: style)
    }
}

public extension HTML {
    /// Adjusts the heading level of this text.
    /// - Parameter style: The new heading level.
    /// - Returns: A new `Text` instance with the updated font style.
    func font(_ style: Font.Style) -> some HTML {
        modifier(FontStyleModifier(style: style))
    }
}

struct FontStyleModifiedHTML: HTML {
    var body: Never { fatalError() }
    var attributes = CoreAttributes()
    var content: any HTML
    var style: Font.Style

    func markup() -> Markup {
        var content = content
        content.attributes.merge(attributes)
        if var provider = content as? any TextProvider & HTML {
            provider.fontStyle = style
            return provider.markup()
        } else {
            return content.class(style.sizeClass).markup()
        }
    }
}
