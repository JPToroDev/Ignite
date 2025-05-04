//
// SwitchTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An action that switches between themes by updating data-bs-theme
/// and data-theme-state attributes on the document root.
public struct SwitchTheme: Action {
    let themeID: String

    /// Creates a new `SwitchTheme` action
    /// - Parameter theme: The theme to switch to
    public init(_ theme: any Theme) {
        self.themeID = theme.cssID
    }

    /// Compiles the action into JavaScript
    /// - Returns: JavaScript code to execute the theme switch
    public func compile() -> String {
        "igniteSwitchTheme('\(themeID)');"
    }
}

public extension Action where Self == SwitchTheme {
    /// Creates a new `SwitchTheme` action
    /// - Parameter theme: The theme to switch to
    /// - Returns: A `SwitchTheme` action configured with the specified theme
    static func switchTheme(_ theme: any Theme) -> Self {
        SwitchTheme(theme)
    }
}
