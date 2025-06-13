//
// NavigationBarVisibilityProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
protocol NavigationBarVisibilityProvider {
    var navigationBarVisibility: NavigationBarVisibility { get }
}
