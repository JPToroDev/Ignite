//
// SpacerProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
protocol SpacerProvider {
    var spacer: Spacer { get }
}

extension Spacer: SpacerProvider {
    var spacer: Spacer { self }
}
