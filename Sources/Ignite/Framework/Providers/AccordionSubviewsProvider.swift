//
// AccordionSubviewsProvider.swift.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
protocol AccordionSubviewsProvider {
    var children: AccordionSubviewsCollection { get }
}
