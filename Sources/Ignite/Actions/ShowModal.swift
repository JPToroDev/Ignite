//
// ShowModal.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Shows a modal dialog with the content of the page element identified by ID
public struct ShowModal: Action, Sendable {
    /// The unique identifier of the element to display in the modal dialog.
    let id: String

    /// Creates a new ShowModal action from a specific page element ID.
    /// - Parameters:
    ///   - id: The unique identifier of the element we're trying to show as a modal.
    public init(id: String) {
        self.id = id
    }

    /// Renders this action into JavaScript.
    /// - Returns: The JavaScript for this action.
    public func compile() -> String {
        """
        const modal = new bootstrap.Modal(document.getElementById('\(id)'));
        modal.show();
        """
    }
}
