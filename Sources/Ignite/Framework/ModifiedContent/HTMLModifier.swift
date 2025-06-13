//
// HTMLModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
public protocol HTMLModifier {
    associatedtype Body: HTML
    typealias Content = ModifiedContentProxy<Self>
    func body(content: Content) -> Body
}
