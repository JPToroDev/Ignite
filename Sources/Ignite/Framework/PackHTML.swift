//
// PackHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import SwiftUI

@MainActor
struct PackHTML<each Content> {

    var attributes = CoreAttributes()

    var content: (repeat each Content)

    init(_ content: repeat each Content) {
        self.content = (repeat each content)
    }
}

extension PackHTML: HTML, PackProvider, MarkupElement, Sendable where repeat each Content: HTML {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    var children: Children {
        var children = Children()
        for element in repeat each content {
            // Using the attributes() modifier will change the type to ModifiedHTML,
            // so to keep the type info, we'll modify the attributes directly
            var child = Child(element)
            child.attributes.merge(attributes)
            children.elements.append(child)
        }
        return children
    }

    func markup() -> Markup {
        children.map { $0.markup() }.joined()
    }
}

extension PackHTML: NavigationElement where repeat each Content: NavigationElement {}

extension PackHTML: AccordionElement where repeat each Content: AccordionElement {}

extension PackHTML: ButtonElement where repeat each Content: ButtonElement {}

extension PackHTML: TableRowElement where repeat each Content: TableRowElement {}

extension PackHTML: SlideElement where repeat each Content: SlideElement {}

extension PackHTML: @MainActor DropdownElement where repeat each Content: DropdownElement {
    func markup() -> Markup {
        var markup = Markup()
        for element in repeat each content {
            markup += element.configuredAsDropdownItem().markup()
        }
        return markup
    }
}

@MainActor
protocol PackProvider {
    var children: Children { get }
}
