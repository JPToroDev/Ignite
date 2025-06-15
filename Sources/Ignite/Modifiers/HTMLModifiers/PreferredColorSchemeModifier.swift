//
// PreferredColorScheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies color scheme preferences to HTML elements.
struct PreferredColorSchemeModifier: HTMLModifier {
    /// The color scheme to apply, or `nil` to use the default.
    var colorScheme: ColorScheme?
    
    func body(content: Content) -> some HTML {
        var modified = content
        guard let colorScheme else { return modified }
        var attributes = Self.attributes(for: colorScheme)
        modified.attributes.merge(attributes)
        return modified
    }

    /// Generates the appropriate data attributes for the specified color scheme.
    /// - Parameter colorScheme: The color scheme to generate attributes for.
    /// - Returns: Core attributes containing the necessary data attributes for theme application.
    static func attributes(for colorScheme: ColorScheme) -> CoreAttributes {
        var attributes = CoreAttributes()
        let publishingContext = PublishingContext.shared
        attributes.append(dataAttributes: .init(name: "bs-theme", value: colorScheme.rawValue))

        if colorScheme == .dark, let darkThemeID = publishingContext.site.darkTheme?.cssID {
            attributes.append(dataAttributes: .init(name: "ig-theme", value: darkThemeID))
        }

        if colorScheme == .light, let lightThemeID = publishingContext.site.lightTheme?.cssID {
            attributes.append(dataAttributes: .init(name: "ig-theme", value: lightThemeID))
        }
        return attributes
    }
}

public extension HTML {
    /// A modifier that sets the preferred color scheme for a container element.
    /// - Note: When used with `Material`, this modifier should be applied to the element containing the `Material`.
    /// - Parameter colorScheme: The preferred color scheme to use. If `nil`, no color scheme is enforced.
    /// - Returns: A modified HTML element with the specified color scheme.
    func preferredColorScheme(_ colorScheme: ColorScheme?) -> some HTML {
        modifier(PreferredColorSchemeModifier(colorScheme: colorScheme))
    }
}
