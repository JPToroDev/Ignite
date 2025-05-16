//
// Grid.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Creates a 12-column grid. If the items in your grid have widths that add up to
/// 12 then they will fit in a single row, otherwise they will be placed on multiple
/// rows. This element automatically adapts to constrained horizontal dimensions
/// by placing your content across multiple rows automatically.
///
/// **Note**: A 12-column grid is the default, but you can adjust that downwards
/// by using the `columns()` modifier.
public struct Grid: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How many columns this should be divided into
    var columnCount: Int?

    /// The amount of space between elements.
    private var spacingAmount: SpacingType = .semantic(.none)

    /// The alignment of the items within the grid.
    private var alignment: Alignment = .center

    /// The items to display in this grid.
    private var items: VariadicHTML

    /// Creates a new `Grid` object using a block element builder
    /// that returns an array of items to use in this grid.
    /// - Parameters:
    ///   - alignment: The alignment of items in the grid. Defaults to `.center`.
    ///   - spacing: The number of pixels between each element.
    ///   - items: The items to use in this grid.
    public init(
        alignment: Alignment = .center,
        spacing: Int,
        @HTMLBuilder items: () -> some HTML
    ) {
        self.items = VariadicHTML(items)
        self.alignment = alignment
        self.spacingAmount = .exact(spacing)
    }

    /// Creates a new `Grid` object using a block element builder
    /// that returns an array of items to use in this grid.
    /// - Parameters:
    ///   - alignment: The alignment of items in the grid. Defaults to `.center`.
    ///   - spacing: The predefined size between each element. Defaults to `.none`.
    ///   - items: The items to use in this grid.
    public init(
        alignment: Alignment = .center,
        spacing: SpacingAmount = .medium,
        @HTMLBuilder items: () -> some HTML
    ) {
        self.items = VariadicHTML(items)
        self.alignment = alignment
        self.spacingAmount = .semantic(spacing)
    }

    /// Creates a new grid from a collection of items, along with a function that converts
    /// a single object from the collection into one grid column.
    /// - Parameters:
    ///   - items: A sequence of items you want to convert into columns.
    ///   - alignment: The alignment of items in the grid. Defaults to `.center`.
    ///   - spacing: The number of pixels between each element.
    ///   - content: A function that accepts a single value from the sequence, and
    ///     returns some HTML representing that value in the grid.
    public init<T>(
        _ items: any Sequence<T>,
        alignment: Alignment = .center,
        spacing: Int,
        @HTMLBuilder content: (T) -> some HTML
    ) {
        self.items = VariadicHTML(items.map(content))
        self.alignment = alignment
        self.spacingAmount = .exact(spacing)
    }

    /// Creates a new grid from a collection of items, along with a function that converts
    /// a single object from the collection into one grid column.
    /// - Parameters:
    ///   - items: A sequence of items you want to convert into columns.
    ///   - alignment: The alignment of items in the grid. Defaults to `.center`.
    ///   - spacing: The predefined size between each element. Defaults to `.none`
    ///   - content: A function that accepts a single value from the sequence, and
    ///     returns some HTML representing that value in the grid.
    public init<T>(
        _ items: any Sequence<T>,
        alignment: Alignment = .center,
        spacing: SpacingAmount = .medium,
        @HTMLBuilder content: (T) -> some HTML
    ) {
        self.items = VariadicHTML(items.map(content))
        self.alignment = alignment
        self.spacingAmount = .semantic(spacing)
    }

    /// Adjusts the number of columns that can be fitted into this grid.
    /// - Parameter columns: The number of columns to use
    /// - Returns: A new `Grid` instance with the updated column count.
    public func columns(_ columns: Int) -> Self {
        var copy = self
        copy.columnCount = columns
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        var gridAttributes = attributes.appending(classes: ["row"])
        gridAttributes.append(classes: alignment.horizontal.containerAlignmentClass)

        // If a column count is set, we want to use that for all
        // page sizes that are medium and above. Below that we
        // should drop down to width 1 to avoid squeezing things
        // into oblivion.
        if let columnCount {
            gridAttributes.append(classes: "row-cols-1", "row-cols-md-\(columnCount)")
        }

        switch spacingAmount {
        case .exact(let pixels) where pixels == 0:
            gridAttributes.append(classes: "g-0")
        case .exact(let pixels):
            gridAttributes.append(styles: .init(.rowGap, value: "\(pixels)px"))
        case .semantic(let amount):
            gridAttributes.append(classes: "g-\(amount.rawValue)")
        default: break
        }

        return Section {
            ForEach(items) { item in
                if let variadic = item as? any HTMLCollection {
                    wrapChildrenInColumn(variadic)
                } else {
                    column(item)
                }
            }
        }
        .attributes(gridAttributes)
        .markup()
    }

    /// Removes a column class, if it exists, from the item and reassigns it to a wrapper.
    private func column(_ item: any HTML) -> some HTML {
        var item = item

        var columnWidth = item.columnWidth
        if case .count(let columnCount) = columnWidth {
            item.attributes.remove(classes: columnWidth.className)
            let scaledWidth = scaledWidth(columnCount)
            columnWidth = scaledWidth
        }

        // We need to ensure the Section wrapping a Grid item
        // retains its child's position
        var positionClass: String?
        let positionClasses = Position.allCases.map(\.rawValue)
        if let position = item.attributes.classes.first(where: { positionClasses.contains($0) }) {
            item.attributes.remove(classes: position)
            positionClass = position
        }

        return Section(item)
            .class(columnWidth.className)
            .class(positionClass)
            .class(alignment.vertical.itemAlignmentClass)
    }

    /// Renders a group of HTML elements with consistent styling and attributes.
    /// - Parameter variadic: The passthrough entity containing the HTML elements to render.
    /// - Returns: A view containing the styled group elements.
    func wrapChildrenInColumn(_ variadic: any HTMLCollection) -> some HTML {
        let collection = variadic.children.map(\.self)
        return ForEach(collection) { item in
            column(item)
        }
    }

    /// Calculates the appropriate Bootstrap column class name for a block element.
    /// - Parameter count: The number of columns.
    /// - Returns: The scaled `ColumnWidth`.
    private func scaledWidth(_ count: Int) -> ColumnWidth {
        let scaledCount = if let columnCount {
            count * 12 / columnCount
        } else {
            count
        }
        return ColumnWidth.count(scaledCount)
    }
}
