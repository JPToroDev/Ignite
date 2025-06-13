//
// NavigationItemConfigurable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that allows elements to be configured for placement in a navigation bar.
@MainActor
protocol NavigationElementRepresentable {
    /// The navigation representation of this element.
    func renderAsNavigationElement() -> Markup
}
