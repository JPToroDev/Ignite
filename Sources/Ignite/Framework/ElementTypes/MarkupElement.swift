//
// HTMLRenderable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines the common behavior between all HTML types.
/// - Warning: Do not conform to this type directly.
@MainActor
public protocol MarkupElement {
    /// The standard set of control attributes for HTML elements.
    var attributes: CoreAttributes { get set }

    /// Converts this element and its children into HTML markup.
    /// - Returns: A string containing the HTML markup
    func markup() -> Markup
}

extension MarkupElement {
    /// A collection of styles, classes, and attributes.
    var attributes: CoreAttributes {
        get { CoreAttributes() }
        set {} // swiftlint:disable:this unused_setter_value
    }
}

extension MarkupElement {
    /// Converts this element and its children into an HTML string with attributes.
    /// - Returns: A string containing the HTML markup
    func markupString() -> String {
        markup().string
    }
}
