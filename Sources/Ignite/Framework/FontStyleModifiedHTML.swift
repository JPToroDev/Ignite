//
// FontStyleModifiedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// HTML content with modified font styling.
struct FontStyleModifiedHTML: HTML {
    var body: Never { fatalError() }
    var attributes = CoreAttributes()
    /// The HTML content to modify.
    var content: any HTML
    /// The font style to apply.
    var style: Font.Style

    /// Renders the content with the applied font style.
    func render() -> Markup {
        var content = content
        content.attributes.merge(attributes)
        if var provider = content as? any TextProvider & HTML {
            provider.fontStyle = style
            return provider.render()
        } else {
            return content.class(style.sizeClass).render()
        }
    }
}
