//
// EmptyButtonStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A button style that applies no styling to a button.
public struct EmptyButtonStyle: ButtonStyle {
    /// Returns the button without any style modifications.
    /// - Parameter button: The button to style.
    /// - Returns: The unmodified button.
    public func style(button: ButtonProxy) -> ButtonProxy {
        button
    }
}
