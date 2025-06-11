//
// InlineHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An element that exists inside a block element, such as an emphasized
/// piece of text.
@MainActor
public protocol InlineElement: CustomStringConvertible, Sendable {
    /// The type of HTML content this element contains.
    associatedtype Body: InlineElement
    
    /// The content and behavior of this element.
    @InlineElementBuilder var body: Body { get }
    
    var attributes: CoreAttributes { get set }
    
    func markup() -> Markup
}

public extension InlineElement {
    /// A collection of styles, classes, and attributes.
    var attributes: CoreAttributes {
        get { CoreAttributes() }
        set {} // swiftlint:disable:this unused_setter_value
    }
    
    /// Generates the complete HTML string representation of the element.
    func markup() -> Markup {
        body.markup()
    }
}

extension InlineElement {
    /// Converts this element and its children into an HTML string with attributes.
    /// - Returns: A string containing the HTML markup
    func markupString() -> String {
        markup().string
    }

    /// The publishing context of this site.
    var publishingContext: PublishingContext {
        PublishingContext.shared
    }
}

public extension InlineElement {
    /// The complete string representation of the element.
    nonisolated var description: String {
        MainActor.assumeIsolated {
            self.markupString()
        }
    }
}

extension InlineElement {
    /// The default status as a primitive element.
    var isPrimitive: Bool {
        Self.Body.self == Never.self
    }

    /// Adds an event handler to the element.
    /// - Parameters:
    ///   - name: The name of the event (e.g., "click", "mouseover")
    ///   - actions: Array of actions to execute when the event occurs
    /// - Returns: The modified `InlineElement`
    mutating func addEvent(name: String, actions: [Action]) {
        guard !actions.isEmpty else { return }
        let event = Event(name: name, actions: actions)
        attributes.events.append(event)
    }

    /// Checks if this element is `EmptyInlineElement`
    var isEmpty: Bool {
        markup().isEmpty
    }
}
