//
// LinkProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
protocol LinkProvider {
    var url: String { get }
}
