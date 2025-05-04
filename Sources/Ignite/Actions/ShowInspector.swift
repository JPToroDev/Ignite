//
// ShowInspector.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Shows an inspector panel with the content of the page element identified by ID
public struct ShowInspector: Action, Sendable {
    /// The unique identifier of the element to display in the inspector.
    let id: String

    /// Creates a new `ShowInspector` action from a specific page element ID.
    /// - Parameter id: The unique identifier of the element we're trying to show as an inspector.
    public init(id: String) {
        self.id = id
    }

    /// Renders this action into JavaScript.
    /// - Returns: The JavaScript for this action.
    public func compile() -> String {
        """
        const inspector = new bootstrap.Offcanvas(document.getElementById('\(id)'));
        inspector.show();
        """
    }
}

public extension Action where Self == ShowInspector {
    /// Creates a new `ShowInspector` action
    /// - Parameter id: The unique identifier of the inspector to show
    /// - Returns: A `ShowInspector` action configured with the specified element ID
    static func showInspector(_ id: String) -> Self {
        ShowInspector(id: id)
    }
}
