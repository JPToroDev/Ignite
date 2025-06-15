//
// HeadElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A metadata element that can exist in the `Head` struct.
/// - Warning: Do not conform to this type directly.
@MainActor
public protocol HeadElement: Sendable {
    var attributes: CoreAttributes { get set }
    func render() -> Markup
}

extension HeadElement {
    /// The publishing context of this site.
    var publishingContext: PublishingContext {
        PublishingContext.shared
    }

    /// Converts this element and its children into an HTML string with attributes.
    /// - Returns: A string containing the HTML markup
    func markupString() -> String {
        render().string
    }
}
