//
// ModifiedInlineElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct ModifiedInlineElement<Content: InlineElement>: InlineElement {
    /// The body of this HTML element, which is itself
    var body: some InlineElement { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    var content: Content

    init(_ content: Content) {
        var content = content
        // Make ModifiedInlineElement the single source of truth for attributes
        attributes.merge(content.attributes)
        content.attributes.clear()
        self.content = content
    }

    func markup() -> Markup {
        if content.isPrimitive {
            var content = content
            content.attributes.merge(attributes)
            return content.markup()
        } else {
            return Markup("<span\(attributes)>\(content.markupString())</span>")
        }
    }
}

extension ModifiedInlineElement: FormItem where Content: FormItem {}

extension ModifiedInlineElement: ListElement where Content: ListElement {}
