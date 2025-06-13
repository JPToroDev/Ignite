//
// InlinePackProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
protocol InlineSubviewsProvider {
    var children: InlineSubviewsCollection { get }
}
