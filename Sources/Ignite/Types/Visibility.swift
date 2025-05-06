//
// Visibility.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents whether a component should be displayed or hidden from view.
public enum Visibility: Sendable {
    /// The element is not displayed in the view hierarchy.
    case hidden

    /// The element is displayed normally in the view hierarchy.
    case visible
}
