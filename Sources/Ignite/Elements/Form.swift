//
// Form.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct FormConfiguration: Sendable {
    var columnCount: Int = 12
    var spacing: SemanticSpacing = .medium
    var labelStyle: ControlLabelStyle = .floating
    var controlSize: ControlSize = .medium
}

/// A form container for collecting user input
public struct Form<Content: FormElement>: HTML, NavigationElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How a `NavigationBar` displays this item at different breakpoints.
    public var navigationBarVisibility: NavigationBarVisibility = .automatic

    /// The form elements to be rendered.
    private var content: FormElement

    /// The configuration of the form.
    private var configuration = FormConfiguration()

    /// Sets the style for form labels
    /// - Parameter style: How labels should be displayed
    /// - Returns: A modified form with the specified label style
    public func labelStyle(_ style: ControlLabelStyle) -> some HTML {
        var copy = self
        copy.configuration.labelStyle = style
        return copy
    }

    /// Sets the size of form controls and labels
    /// - Parameter size: The desired size
    /// - Returns: A modified form with the specified control size
    public func controlSize(_ size: ControlSize) -> Self {
        var copy = self
        copy.configuration.controlSize = size
        return copy
    }

    /// Adjusts the number of columns that can be fitted into this section.
    /// - Parameter columns: The number of columns to use
    /// - Returns: A new `Section` instance with the updated column count.
    public func columns(_ columns: Int) -> some HTML {
        var copy = self
        copy.configuration.columnCount = columns
        return copy
    }

    /// Creates a new form with the specified spacing and content.
    /// - Parameters:
    ///   - spacing: The amount of horizontal space between elements. Defaults to `.medium`.
    ///   - content: A closure that returns the form's elements.
    public init(
        spacing: SemanticSpacing = .medium,
        @FormElementBuilder content: () -> Content
    ) {
        self.content = content()
        self.configuration.spacing = spacing
        attributes.id = UUID().uuidString.truncatedHash
    }

    public func markup() -> Markup {
        let items = content.subviews().map { item in
            if configuration.labelStyle == .leading {
                var item = item
                item.attributes.append(classes: "mb-\(configuration.spacing.rawValue)")
                return item
            } else {
                return item
            }
        }

        return Tag("form") {
            ForEach(items) { item in
                item
                    .formConfiguration(configuration)
                    .class(getColumnClass(for: item))
            }
        }
        .attributes(attributes)
        .class(configuration.labelStyle == .leading ? nil : "row g-\(configuration.spacing.rawValue)")
        .markup()
    }

    /// Calculates the appropriate Bootstrap column class for an HTML element.
    /// - Parameters:
    ///   - item: The HTML element to calculate the column class for.
    ///   - totalColumns: The total number of columns in the form's grid.
    /// - Returns: A string containing the appropriate Bootstrap column class.
    private func getColumnClass(for item: any HTML) -> String {
        if let widthClass = item.attributes.classes.first(where: { $0.starts(with: "col-md-") }),
           let width = Int(widthClass.dropFirst("col-md-".count)) {
            let bootstrapColumns = 12 * width / configuration.columnCount
            return "col-md-\(bootstrapColumns)"
        } else if item.attributes.classes.contains("col") {
            return "col"
        } else {
            return "col-auto"
        }
    }
}

@MainActor
protocol FormElementRepresentable: FormElement {
    func renderAsFormElement(_ configuration: FormConfiguration) -> Markup
}

@MainActor protocol ControlGroupItemConfigurable {
    func configuredAsControlGroupItem(_ labelStyle: ControlLabelStyle) -> ControlGroupItem
}
