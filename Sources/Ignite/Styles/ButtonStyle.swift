//
// ButtonStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines the style of a button.
public protocol ButtonStyle: Sendable {
    /// Styles a button according to the custom style implementation.
    /// - Parameters:
    ///    - button: The button to be styled.
    ///    - theme: The type of `Theme` this style applies to.
    /// - Returns: A new button with the applied style modifications.
    func style(button: ButtonProxy, theme: any Theme) -> ButtonProxy
}

extension ButtonStyle {
    /// The name of the CSS class this `ButtonStyle` generates,
    /// derived from the type name.
    var className: String {
        let typeName = String(describing: type(of: self))
        let className = typeName.kebabCased()
        return className
    }
}
