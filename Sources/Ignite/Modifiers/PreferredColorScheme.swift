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
        if let colorScheme {
            AnyHTML(self.data("bs-theme", colorScheme.rawValue))
        } else {
            AnyHTML(self)
        }
    }
}

public extension InlineElement {
    /// A modifier that sets the preferred color scheme for a container element.
    /// - Note: When used with `Material`, this modifier should be applied to the element containing the `Material`.
    /// - Parameter colorScheme: The preferred color scheme to use. If `nil`, no color scheme is enforced.
    /// - Returns: A modified HTML element with the specified color scheme.
    func preferredColorScheme(_ colorScheme: ColorScheme?) -> some InlineElement {
        if let colorScheme {
            AnyInlineElement(self.data("bs-theme", colorScheme.rawValue))
        } else {
            AnyInlineElement(self)
        }
    }
}
