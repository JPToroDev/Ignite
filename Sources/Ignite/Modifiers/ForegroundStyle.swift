//
// ForegroundStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Common foreground styles that allow for clear readability.
public enum ForegroundStyle: String, Sendable, CaseIterable {
    case primary = "text-primary"
    case primaryEmphasis = "text-primary-emphasis"
    case secondary = "text-body-secondary"
    case tertiary = "text-body-tertiary"

    case success = "text-success"
    case successEmphasis = "text-success-emphasis"
    case danger = "text-danger"
    case dangerEmphasis = "text-danger-emphasis"
    case warning = "text-warning"
    case warningEmphasis = "text-warning-emphasis"
    case info = "text-info"
    case infoEmphasis = "text-info-emphasis"
    case light = "text-light"
    case lightEmphasis = "text-light-emphasis"
    case dark = "text-dark"
    case darkEmphasis = "text-dark-emphasis"
    case body = "text-body"
    case bodyEmphasis = "text-body-emphasis"
}

/// The type of style this contains.
private enum StyleType {
    case none
    case string(String)
    case color(Color)
    case style(ForegroundStyle)
    case gradient(Gradient)
}

/// The inline styles required to create text gradients.
private func styles(for gradient: Gradient) -> [InlineStyle] {
    [.init(.backgroundImage, value: gradient.description),
     .init(.backgroundClip, value: "text"),
     .init(.color, value: "transparent")]
}

public extension HTML {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: Color) -> some HTML {
        ForegroundStyledHTML(self, style: .color(color))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a string.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: String) -> some HTML {
        ForegroundStyledHTML(self, style: .string(color))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter style: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ style: ForegroundStyle) -> some HTML {
        ForegroundStyledHTML(self, style: .style(style))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter gradient: The style to apply, specified as a `Gradient` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ gradient: Gradient) -> some HTML {
        ForegroundStyledHTML(self, style: .gradient(gradient))
    }
}

public extension InlineElement {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: Color) -> some InlineElement {
        ForegroundStyledInlineElement(self, style: .color(color))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a string.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: String) -> some InlineElement {
        ForegroundStyledInlineElement(self, style: .string(color))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter style: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ style: ForegroundStyle) -> some InlineElement {
        ForegroundStyledInlineElement(self, style: .style(style))
    }

    /// Applies a foreground color to the current element.
    /// - Parameter gradient: The style to apply, specified as a `Gradient` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ gradient: Gradient) -> some InlineElement {
        ForegroundStyledInlineElement(self, style: .gradient(gradient))
    }
}

public extension ElementProxy {
    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `Color` object.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: Color) -> Self {
        self.style(.color, color.description)
    }

    /// Applies a foreground color to the current element.
    /// - Parameter color: The style to apply, specified as a `String`.
    /// - Returns: The current element with the updated color applied.
    func foregroundStyle(_ color: String) -> Self {
        self.style(.color, color)
    }
}

private struct ForegroundStyledHTML<Content: HTML>: HTML {
    var attributes = CoreAttributes()

    var body: some HTML { fatalError() }

    var content: Content
    var style: StyleType

    init(_ content: Content, style: StyleType) {
        self.content = content
        self.style = style
    }

    func markup() -> Markup {
        switch style {
        case .none:
            content
                .markup()
        case .gradient(let gradient) where content is any TextElement:
            content
                .style(styles(for: gradient))
                .markup()
        case .gradient(let gradient):
            Section(content.class("color-inherit"))
                .style(styles(for: gradient))
                .markup()
        case .string(let string) where content is any TextElement:
            content
                .style(.color, string)
                .markup()
        case .string(let string):
            Section(content.class("color-inherit"))
                .style(.color, string)
                .markup()
        case .color(let color) where content is any TextElement:
            content
                .style(.color, color.description)
                .markup()
        case .color(let color):
            Section(content.class("color-inherit"))
                .style(.color, color.description)
                .markup()
        case .style(let foregroundStyle):
            content
                .class(foregroundStyle.rawValue)
                .markup()
        }
    }
}

extension ForegroundStyledHTML: TextElement where Content: TextElement {
    var fontStyle: FontStyle {
        get { content.fontStyle }
        set { content.fontStyle = newValue }
    }
}

private struct ForegroundStyledInlineElement<Content: InlineElement>: InlineElement {
    var attributes = CoreAttributes()

    var body: some InlineElement { fatalError() }

    var content: Content
    var style: StyleType

    init(_ content: Content, style: StyleType) {
        self.content = content
        self.style = style
    }

    func markup() -> Markup {
        switch style {
        case .none:
            content
                .markup()
        case .gradient(let gradient):
            content
                .style(styles(for: gradient))
                .markup()
        case .string(let string):
            content
                .style(.color, string)
                .markup()
        case .color(let color):
            content
                .style(.color, color.description)
                .markup()
        case .style(let foregroundStyle):
            content
                .class(foregroundStyle.rawValue)
                .markup()
        }
    }
}
