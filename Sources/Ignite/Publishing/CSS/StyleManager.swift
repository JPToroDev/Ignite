//
// StyleManager.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A manager responsible for generating and maintaining CSS classes from Style implementations.
/// This class handles style caching, CSS generation, and integration with the publishing process.
@MainActor
final class StyleManager {
    /// The shared instance used for managing styles across the application
    static let shared = StyleManager()

    // Private initializer to enforce singleton pattern
    private init() {}

    /// Dictionary of registered styles keyed by their type names
    private var registeredStyles = [any Style]()

    /// Button styles the need to be generated in the CSS output.
    private var buttonStyles = [any ButtonStyle]()

    /// A structure that holds the default style and all unique style variations for a given `Style`.
    struct StyleMapResult {
        /// The default style attributes that apply when no conditions are met.
        let defaultStyles: [InlineStyle]

        /// A mapping of environment conditions to their corresponding style attributes,
        /// containing only the minimal conditions needed for each unique style variation.
        let uniqueConditions: [EnvironmentConditions: [InlineStyle]]
    }

    /// Context for processing style variations
    private struct StyleVariationContext {
        let environment: EnvironmentConditions
        let styles: [InlineStyle]
        let collector: ElementProxy
        let style: any Style
        let defaultStyles: [InlineStyle]
    }

    /// Registers a style for CSS generation
    /// - Parameter style: The style to register
    func registerStyle(_ style: any Style) {
        registeredStyles.append(style)
    }

    /// Registers a button style for CSS generation
    /// - Parameter style: The `ButtonStyle` to register
    func registerButtonStyle(_ style: any ButtonStyle) {
        buttonStyles.append(style)
    }

    /// Generates CSS for all registered styles using the provided themes
    /// - Parameter themes: Array of themes to generate theme-specific styles for
    /// - Returns: Complete CSS string for all styles
    func generateAllCSS(themes: [any Theme]) -> String {
        var cssRules = registeredStyles.map { style in
            generateCSS(style: style, themes: themes)
        }

        for theme in themes {
            for style in buttonStyles {
                let styles = generateButtonStyles(for: style, theme: theme)
                cssRules.append(contentsOf: styles)
            }
        }

        return cssRules.joined(separator: "\n\n")
    }

    /// Generate the CSS of a button style.
    private func generateButtonStyles(for style: any ButtonStyle, theme: Theme) -> [String] {
        let buttonConfig = style.style(button: .init(), theme: theme)
        guard buttonConfig.isEmpty == false else { return [] }

        let baseSelector = Selector.anyChild(
            .attribute("data-ig-theme", value: theme.cssID),
            .class(style.className))

        let styleConfigs: [(styles: [InlineStyle], pseudoClass: String?)] = [
            (buttonConfig.defaultStyles.map { $0.important() }, nil),
            (buttonConfig.hoveredStyles.map { $0.important() }, "hover"),
            (buttonConfig.pressedStyles.map { $0.important() }, "active"),
            (buttonConfig.disabledStyles.map { $0.important() }, "disabled")
        ]

        let rulesets = styleConfigs.compactMap { config -> Ruleset? in
            guard !config.styles.isEmpty else { return nil }
            let selector = config.pseudoClass.map { baseSelector.chaining(.pseudoClass($0)) } ?? baseSelector
            return Ruleset(selector, styles: config.styles)
        }

        return rulesets.map { $0.render() }
    }
}
