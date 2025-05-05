//
// DismissInspector.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Dismiss an `Inspector`
public struct DismissInspector: Action {
    /// The unique identifier of the inspector to dismiss.
    var id: String

    /// Creates a new `DismissInspector` action.
    /// - Parameter id: The unique identifier of the inspector to dismiss.
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
    /// - Returns: A `DismissInspector` action configured with the specified `Inspector` ID
    static func dismissInspector(_ id: String) -> Self {
        DismissInspector(id: id)
    }
}
