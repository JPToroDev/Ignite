//
// CarouselElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
public protocol CarouselElement {
    var attributes: CoreAttributes { get set }
    func markup() -> Markup
}

extension CarouselElement {
    func subviews() -> CarouselSubviewsCollection {
        CarouselSubviewsCollection(self)
    }
}
