//
// ModifiedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
struct ModifiedHTML<Content, Modifier> {
    /// The body of this HTML element, which is itself
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    var content: Content

    var modifier: Modifier

    init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }
}

extension ModifiedHTML: HTML, Sendable where Content: HTML, Modifier: HTMLModifier {
    func markup() -> Markup {
        let proxy = ModifiedContentProxy(content: content, modifier: modifier)
        var modified = modifier.body(content: proxy)
        modified.attributes.merge(attributes)
        return modified.markup()
    }
}

extension ModifiedHTML: PackProvider where Content: PackProvider {
    var children: Children {
        print("working!!!!")
        return content.children
    }
}

extension ModifiedHTML: FormItem where Content: FormItem {
    func markup() -> Markup {
        Markup()
    }
}

extension ModifiedHTML: ListElement where Content: ListElement {
    func markupAsListItem() -> Markup {
        content.markupAsListItem()
    }
}

extension ModifiedHTML: ImageElement where Content: ImageElement {}

extension ModifiedHTML: SpacerProvider where Content: SpacerProvider {
    var spacer: Spacer { content.spacer }
}

extension ModifiedHTML: TextProvider where Content: TextProvider {
    var fontStyle: FontStyle {
        get { content.fontStyle }
        set { content.fontStyle = newValue }
    }
}

extension ModifiedHTML: NavigationElement where Content: NavigationElement {}

extension ModifiedHTML: ColumnProvider where Content: ColumnProvider {}

extension ModifiedHTML: @MainActor LinkProvider where Content: LinkProvider {
    var url: String {
        content.url
    }
}

extension ModifiedHTML: DropdownItemConfigurable where Content: DropdownItemConfigurable {
    func configuration(_ configuration: DropdownConfiguration) -> some HTML {
        content.configuration(configuration)
    }
}

@MainActor
struct VariadicTree<Root, Content> {
    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    var root: Root
    var content: Content

    init(root: Root, content: Content) {
        self.root = root
        self.content = content
    }
}

extension VariadicTree: HTML, Sendable where Root: VariadicRoot, Content: HTML {
    /// The body of this HTML element, which is itself
    var body: Never { fatalError() }

    func markup() -> Markup {
        let children = Children(content)
        let body = root.body(children: children)
        return body.markup()
    }
}

//extension VariadicTree: DropdownElement, Sendable where Root: VariadicRoot, Content: DropdownElement {
//    /// The body of this HTML element, which is itself
//    var body: Never { fatalError() }
//
//    func markup() -> Markup {
//        let children = Children(content)
//        let body = root.body(children: children)
//        return body.markup()
//    }
//}

@MainActor
protocol VariadicRoot {
    associatedtype Body: HTML
    func body(children: Children) -> Body
}

@MainActor
public protocol HTMLModifier {
    associatedtype Body: HTML
    typealias Content = ModifiedContentProxy<Self>
    func body(content: Content) -> Body
}

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

    public func markup() -> Markup {
        if content.isPrimitive {
            var content = content
            content.attributes.merge(attributes)
            return content.markup()
        } else if content.body.isPrimitive, content.markup().string.hasPrefix("<div") {
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

public extension HTML {
    func modifier<M: HTMLModifier>(_ modifier: M) -> some HTML {
        ModifiedHTML(content: self, modifier: modifier)
    }
}
