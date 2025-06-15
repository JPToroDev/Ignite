//
// EmptyHoverEffect.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An empty hover effect type to which styles can be added
public struct EmptyHoverEffect: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    public func render() -> Markup { Markup() }
}
