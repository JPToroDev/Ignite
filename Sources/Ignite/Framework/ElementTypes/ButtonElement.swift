//
// ButtonElement.swift.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
public protocol ButtonElement {
    var attributes: CoreAttributes { get set }
    func markup() -> Markup
}
