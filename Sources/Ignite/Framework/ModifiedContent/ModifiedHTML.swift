//
// ModifiedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
struct ModifiedHTML<Content, Modifier>: Sendable {
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

extension ModifiedHTML: HTML, VariadicHTML where Content: HTML, Modifier: HTMLModifier {
    private func modify(children: SubviewsCollection) -> SubviewsCollection {
        var collection = SubviewsCollection()
        for child in children {
            let proxy = ModifiedContentProxy(content: child, modifier: modifier)
            var modified = modifier.body(content: proxy)
            modified.attributes.merge(attributes)
            collection.elements.append(.init(modified))
        }
        return collection
    }

    func markup() -> Markup {
        if let content = content as? any VariadicHTML {
            return modify(children: content.children).markup()
        } else {
            let proxy = ModifiedContentProxy(content: content, modifier: modifier)
            var modified = modifier.body(content: proxy)
            modified.attributes.merge(attributes)
            return modified.markup()
        }
    }

    var children: SubviewsCollection {
        var children = (content as? any VariadicHTML)?.children ?? SubviewsCollection(Subview(content))
        return modify(children: children)
    }
}

extension ModifiedHTML: ListElement where Content: ListElement {
    func markupAsListItem() -> Markup {
        content.markupAsListItem()
    }
}

extension ModifiedHTML: SpacerProvider where Content: SpacerProvider {
    var spacer: Spacer { content.spacer }
}

extension ModifiedHTML: TextProvider where Content: TextProvider {
    var fontStyle: FontStyle {
        get { content.fontStyle }
        set { content.fontStyle = newValue }
    }
}

extension ModifiedHTML: LinkProvider where Content: LinkProvider {
    var url: String {
        content.url
    }
}

extension ModifiedHTML: DropdownItemConfigurable where Content: DropdownItemConfigurable {
    var configuration: DropdownConfiguration {
        get { content.configuration }
        set { content.configuration = newValue }
    }
}

extension ModifiedHTML: ImageElement where Content: ImageElement {}

extension ModifiedHTML: ColumnProvider where Content: ColumnProvider {}
