//
// GridItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct GridItem: HTML {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    private var content: any HTML

    var isFullWidth = false

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    init(_ content: any HTML) {
        self.content = content
    }

    func render() -> Markup {
        content.attributes(attributes).render()
    }

    static var emptyCell: Self {
        GridItem(Section().class("ig-grid-spacer"))
    }
}
