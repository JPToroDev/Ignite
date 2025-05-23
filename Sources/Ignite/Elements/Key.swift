//
// Key.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Denotes textual user input from a keyboard, voice input,
/// or any other text entry device
public struct Key: InlineElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The code to display.
    private var content: String

    /// Creates a new `Key` instance from the given content.
    /// - Parameter content: The keyboard input you want to render.
    public init(_ content: String) {
        self.content = content
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        Markup("<kbd\(attributes)>\(content)</kbd>")
    }
}
