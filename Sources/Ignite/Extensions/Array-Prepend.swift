//
// Array-Prepend.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension Array {
    /// An extension that lets us add an element at the beginning of the array.
    mutating func prepend(_ element: Element) {
        self.insert(element, at: 0)
    }
}
