//
// SubviewsProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that has `PackHTML` as its root view.
@MainActor
protocol SubviewsProvider {
    var subviews: SubviewsCollection { get }
}
