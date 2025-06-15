//
// ControlGroupItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct ControlGroupItem: HTML {
    var body: Never { fatalError() }
    var attributes = CoreAttributes()
    var content: any HTML
    init(_ content: any HTML) {
        self.content = content
    }
    init<T: InlineElement>(_ content: T) {
        self.content = InlineHTML(content)
    }
    func render() -> Markup {
        var content = content
        content.attributes.merge(attributes)
        return content.render()
    }
}
