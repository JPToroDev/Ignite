//
// FontWeight.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that controls the font weight of HTML elements
struct FontWeightModifier: HTMLModifier {
    /// The weight value to apply to the text
    var weight: Font.Weight

    /// Applies font weight styling to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with font weight applied
    func body(content: some HTML) -> any HTML {
        content.style("font-weight: \(weight.rawValue)")
    }
}

public extension HTML {
    /// Adjusts the font weight (boldness) of this font.
    /// - Parameter weight: The new font weight.
    /// - Returns: A new `Text` instance with the updated weight.
    func fontWeight(_ weight: Font.Weight) -> some HTML {
        modifier(FontWeightModifier(weight: weight))
    }
}

public extension InlineHTML {
    /// Adjusts the font weight (boldness) of this font.
    /// - Parameter weight: The new font weight.
    /// - Returns: A new `Text` instance with the updated weight.
    func fontWeight(_ weight: Font.Weight) -> some InlineHTML {
        modifier(FontWeightModifier(weight: weight))
    }
}

public extension StyledHTML {
    /// Adjusts the font weight (boldness) of this font.
    /// - Parameter weight: The new font weight.
    /// - Returns: A new instance with the updated weight.
    func fontWeight(_ weight: Font.Weight) -> Self {
        self.style(.init(name: .fontWeight, value: String(weight.rawValue)))
    }
}
