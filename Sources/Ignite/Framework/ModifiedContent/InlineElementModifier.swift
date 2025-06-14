//
// InlineElementModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
public protocol InlineElementModifier {
    associatedtype Body: InlineElement
    typealias Content = InlineModifiedContentProxy<Self>
    @InlineElementBuilder func body(content: Content) -> Body
}
