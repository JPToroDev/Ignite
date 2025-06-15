//
// ModifiedInlineElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
struct ModifiedInlineElement<Content, Modifier>: Sendable {
    /// The body of this HTML element, which is itself
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    private var content: Content

    var modifier: Modifier

    init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }
}

extension ModifiedInlineElement: InlineElement, CustomStringConvertible
where Content: InlineElement, Modifier: InlineElementModifier {
    func render() -> Markup {
        let proxy = InlineModifiedContentProxy(content: content, modifier: modifier)
        var modified = modifier.body(content: proxy)
        modified.attributes.merge(attributes)
        return modified.render()
    }
}

extension ModifiedInlineElement: LinkProvider where Content: LinkProvider {
    var url: String {
        content.url
    }
}

extension ModifiedInlineElement: ImageProvider where Content: ImageProvider {}

extension ModifiedInlineElement: ColumnProvider where Content: ColumnProvider {}
