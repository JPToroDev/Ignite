//
// Clipped.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Applies CSS overflow:hidden to clip the element's content to its bounds.
    /// - Parameter clipped: Whether content should be visible outside the container bounds.
    /// - Returns: A modified copy of the element with clipping applied
    func clipped(_ clipped: Bool = true) -> some HTML {
        self.style(.overflow, clipped ? "hidden" : "visible")
    }
}
