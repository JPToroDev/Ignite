//
// NavigationItemGroup.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container for organizing related navigation items .
@MainActor
public struct NavigationItemGroup<Content: NavigationElement>: NavigationElement {
    public var body: some HTML { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How a `NavigationBar` displays this item at different breakpoints.
    public var navigationBarVisibility: NavigationBarVisibility = .automatic

    var children: Children

    /// Creates a navigation-item group.
    /// - Parameter items: A closure returning an array of form items to include in the group.
    public init(@NavigationElementBuilder content: () -> Content) {
        self.children = Children(content())
    }

    public func markup() -> Markup {
        children.map { $0.configuredAsNavigationItem().markup() }.joined()
    }
}

extension NavigationItemGroup: VariadicElement {}
