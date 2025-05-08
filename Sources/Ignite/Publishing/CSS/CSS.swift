//
// CSS.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Any type that can be expressed in CSS.
protocol CSS {
    /// Returns the rendered CSS.
    func render() -> String
}
