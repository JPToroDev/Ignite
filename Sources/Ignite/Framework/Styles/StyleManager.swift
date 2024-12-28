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
    static let `default` = StyleManager()

    /// Private initializer to enforce singleton pattern
    private init() {}

    /// Cache of generated CSS class names for styles
    private var classNameCache: [String: String] = [:]

    /// Cache of generated CSS rules for styles
    private var cssRulesCache: [String: String] = [:]

    /// Dictionary of registered styles keyed by their type names
    private var registeredStyles: [String: any Style] = [:]

    /// Gets or generates a CSS class name for a style
    /// - Parameter style: The style to get a class name for
    /// - Returns: The CSS class name for this style
    func className(for style: any Style) -> String {
        let typeName = String(describing: type(of: style))

        if let cached = classNameCache[typeName] {
            return cached
        }

        let baseName = typeName.hasSuffix("Style") ? typeName : typeName + "Style"
        let className = baseName.kebabCased()
        classNameCache[typeName] = className

        return className
    }

    /// Registers a style for CSS generation
    /// - Parameter style: The style to register
    func registerStyle(_ style: any Style) {
        let typeName = String(describing: type(of: style))
        registeredStyles[typeName] = style
    }

    /// Generates CSS for all registered styles using the provided themes
    /// - Parameter themes: Array of themes to generate theme-specific styles for
    /// - Returns: Complete CSS string for all styles
    func generateAllCSS(themes: [Theme]) -> String {
        cssRulesCache.removeAll()

        for (typeName, style) in registeredStyles {
            generateCSS(for: style, themes: themes)
        }

        return cssRulesCache.values.joined(separator: "\n\n")
    }

    /// Generates and caches CSS rules for a style
    /// - Parameters:
    ///   - style: The style to generate CSS for
    ///   - themes: Array of themes to generate theme-specific styles for
    private func generateCSS(for style: any Style, themes: [Theme]) {
        let typeName = String(describing: type(of: style))
        let collector = StyledHTML()
        var cssRules: [String] = []

        let conditions = generateMediaQueries(themes: themes)
        var stylesByCondition: [MediaQuery: CoreAttributes] = [:]

        // Collect all styles for each condition and track which themes were explicitly handled
        var explicitlyHandledThemes = Set<String>()

        for condition in conditions {
            let styledHTML = style.style(content: collector, environmentConditions: condition)
            if !styledHTML.attributes.styles.isEmpty {
                stylesByCondition[condition] = styledHTML.attributes
                // If this was a theme condition and it produced different styles from default,
                // mark it as explicitly handled
                if case .theme(let id) = condition {
                    explicitlyHandledThemes.insert(id)
                }
            }
        }

        // Find the style that appears most frequently across all media queries.
        let defaultStyle = stylesByCondition.values
            .max { a, b in
                stylesByCondition.values.filter { $0.styles == a.styles }.count <
                stylesByCondition.values.filter { $0.styles == b.styles }.count
            }

        if let defaultStyle = defaultStyle {
            // Generate the default rule
            let rule = """
            .\(className(for: style)) {
                \(defaultStyle.styles.map { "\($0.name): \($0.value)" }.joined(separator: "; "))
            }
            """
            cssRules.append(rule)

            // Only generate media queries for styles that differ from default
            for (condition, attributes) in stylesByCondition {
                if case .theme(let id) = condition {
                    // Only generate theme rule if it was explicitly handled in the style function
                    if explicitlyHandledThemes.contains(id) && attributes.styles != defaultStyle.styles {
                        let rule = generateCSSRule(
                            className: className(for: style),
                            attributes: attributes,
                            query: condition
                        )
                        cssRules.append(rule)
                    }
                } else if attributes.styles != defaultStyle.styles {
                    let rule = generateCSSRule(
                        className: className(for: style),
                        attributes: attributes,
                        query: condition
                    )
                    cssRules.append(rule)
                }
            }
        }

        let css = cssRules.joined(separator: "\n\n")
        cssRulesCache[typeName] = css
    }

    /// Generates an array of all possible media queries that styles should be tested against.
    /// - Parameter themes: Array of themes to generate theme-specific queries for
    /// - Returns: An array of MediaQuery cases
    private func generateMediaQueries(themes: [Theme]) -> [MediaQuery] {
        var queries: [MediaQuery] = []

        // Add theme-specific queries for all provided themes, excluding auto
        queries.append(contentsOf: themes
            .filter { $0.id != "auto" }
            .map { MediaQuery.theme($0.id) }
        )

        // Color scheme queries
        queries.append(contentsOf: [
            .colorScheme(.light),
            .colorScheme(.dark)
        ])

        // Motion preference queries
        queries.append(contentsOf: [
            .motion(.reduced),
            .motion(.allowed)
        ])

        // Contrast preference queries
        queries.append(contentsOf: [
            .contrast(.reduced),
            .contrast(.high),
            .contrast(.low)
        ])

        // Transparency preference queries
        queries.append(contentsOf: [
            .transparency(.reduced),
            .transparency(.normal)
        ])

        // Orientation queries
        queries.append(contentsOf: [
            .orientation(.portrait),
            .orientation(.landscape)
        ])

        // Display mode queries
        queries.append(contentsOf: [
            .displayMode(.browser),
            .displayMode(.fullscreen),
            .displayMode(.minimalUI),
            .displayMode(.pip),
            .displayMode(.standalone),
            .displayMode(.windowControlsOverlay)
        ])

        return queries
    }

    /// Generates a CSS rule for a specific style and media query
    /// - Parameters:
    ///   - className: The CSS class name to use
    ///   - attributes: The style attributes to apply
    ///   - query: The media query this rule applies to
    /// - Returns: A complete CSS rule string
    private func generateCSSRule(className: String, attributes: CoreAttributes, query: MediaQuery) -> String {
        var selector = ".\(className)"

        // Convert styles to CSS string
        let stylesString = attributes.styles
            .map { "\($0.name): \($0.value)" }
            .joined(separator: "; ")

        // Handle theme-specific case
        if case .theme(let id) = query {
            selector = "[data-theme-state=\"\(id.kebabCased())\"] \(selector)"
            return """
            \(selector) {
                \(stylesString)
            }
            """
        }

        // Handle media query cases
        return """
        @media (\(query.query)) {
            \(selector) {
                \(stylesString)
            }
        }
        """
    }
}
