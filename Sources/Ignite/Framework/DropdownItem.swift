//
// DropdownItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

//struct DropdownItem: HTML {
//    /// The content and behavior of this HTML.
//    var body: Never { fatalError() }
//
//    /// The standard set of control attributes for HTML elements.
//    var attributes = CoreAttributes()
//
//    /// The underlying HTML content, unattributed.
//    var content: any DropdownElement
//
//    init(_ content: any DropdownElement) {
//        self.content = content
//    }
//
//    func markup() -> Markup {
//        if let link = content as? LinkProvider {
//
//        } else if let text = content as? any TextProvider {
//
//        } else {
//            return content.markup()
//        }
//    }
//}

private extension DropdownElement {
    func `class`(_ classes: String?...) -> Self {
        var copy = self
        copy.attributes.append(classes: classes.compactMap(\.self))
        return copy
    }

    func aria(_ key: AriaType, _ value: String?) -> Self {
        guard let value else { return self }
        var copy = self
        copy.attributes.append(aria: .init(name: key.rawValue, value: value))
        return copy
    }
}
