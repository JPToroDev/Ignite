//
// ToggleSidebar.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Toggles the sidebar of a `SplitView`
public struct ToggleSidebar: Action, Sendable {
    /// The unique identifier of the sidebar's parent `SplitView`.
    let id: String

    /// Creates a new `ToggleSidebar` action.
    /// - Parameter id: The unique identifier of the parent `SplitView`.
    public init(id: String) {
        self.id = id
    }

    /// Renders this action into JavaScript.
    /// - Returns: The JavaScript for this action.
    public func compile() -> String { "" }
}

public extension Action where Self == ToggleSidebar {
    /// Creates a new `ToggleSidebar` action
    /// - Parameter id: The unique identifier of the parent `SplitView`.
    /// - Returns: A `ToggleSidebar` action configured with the specified `SplitView` ID
    static func toggleSidebar(_ id: String) -> Self {
        ToggleSidebar(id: id)
    }
}
