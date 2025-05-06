//
// LayoutPriority.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Sets the layout priority of an HTML element.
    /// - Parameter priority: An integer value representing the layout priority.
    /// - Returns: A modified copy of the element with the specified layout priority applied.
    func layoutPriority(_ priority: Int) -> some HTML {
        self.style(.flex, priority.formatted())
    }
}

public extension InlineElement {
    /// Sets the layout priority of an inline element.
    /// - Parameter priority: An integer value representing the layout priority.
    /// - Returns: A modified copy of the element with the specified layout priority applied.
    func layoutPriority(_ priority: Int) -> some InlineElement {
        self.style(.flex, priority.formatted())
    }
}
