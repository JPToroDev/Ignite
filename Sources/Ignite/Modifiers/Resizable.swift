//
// Resizable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Makes an HTML element resizable in the specified direction
    /// - Parameter axis: The direction in which resizing is allowed
    /// - Returns: An HTML element that can be resized by the user
    func resizable(_ axis: Axis) -> some HTML {
        return self
            .style(.resize, axis.cssValue)
            .style(.overflow, "auto")
    }
}

private extension Axis {
    var cssValue: String {
        if self == .horizontal { return "horizontal" }
        if self == .vertical { return "vertical" }
        if self.contains(.horizontal) && self.contains(.vertical) { return "both" }
        return "none"
    }
}
