//
// GridLayout.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct GridLayout: VariadicRoot {
    /// The amount of space between elements.
    var spacingAmount: SpacingAmount

    /// The alignment of the items within the grid.
    var alignment: Alignment

    var gridItemSizing: GridItemSize = .automatic

    var columnCount: Int?

    func body(children: Children) -> some HTML {
        let (flattenedGridItems, columnCount) = processGridItems(children)
        let attributes = createGridAttributes(columnCount: columnCount)

        return Section {
            ForEach(flattenedGridItems) { child in
                child
                    .class("grid-item")
            }
        }
        .attributes(attributes)
        .class("adaptive-grid")
        .style(spacingAmount.inlineStyle)
        .style(alignment.gridAlignmentRules)
    }

    private func processGridItems(_ children: Children) -> ([GridItem], String) {
        let gridItems = children.map { $0.resolvedToGridItems() }
        let maxColumnCount = columnCount ?? gridItems.map(\.count).max() ?? 1

        func padRow(_ row: [GridItem]) -> [GridItem] {
            guard !(row.count == 1 && row.first?.isFullWidth == true) else { return row }
            let emptyCellsNeeded = maxColumnCount - row.count
            return emptyCellsNeeded > 0 ? row + Array(repeating: .emptyCell, count: emptyCellsNeeded) : row
        }

        return (gridItems.map(padRow).flatMap(\.self), String(maxColumnCount))
    }

    private func createGridAttributes(columnCount: String) -> CoreAttributes {
        var attributes = CoreAttributes()
        attributes.append(styles: gridItemSizing.inlineStyles)
        attributes.append(styles: .init("--grid-columns", value: columnCount), .init("--grid-gap", value: "20px"))
        return attributes
    }
}
