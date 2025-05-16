//
// ConditionalHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public struct ConditionalHTML<TrueContent: HTML, FalseContent: HTML>: HTML {

    public var body: some HTML { fatalError() }

    public var attributes = CoreAttributes()

    let storage: Storage

    enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }

    init(storage: Storage) {
        self.storage = storage
    }

    public func markup() -> Markup {
        switch storage {
        case .trueContent(let content):
            content.attributes(attributes).markup()
        case .falseContent(let content):
            content.attributes(attributes).markup()
        }
    }
}
