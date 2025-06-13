//
// LineHeight.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Predefined line height values that match Bootstrap's spacing system.
public enum LineSpacing: String, CaseIterable, Sendable {
    /// Single line height (1.0)
    case xSmall = "1"

    /// Compact line height (1.25)
    case small = "sm"

    /// Default line height (1.5)
    case standard = "base"

    /// Relaxed line height (2.0)
    case large = "lg"

    /// The actual multiplier value for this line height
    var value: Double {
        switch self {
        case .xSmall: 1.0
        case .small: 1.25
        case .standard: 1.5
        case .large: 2.0
        }
    }
}

public extension ElementProxy {
    /// Sets the line height of the element using a custom value.
    /// - Parameter height: The line height multiplier to use
    /// - Returns: The modified HTML element
    func lineSpacing(_ height: Double) -> Self {
        self.style(.lineHeight, String(height))
    }
}

public extension HTML {
    /// Sets the line height of the element using a custom value.
    /// - Parameter spacing: The line height multiplier to use.
    /// - Returns: The modified HTML element.
    func lineSpacing(_ spacing: Double) -> some HTML {
        LineSpacedHTML(self, spacing: .exact(spacing))
    }

    /// Sets the line height of the element using a predefined Bootstrap value.
    /// - Parameter spacing: The predefined line height to use.
    /// - Returns: The modified HTML element.
    func lineSpacing(_ spacing: LineSpacing) -> some HTML {
        LineSpacedHTML(self, spacing: .semantic(spacing))
    }
}

public extension InlineElement {
    /// Sets the line height of the element using a custom value.
    /// - Parameter spacing: The line height multiplier to use.
    /// - Returns: The modified InlineElement element.
    func lineSpacing(_ spacing: Double) -> some InlineElement {
        modifier(LineSpacingInlineModifier(spacing: .exact(spacing)))
    }

    /// Sets the line height of the element using a predefined Bootstrap value.
    /// - Parameter spacing: The predefined line height to use.
    /// - Returns: The modified InlineElement element.
    func lineSpacing(_ spacing: LineSpacing) -> some InlineElement { modifier(LineSpacingInlineModifier(spacing: .semantic(spacing)))
    }
}

private struct LineSpacingInlineModifier: InlineElementModifier {
    var spacing: Amount<Double, LineSpacing>
    func body(content: Content) -> some InlineElement {
        var modified = content
        switch spacing {
        case .exact(let spacing):
            modified.attributes.append(styles: .init(.lineHeight, value: spacing.formatted(.nonLocalizedDecimal)))
        case .semantic(let spacing):
            modified.attributes.append(classes: "lh-\(spacing.rawValue)")
        default: modified
        }
        return modified
    }
}
