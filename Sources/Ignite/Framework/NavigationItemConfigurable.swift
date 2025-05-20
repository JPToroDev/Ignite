//
// NavigationItemConfigurable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that allows elements to be configured for placement in a navigation bar.
@MainActor
protocol NavigationItemConfigurable {
    /// Whether this element is configured as a navigation item.
    func configuredAsNavigationItem() -> NavigationItem
}
