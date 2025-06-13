//
// NavigationItemGroup.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container for organizing related navigation items .
struct NavigationItem<Content: NavigationElement>: NavigationElement {
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// How a `NavigationBar` displays this item at different breakpoints.
    var navigationBarVisibility: NavigationBarVisibility = .automatic

    var content: Content

    /// Creates a navigation-item group.
    /// - Parameter items: A closure returning an array of form items to include in the group.
    init(
        visibility: NavigationBarVisibility = .automatic,
        @NavigationElementBuilder content: () -> Content
    ) {
        self.navigationBarVisibility = visibility
        self.content = content()
    }
    
    /// Creates a navigation-item group.
    /// - Parameter items: A closure returning an array of form items to include in the group.
    init(
        visibility: NavigationBarVisibility = .automatic,
        content: Content
    ) {
        self.navigationBarVisibility = visibility
        self.content = content
    }

    func markup() -> Markup {
        content.markup()
    }
}

extension NavigationItem: NavigationBarVisibilityProvider {}
