//
// InlineModifiedContentProxy.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public struct InlineModifiedContentProxy<Modifier: InlineElementModifier>: InlineElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    public var attributes = CoreAttributes()

    private var modifier: Modifier

    private var content: any InlineElement

    init<T: InlineElement>(content: T, modifier: Modifier) {
        self.modifier = modifier
        self.content = content
    }

    public func markup() -> Markup {
        if content.isPrimitive {
            var content = content
            content.attributes.merge(attributes)
            return content.markup()
        } else {
            return Markup("<span\(attributes)>\(content.markupString())</span>")
        }
    }
}
