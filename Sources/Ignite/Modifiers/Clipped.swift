//
// Clipped.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that controls content clipping behavior.
private struct ClippedModifier: HTMLModifier {
    /// Whether content should be clipped to the element's bounds.
    var isClipped: Bool = true
    
    /// Applies overflow styling to the content.
    /// - Parameter content: The HTML content to modify.
    /// - Returns: The content with overflow styling applied.
    func body(content: Content) -> some HTML {
        content.style(.overflow, isClipped ? "hidden" : "visible")
    }
}

public extension HTML {
    /// Applies CSS overflow:hidden to clip the element's content to its bounds.
    /// - Parameter clipped: Whether content should be visible outside the container bounds.
    /// - Returns: A modified copy of the element with clipping applied
    func clipped(_ clipped: Bool = true) -> some HTML {
        modifier(ClippedModifier(isClipped: clipped))
    }
}
