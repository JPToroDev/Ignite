//
// Clipped.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct ClippedModifier: HTMLModifier {
    var isClipped: Bool = true
    func body(content: Content) -> some HTML {
        content.style(.overflow, isClipped ? "hidden" : "visible")
    }
}

public extension HTML {
    /// Applies CSS overflow:hidden to clip the element's content to its bounds.
    /// - Parameter clipped: Whether content should be visible outside the container bounds.
    /// - Returns: A modified copy of the element with clipping applied
    func clipped(_ clipped: Bool = true) -> some HTML {
        ModifiedHTML(content: self, modifier: ClippedModifier(isClipped: clipped))
    }
}
