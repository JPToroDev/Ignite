//
// VariadicHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that applies transformations to its subviews
/// during rendering.
@MainActor
protocol VariadicHTML {
    var subviews: SubviewsCollection { get }
}
