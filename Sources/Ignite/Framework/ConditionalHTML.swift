//
// ConditionalHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
public struct ConditionalHTML<TrueContent, FalseContent>: Sendable { // swiftlint:disable:this redundant_sendable

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

extension ConditionalHTML: HTML where TrueContent: HTML, FalseContent: HTML {
    public var body: Never { fatalError() }

    public func render() -> Markup {
        switch storage {
        case .trueContent(let content):
            content.attributes(attributes).render()
        case .falseContent(let content):
            content.attributes(attributes).render()
        }
    }
}

extension ConditionalHTML: InlineElement, CustomStringConvertible
where TrueContent: InlineElement, FalseContent: InlineElement {
    public var body: Never { fatalError() }

    public func render() -> Markup {
        switch storage {
        case .trueContent(let content):
            content.attributes(attributes).render()
        case .falseContent(let content):
            content.attributes(attributes).render()
        }
    }
}

extension ConditionalHTML: ControlGroupElement
where TrueContent: ControlGroupElement, FalseContent: ControlGroupElement {
    public func render() -> Markup {
        switch storage {
        case .trueContent(let content):
            var content = content
            content.attributes.merge(attributes)
            return content.render()
        case .falseContent(let content):
            var content = content
            content.attributes.merge(attributes)
            return content.render()
        }
    }
}
