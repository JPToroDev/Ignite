//
// PreferredColorScheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// A modifier that sets the preferred color scheme for a container element.
    /// - Note: When used with `Material`, this modifier should be applied to the element containing the `Material`.
    /// - Parameter colorScheme: The preferred color scheme to use. If `nil`, no color scheme is enforced.
    /// - Returns: A modified HTML element with the specified color scheme.
    func preferredColorScheme(_ colorScheme: ColorScheme?) -> some HTML {
        guard let colorScheme else { return AnyHTML(self) }
        var modified: any HTML = self.data("bs-theme", colorScheme.rawValue)

        if colorScheme == .dark, let darkThemeID = publishingContext.site.darkTheme?.cssID {
            modified = modified.data("ig-theme", darkThemeID)
        }

        if colorScheme == .light, let lightThemeID = publishingContext.site.lightTheme?.cssID {
            modified = modified.data("ig-theme", lightThemeID)
        }

        return AnyHTML(modified)
    }
}

public extension InlineElement {
    /// A modifier that sets the preferred color scheme for a container element.
    /// - Note: When used with `Material`, this modifier should be applied to the element containing the `Material`.
    /// - Parameter colorScheme: The preferred color scheme to use. If `nil`, no color scheme is enforced.
    /// - Returns: A modified HTML element with the specified color scheme.
    func preferredColorScheme(_ colorScheme: ColorScheme?) -> some InlineElement {
        guard let colorScheme else { return AnyInlineElement(self) }
        var modified: any InlineElement = self.data("bs-theme", colorScheme.rawValue)

        if colorScheme == .dark, let darkThemeID = publishingContext.site.darkTheme?.cssID {
            modified = modified.data("ig-theme", darkThemeID)
        }

        if colorScheme == .light, let lightThemeID = publishingContext.site.lightTheme?.cssID {
            modified = modified.data("ig-theme", lightThemeID)
        }

        return AnyInlineElement(modified)
    }
}
