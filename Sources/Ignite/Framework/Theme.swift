//
// Theme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Themes allow you to have complete control over the HTML used to generate
/// your pages.
public protocol Theme {
    var id: UUID { get }
    func render(page: Page, context: PublishingContext) async -> HTML
}

public extension Theme {
    var id: UUID { UUID() }
}
