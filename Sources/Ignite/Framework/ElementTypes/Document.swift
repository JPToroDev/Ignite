//
// HTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public protocol Document: MarkupElement {
    var body: Body { get }
    var head: Head { get }
}
