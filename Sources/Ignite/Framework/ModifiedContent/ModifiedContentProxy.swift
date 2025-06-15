//
// ModifiedContentProxy.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public struct ModifiedContentProxy<Modifier: HTMLModifier>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    public var attributes = CoreAttributes()

    private var modifier: Modifier

    private var content: any HTML

    init<T: HTML>(content: T, modifier: Modifier) {
        self.modifier = modifier
        self.content = content
    }

    public func render() -> Markup {
        if content.isPrimitive {
            var content = content
            content.attributes.merge(attributes)
            return content.render()
        } else if content.body.isPrimitive, content.render().string.hasPrefix("<div") {
            // Unnecessarily adding an extra <div> can break positioning
            // contexts and advanced flex layouts.
            var content = content.body
            content.attributes.merge(attributes)
            return content.render()
        } else {
            return Markup("<div\(attributes)>\(content.markupString())</div>")
        }
    }
}
