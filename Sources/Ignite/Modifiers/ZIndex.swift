//
// ZIndex.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// A modifier that sets the z-index of an HTML element.
    /// - Parameter index: The z-index value to apply. Higher values appear in front.
    /// - Returns: The modified HTML element.
    func zIndex(_ index: Int) -> some HTML {
        self.style(.zIndex, index.formatted())
    }
}

public extension ElementProxy {
    /// A modifier that sets the z-index of a styled HTML element.
    /// - Parameter index: The z-index value to apply. Higher values appear in front.
    /// - Returns: The modified styled HTML element.
    func zIndex(_ index: Int) -> Self {
        self.style(.zIndex, index.formatted())
    }
}
