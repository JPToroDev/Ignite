//
// Style.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines a style that can be resolved based on environment conditions.
/// Styles are used to create reusable visual treatments that can adapt based on media queries
/// and theme settings.
///
/// Example:
/// ```swift
/// struct MyCustomStyle: Style {
///     func style(content: some HTML, environmentConditions: MediaQuery) -> some HTML {
///         switch environmentConditions {
///         case .colorScheme(.dark):
///             return content.style("red", for: .color)
///         default:
///             return content.style("blue", for: .color)
///         }
///     }
/// }
/// ```
@MainActor
public protocol Style: Hashable, Sendable {
    /// Resolves the style for the given HTML content and environment conditions
    /// - Parameters:
    ///   - content: An HTML element to apply styles to
    ///   - environmentConditions: The current media query condition to resolve against
    /// - Returns: A modified HTML element with the appropriate styles applied
    func style(content: StyledHTML, environmentConditions: EnvironmentConditions) -> StyledHTML
}

//
// StyleModifiers.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Applies a foreground style to the element
    /// - Parameter style: The style to apply
    /// - Returns: The modified element with the style applied
    @discardableResult
    func foregroundStyle(_ style: any Style) -> Self {
        // Get or generate the class name for this style
        let className = StyleManager.default.className(for: style)

        // Add the class to the element
        var element = self.class(className)

        // Ensure the style is registered for CSS generation
        StyleManager.default.registerStyle(style)

        return element
    }

    /// Applies a background style to the element
    /// - Parameter style: The style to apply
    /// - Returns: The modified element with the style applied
    @discardableResult
    func backgroundStyle(_ style: any Style) -> Self {
        let className = StyleManager.default.className(for: style)
        var element = self.class(className)
        StyleManager.default.registerStyle(style)
        return element
    }

    /// Applies a border style to the element
    /// - Parameter style: The style to apply
    /// - Returns: The modified element with the style applied
    @discardableResult
    func borderStyle(_ style: any Style) -> Self {
        let className = StyleManager.default.className(for: style)
        var element = self.class(className)
        StyleManager.default.registerStyle(style)
        return element
    }
}

/// A concrete type used for style resolution that only holds attributes
public struct StyledHTML {
    var attributes = CoreAttributes()

    /// Applies a style value for a given property
    /// - Parameters:
    ///   - value: The CSS value to apply
    ///   - property: The CSS property to set
    /// - Returns: A modified instance with the new style applied
    public func style(_ value: String, for property: Property) -> Self {
        var copy = self
        copy.attributes.append(style: property.rawValue, value: value)
        return copy
    }
}

