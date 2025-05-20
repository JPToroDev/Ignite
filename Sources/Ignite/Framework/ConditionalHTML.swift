//
// ConditionalHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
public struct ConditionalHTML<TrueContent, FalseContent> {

    public var attributes = CoreAttributes()

    let storage: Storage

    enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }

    init(storage: Storage) {
        self.storage = storage
    }
}

extension ConditionalHTML: HTML, MarkupElement, Sendable where TrueContent: HTML, FalseContent: HTML {
    public var body: some HTML { fatalError() }

    public func markup() -> Markup {
        switch storage {
        case .trueContent(let content):
            content.attributes(attributes).markup()
        case .falseContent(let content):
            content.attributes(attributes).markup()
        }
    }
}

extension ConditionalHTML: NavigationElement where TrueContent: NavigationElement, FalseContent: NavigationElement {}
