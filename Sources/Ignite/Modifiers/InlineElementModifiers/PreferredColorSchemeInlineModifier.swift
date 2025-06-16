//
// PreferredColorSchemeInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies color scheme preferences to inline HTML elements.
struct PreferredColorSchemeInlineModifier: InlineElementModifier {
    /// The color scheme to apply, or `nil` to use the default.
    var colorScheme: ColorScheme?

    /// Returns the modified inline element with the specified color scheme applied.
    func body(content: Content) -> some InlineElement {
        var modified = content
        guard let colorScheme else { return modified }
        let attributes = PreferredColorSchemeModifier.attributes(for: colorScheme)
        modified.attributes.merge(attributes)
        return modified
    }
}

public extension InlineElement {
    /// A modifier that sets the preferred color scheme for a container element.
    /// - Note: When used with `Material`, this modifier should be applied to the element containing the `Material`.
    /// - Parameter colorScheme: The preferred color scheme to use. If `nil`, no color scheme is enforced.
    /// - Returns: A modified HTML element with the specified color scheme.
    func preferredColorScheme(_ colorScheme: ColorScheme?) -> some InlineElement {
      modifier(PreferredColorSchemeInlineModifier(colorScheme: colorScheme))
    }
}
