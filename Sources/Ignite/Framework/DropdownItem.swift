//
// DropdownItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private extension DropdownElement {
    func `class`(_ classes: String?...) -> Self {
        var copy = self
        copy.attributes.append(classes: classes.compactMap(\.self))
        return copy
    }

    func aria(_ key: AriaType, _ value: String?) -> Self {
        guard let value else { return self }
        var copy = self
        copy.attributes.append(aria: .init(name: key.rawValue, value: value))
        return copy
    }
}
