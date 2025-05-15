//
// ModifiedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct ModifiedHTML<Content: HTML>: HTML {
    /// The body of this HTML element, which is itself
    var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    let isPrimitive = true

    /// The underlying HTML content, unattributed.
    var content: Content

    init(_ content: Content) {
        var content = content
        // Make ModifiedHTML the single source of truth for attributes
        attributes.merge(content.attributes)
        content.attributes.clear()
        self.content = content
    }

    func markup() -> Markup {
        if content.isPrimitive {
            var content = content
            content.attributes.merge(attributes)
            return content.markup()
        } else if content.body.isPrimitive, content.body.markup().string.hasPrefix("<div") {
            // Unnecessarily adding an extra <div> can break positioning
            // contexts and advanced flex layouts.
            var content = content.body
            content.attributes.merge(attributes)
            return content.markup()
        } else {
            return Markup("<div\(attributes)>\(content.markupString())</div>")
        }
    }
}

extension ModifiedHTML: FormItem where Content: FormItem {}
