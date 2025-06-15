//
// AccordionElement.swift.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
public protocol AccordionElement {
    var attributes: CoreAttributes { get set }
    func render() -> Markup
}

extension AccordionElement {
    func subviews() -> AccordionSubviewsCollection {
        AccordionSubviewsCollection(self)
    }
}
