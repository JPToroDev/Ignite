//
// FormSubview.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An opaque value representing the child of another view.
struct ControlGroupSubview: HTML {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    private var content: any ControlGroupElement

    /// The underlying HTML content, with attributes.
    var wrapped: any ControlGroupElement {
        var wrapped = content
        wrapped.attributes.merge(attributes)
        return wrapped
    }

    private var configuration = FormConfiguration()

    /// Creates a new `Child` instance that wraps the given HTML content.
    /// If the content is already an AnyHTML instance, it will be unwrapped to prevent nesting.
    /// - Parameter content: The HTML content to wrap
    init(_ wrapped: any ControlGroupElement) {
        self.content = wrapped
    }

    nonisolated func render() -> Markup {
        MainActor.assumeIsolated {
            return if let element = wrapped as? FormElementRepresentable {
                element.renderAsFormElement(configuration)
            } else {
                wrapped.render()
            }
        }
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
            return ControlGroupSubview(item as! ControlGroupElement)
        }
        return self
    }
}

extension ControlGroupSubview: Equatable {
    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.render() == rhs.render()
    }
}
