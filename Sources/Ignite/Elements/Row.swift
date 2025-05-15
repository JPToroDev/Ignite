//
// Row.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// One row inside a `Table`.
public struct Row: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The columns to display inside this row.
    private var columns: VariadicHTML

    /// Create a new `Row` using a page element builder that returns the
    /// array of columns to use in this row.
    /// - Parameter columns: The columns to use in this row.
    public init(@HTMLBuilder columns: () -> some BodyElement) {
        self.columns = VariadicHTML(columns)
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        let output = columns.map { column in
            if column is Column {
                column.markup()
            } else {
                Markup("<td>\(column.markupString())</td>")
            }
        }.joined()
        .string

        return Markup("<tr\(attributes)>\(output)</tr>")
    }
}
