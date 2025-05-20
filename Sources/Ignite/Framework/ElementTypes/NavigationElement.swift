//
// NavigationItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Describes elements that can be placed into navigation bars.
/// - Warning: Do not conform to this type directly.
@MainActor
public protocol NavigationElement {}

public extension NavigationElement where Self: HTML {
    /// Returns a new instance with the specified visibility.
    func navigationBarVisibility(_ visibility: NavigationBarVisibility) -> some NavigationElement {
        NavigationItem(self).navigationBarVisibility(visibility)
    }
}

public extension NavigationElement where Self: InlineElement {
    /// Returns a new instance with the specified visibility.
    func navigationBarVisibility(_ visibility: NavigationBarVisibility) -> some NavigationElement {
        NavigationItem(InlineHTML(self)).navigationBarVisibility(visibility)
    }
}

public extension NavigationElement where Self: HTML {
    func markup() -> Markup {
        fatalError("This protocol should not be conformed to directly.")
    }
}

public extension NavigationElement where Self: InlineElement {
    func markup() -> Markup {
        fatalError("This protocol should not be conformed to directly.")
    }
}
