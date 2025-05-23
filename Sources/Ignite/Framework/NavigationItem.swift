//
// NavigationItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct NavigationItem: HTML, NavigationElement {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The underlying HTML content
    var wrapped: any HTML

    init(_ content: any HTML) {
        self.wrapped = content
    }

    init<T: InlineElement>(_ content: T) {
        self.wrapped = InlineHTML(content)
    }

    /// How a `NavigationBar` displays this item at different breakpoints.
    var navigationBarVisibility = NavigationBarVisibility.automatic

    /// Returns a new instance with the specified visibility.
    func navigationBarVisibility(_ visibility: NavigationBarVisibility) -> Self {
        var copy = self
        copy.navigationBarVisibility = visibility
        return copy
    }

    func markup() -> Markup {
        var wrapped = wrapped
        wrapped.attributes.merge(attributes)
        return wrapped.markup()
    }
}
