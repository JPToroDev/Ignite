//
// NavigationItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Describes elements that can be placed into navigation bars.
/// - Warning: Do not conform to this type directly.
@MainActor
public protocol NavigationElement {
    var attributes: CoreAttributes { get set }
    func render() -> Markup
}

public extension NavigationElement where Self: HTML {
    /// Returns a new instance with the specified visibility.
    func navigationBarVisibility(_ visibility: NavigationBarVisibility) -> some NavigationElement {
        NavigationItem(visibility: visibility, content: self)
    }
}

public extension NavigationElement where Self: InlineElement {
    /// Returns a new instance with the specified visibility.
    func navigationBarVisibility(_ visibility: NavigationBarVisibility) -> some NavigationElement {
        NavigationItem(visibility: visibility, content: self)
    }
}

public extension NavigationElement where Self: HTML {
    func render() -> Markup {
        fatalError("This protocol should not be conformed to directly.")
    }
}

public extension NavigationElement where Self: InlineElement {
    func render() -> Markup {
        fatalError("This protocol should not be conformed to directly.")
    }
}
