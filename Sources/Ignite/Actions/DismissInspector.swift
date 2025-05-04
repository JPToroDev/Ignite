//
// DismissInspector.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Dismiss an inspector panel with the content of the page element identified by ID
public struct DismissInspector: Action {
    /// The unique identifier of the element of the inspector we're trying to dismiss.
    var id: String

    /// Creates a new `DismissInspector` action from a specific page element ID.
    /// - Parameter id: The unique identifier of the element of the inspector we're trying to dismiss.
    public init(id: String) {
        self.id = id
    }

    /// Renders this action into JavaScript.
    /// - Returns: The JavaScript for this action.
    public func compile() -> String {
        """
        const inspector = document.getElementById('\(id)');
        const inspectorInstance = bootstrap.Offcanvas.getInstance(inspector);
        if (inspectorInstance) { inspectorInstance.hide(); }
        """
    }
}

public extension Action where Self == DismissInspector {
    /// Creates a new `DismissInspector`
    /// - Parameter id: The unique identifier of the inspector to dismiss
    /// - Returns: A `DismissInspector` action configured with the specified inspector ID
    static func dismissInspector(_ id: String) -> Self {
        DismissInspector(id: id)
    }
}
