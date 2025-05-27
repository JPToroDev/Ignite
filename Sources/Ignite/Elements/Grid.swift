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
public struct Grid<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The layout and content of this grid.
    var tree: VariadicTree<GridLayout, Content>

    /// Creates a new `Grid` object using a block element builder
    /// that returns an array of items to use in this grid.
    /// - Parameters:
    ///   - alignment: The alignment of items in the grid. Defaults to `.center`.
    ///   - spacing: The number of pixels between each element.
    ///   - items: The items to use in this grid.
    public init(
        columns: Int? = nil,
        alignment: Alignment = .center,
        spacing: Int,
        @HTMLBuilder content: () -> Content
    ) {
        let layout = GridLayout(spacingAmount: .exact(spacing), alignment: alignment, columnCount: columns)
        self.tree = VariadicTree(root: layout, content: content())
    }

    /// Creates a new `Grid` object using a block element builder
    /// that returns an array of items to use in this grid.
    /// - Parameters:
    ///   - alignment: The alignment of items in the grid. Defaults to `.center`.
    ///   - spacing: The predefined size between each element. Defaults to `.none`.
    ///   - items: The items to use in this grid.
    public init(
        columns: Int? = nil,
        alignment: Alignment = .center,
        spacing: SemanticSpacing = .medium,
        @HTMLBuilder content: () -> Content
    ) {
        let layout = GridLayout(spacingAmount: .semantic(spacing), alignment: alignment, columnCount: columns)
        self.tree = VariadicTree(root: layout, content: content())
    }

    /// Creates a new grid from a collection of items, along with a function that converts
    /// a single object from the collection into one grid column.
    /// - Parameters:
    ///   - items: A sequence of items you want to convert into columns.
    ///   - alignment: The alignment of items in the grid. Defaults to `.center`.
    ///   - spacing: The number of pixels between each element.
    ///   - content: A function that accepts a single value from the sequence, and
    ///     returns some HTML representing that value in the grid.
    public init<T, S: Sequence, ItemContent: HTML>(
        _ items: S,
        columns: Int? = nil,
        alignment: Alignment = .center,
        spacing: Int,
        @HTMLBuilder content: @escaping (T) -> ItemContent
    ) where S.Element == T, Content == ForEach<Array<T>, ItemContent> {
        let content = ForEach(Array(items), content: content)
        let layout = GridLayout(spacingAmount: .exact(spacing), alignment: alignment, columnCount: columns)
        self.tree = VariadicTree(root: layout, content: content)
    }

    /// Creates a new grid from a collection of items, along with a function that converts
    /// a single object from the collection into one grid column.
    /// - Parameters:
    ///   - items: A sequence of items you want to convert into columns.
    ///   - alignment: The alignment of items in the grid. Defaults to `.center`.
    ///   - spacing: The predefined size between each element. Defaults to `.none`
    ///   - content: A function that accepts a single value from the sequence, and
    ///     returns some HTML representing that value in the grid.
    public init<T, S: Sequence, ItemContent: HTML>(
        _ items: S,
        columns: Int? = nil,
        alignment: Alignment = .center,
        spacing: SemanticSpacing = .medium,
        @HTMLBuilder content: @escaping (T) -> ItemContent
    ) where S.Element == T, Content == ForEach<Array<T>, ItemContent> {
        let content = ForEach(Array(items), content: content)
        let layout = GridLayout(spacingAmount: .semantic(spacing), alignment: alignment, columnCount: columns)
        self.tree = VariadicTree(root: layout, content: content)
    }

    public func gridItemSizing(_ sizing: GridItemSize) -> Self {
        var copy = self
        copy.tree.root.gridItemSizing = sizing
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        tree.attributes(attributes).markup()
    }
}

public enum GridItemSize: Sendable {
    case automatic
    case adaptive(minimum: LengthUnit)

    public static func adaptive(minimum: Int) -> Self {
        .adaptive(minimum: .px(minimum))
    }

    var inlineStyles: [InlineStyle] {
        switch self {
        case .automatic: []
        case .adaptive(let minimum): [.init("--grid-min-width", value: minimum.stringValue)]
        }
    }
}
