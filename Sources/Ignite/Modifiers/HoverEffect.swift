//
// HoverEffect.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies hover effects to HTML elements.
private struct HoverEffectModifier<Effect: HTML>: HTMLModifier {
    /// The effect closure that defines the hover behavior.
    var effect: (EmptyHoverEffect) -> Effect
    
    /// Creates the modified content with hover effect applied.
    /// - Parameter content: The content to modify
    /// - Returns: The content with hover effects applied
    func body(content: Content) -> some HTML {
        content.onHover { isHovering in
            if isHovering {
                let effectElement = effect(EmptyHoverEffect())
                let effectAttributes = effectElement.attributes
                ApplyHoverEffects(styles: effectAttributes.styles)
            } else {
                RemoveHoverEffects()
            }
        }
    }
}

public extension HTML {
    /// Applies a hover effect to the page element
    /// - Parameter effect: A closure that returns the effect to be applied.
    ///   The argument acts as a placeholder representing this page element.
    /// - Returns: A modified copy of the element with hover effect applied
    func hoverEffect(_ effect: @escaping (EmptyHoverEffect) -> some HTML) -> some HTML {
       modifier(HoverEffectModifier(effect: effect))
    }
}

private struct ApplyHoverEffects: Action {
    let styles: OrderedSet<InlineStyle>

    func compile() -> String {
        """
        this.unhoveredStyle = this.style.cssText;
        \(self.styles.map {
            "this.style.\($0.property.convertingCSSNamesToJS()) = '\($0.value)'"
        }.joined(separator: "; "))
        """
    }
}

private struct RemoveHoverEffects: Action {
    func compile() -> String {
        """
        this.style.cssText = this.unhoveredStyle;
        """
    }
}
