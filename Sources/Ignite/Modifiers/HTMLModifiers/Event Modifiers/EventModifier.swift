//
// EventModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Adds an event attribute to the `HTML` element.
    /// - Parameters:
    ///   - type: The name of the attribute.
    ///   - actions: Array of actions to execute when the event occurs
    /// - Returns: A modified HTML element with the specified attribute.
    func onEvent(_ type: EventType, _ actions: [Action]) -> some HTML {
        modifier(EventModifier(type: type, actions: actions))
    }
}

public extension InlineElement {
    /// Adds an event attribute to the `InlineHTML` element.
    /// - Parameters:
    ///   - type: The name of the attribute.
    ///   - actions: Array of actions to execute when the event occurs
    /// - Returns: A modified HTML element with the specified attribute.
    func onEvent(_ type: EventType, _ actions: [Action]) -> some InlineElement {
        modifier(InlineEventModifier(type: type, actions: actions))
    }
}

private struct EventModifier: HTMLModifier {
    var type: EventType
    var actions: [Action]
    func body(content: Content) -> some HTML {
        var content = content
        guard !actions.isEmpty else { return content }
        content.attributes.events.append(Event(name: type.rawValue, actions: actions))
        return content
    }
}

private struct InlineEventModifier: InlineElementModifier {
    var type: EventType
    var actions: [Action]
    func body(content: Content) -> some InlineElement {
        var content = content
        guard !actions.isEmpty else { return content }
        content.attributes.events.append(Event(name: type.rawValue, actions: actions))
        return content
    }
}
