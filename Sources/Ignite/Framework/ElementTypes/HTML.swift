//
// HTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines the core behavior and
/// structure of `HTML` elements in Ignite.
@MainActor
public protocol HTML: MarkupElement {
    /// The type of HTML content this element contains.
    associatedtype Body: HTML

    /// The content and behavior of this `HTML` element.
    @HTMLBuilder var body: Body { get }
}

public extension HTML {
    /// Generates the complete `HTML` string representation of the element.
    func markup() -> Markup {
        body.markup()
    }
}

extension HTML {
    /// The default status as a primitive element.
    var isPrimitive: Bool {
        Self.Body.self == Never.self
    }

    /// Checks if this element is an empty HTML element.
    var isEmpty: Bool {
        markup().isEmpty
    }

    /// Whether the outermost element of this type is a `<div>`
    /// that can position its contents.
    var requiresPositioningContext: Bool {
        markup().string.hasPrefix("<div") == false
    }

    /// How this element should be sized in a `Grid`.
    var columnWidth: ColumnWidth {
        let prefix = "col-md-"

        if let width = attributes.classes.first(where: { $0.hasPrefix(prefix) }),
           let count = Int(width.dropFirst(prefix.count)) {
            return .count(count)
        }

        if attributes.classes.contains("col") {
            return .uniform
        }

        if attributes.classes.contains("col-auto") {
            return .intrinsic
        }

        return .uniform
    }
}

extension HTML {
    /// Adds an event handler to the element.
    /// - Parameters:
    ///   - name: The name of the event (e.g., "click", "mouseover")
    ///   - actions: Array of actions to execute when the event occurs
    /// - Returns: The modified `HTML` element
    mutating func addEvent(name: String, actions: [Action]) {
        guard !actions.isEmpty else { return }
        let event = Event(name: name, actions: actions)
        attributes.events.append(event)
    }

    /// Sets the tabindex behavior for this element.
    /// - Parameter tabFocus: The TabFocus enum value defining keyboard navigation behavior
    /// - Returns: The modified HTML element
    /// - Note: Adds appropriate HTML attribute based on TabFocus enum
    func tabFocus(_ tabFocus: TabFocus) -> some HTML {
        customAttribute(name: tabFocus.htmlName, value: tabFocus.value)
    }

    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    mutating func columnWidth(_ width: ColumnWidth) {
        attributes.classes.append(width())
    }
}
