//
// ZIndex.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that sets the z-index of an HTML element.
/// - Parameter index: The z-index value to apply. Higher values appear in front.
/// - Returns: The modified HTML element.
public extension HTML {
    func zIndex(_ index: Int) -> some HTML {
        self.style(.zIndex, index.formatted())
    }
}

/// A modifier that sets the z-index of a styled HTML element.
/// - Parameter index: The z-index value to apply. Higher values appear in front.
/// - Returns: The modified styled HTML element.
public extension StyledHTML {
    func zIndex(_ index: Int) -> StyledHTML {
        self.style(.zIndex, index.formatted())
    }
}
