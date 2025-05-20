//
// BadgeModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Adds a badge to the right side of this element.
    /// - Parameter badge: The badge to display.
    /// - Returns: A list item containing the original content and badge.
    func badge<T: InlineElement>(_ badge: Badge<T>) -> some HTML {
        ListItem {
            self
            badge
        }
        .class("d-flex", "justify-content-between", "align-items-center")
    }
}

public extension InlineElement {
    /// Adds a badge to the right side of this element.
    /// - Parameter badge: The badge to display.
    /// - Returns: A list item containing the original content and badge.
    func badge<T: InlineElement>(_ badge: Badge<T>) -> some HTML {
        ListItem {
            self
            badge
        }
        .class("d-flex", "justify-content-between", "align-items-center")
    }
}
