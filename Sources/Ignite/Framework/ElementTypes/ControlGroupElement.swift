//
// FormItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Describes elements that can be placed into forms.
/// - Warning: Do not conform to this type directly.
@MainActor
public protocol ControlGroupElement {
    /// The core attributes for this control element.
    var attributes: CoreAttributes { get set }
    
    /// Renders the control element as markup.
    /// - Returns: The rendered markup representation.
    func render() -> Markup
}

extension ControlGroupElement {
    /// Converts this element and its children into an HTML string with attributes.
    /// - Returns: A string containing the HTML markup
    func markupString() -> String {
        render().string
    }

    /// Creates a collection containing this element as a subview.
    /// - Returns: An control-group subviews collection wrapping this element.
    func subviews() -> ControlGroupSubviewsCollection {
        ControlGroupSubviewsCollection(self)
    }
}

struct FormItem: HTML {
    var body: Never { fatalError() }

    var attributes = CoreAttributes()

    private var configuration = FormConfiguration()

    var content: any HTML

    init(_ content: any HTML) {
        self.content = content
    }

    func formConfiguration(_ configuration: FormConfiguration) -> Self {
        var copy = self
        copy.configuration = configuration
        return copy
    }

    func render() -> Markup {
        var content = content
        content.attributes.merge(attributes)
        if let content = content as? any FormElementRepresentable {
            return content.renderAsFormElement(configuration)
        }
        return content.render()
    }
}
