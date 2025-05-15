//
// ConditionalHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public struct ConditionalHTML<TrueContent: BodyElement, FalseContent: BodyElement>: HTML {

    public var attributes = CoreAttributes()

    public var isPrimitive = true

    public var body: some HTML { self }

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
