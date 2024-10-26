//
// Hidden.swift
// IgniteSamples
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public extension PageElement {
    /// Optionally hides the view in the view hierarchy.
    /// - Parameter isHidden: Whether to hide this element or not.
    /// - Returns: A copy of the current element, optionally hidden.
    func hidden(_ isHidden: Bool = true) -> Self {
        self
            .class(isHidden ? "d-none" : nil)
    }
    
    func hidden(_ condition: EnvironmentCondition) -> Self {
        var copy = self
        copy.attributes.classes.append("env-\(condition.key)-\(condition.value)-hidden")
        return copy
    }
}
