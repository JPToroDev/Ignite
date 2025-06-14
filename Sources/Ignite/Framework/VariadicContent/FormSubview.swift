//
// FormSubview.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An opaque value representing the child of another view.
struct FormSubview: HTML {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    private var content: any FormElement

    /// The underlying HTML content, with attributes.
    var wrapped: any FormElement {
        var wrapped = content
        wrapped.attributes.merge(attributes)
        return wrapped
    }

    var configuration = FormConfiguration()

    /// Creates a new `Child` instance that wraps the given HTML content.
    /// If the content is already an AnyHTML instance, it will be unwrapped to prevent nesting.
    /// - Parameter content: The HTML content to wrap
    init(_ wrapped: any FormElement) {
        var content = wrapped
        // Make Child the single source of truth for attributes
        // and modified attributes directly to keep type unchanged
        attributes.merge(content.attributes)
        content.attributes.clear()
        self.content = content
    }

    func formConfiguration(_ configuration: FormConfiguration) -> Self {
        var copy = self
        copy.configuration = configuration
        return copy
    }

    func configuredAsControlGroupItem(_ labelStyle: ControlLabelStyle) -> ControlGroupItem {
        if let item = wrapped as? any ControlGroupItemConfigurable {
            return item.configuredAsControlGroupItem(labelStyle)
        }
        return ControlGroupItem(self)
    }

    func configuredAsLastItem() -> Self {
        if var item = wrapped as? DropdownItemConfigurable {
            item.configuration = .lastControlGroupItem
            return FormSubview(item as! FormElement)
        }
        return self
    }

    nonisolated func markup() -> Markup {
        MainActor.assumeIsolated {
            var content = wrapped
            content.attributes.merge(attributes)

            return if let element = content as? FormElementRepresentable {
                element.renderAsFormElement(configuration)
            } else {
                content.markup()
            }
        }
    }
}

extension FormSubview: Equatable {
    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.markup() == rhs.markup()
    }
}
