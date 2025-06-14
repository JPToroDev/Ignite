//
// SubviewsProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
protocol SubviewsProvider {
    var children: SubviewsCollection { get }
}

//@MainActor
//protocol SubviewsProvider {
//    associatedtype Body: HTML
//    func body(children: SubviewsCollection) -> Body
//}
