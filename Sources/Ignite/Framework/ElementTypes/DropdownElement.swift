//
// DropdownElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Elements that conform to `DropdownElement` can be shown inside
/// Dropdown objects.
@MainActor
public protocol DropdownElement {
    var attributes: CoreAttributes { get set }
    func render() -> Markup
}

@MainActor
protocol DropdownElementRepresentable {
    func renderAsDropdownElement() -> Markup
}
