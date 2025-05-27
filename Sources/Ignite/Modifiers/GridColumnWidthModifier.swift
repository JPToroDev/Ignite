//
// GridColumnWidthModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func gridColumnWidthModifier(
    _ width: ColumnWidth,
    content: some InlineElement
) -> some HTML {
    InlineHTML(content).class(width.className)
}

public extension HTML {
    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A new element with the adjusted column width.
    func gridCellColumns(_ width: Int) -> some HTML {
        self.style(.gridColumn, "span \(width)")
    }
}

public extension InlineElement {
    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A new element with the adjusted column width.
    func gridCellColumns(_ width: Int) -> some HTML {
        InlineHTML(self.style(.gridColumn, "span \(width)"))
    }
}

//public extension FormItem where Self: HTML {
//    /// Adjusts the number of columns assigned to this element.
//    /// - Parameter width: The new number of columns to use.
//    /// - Returns: A new element with the adjusted column width.
//    func width(_ width: Int) -> some FormItem {
//        var copy = self
//        copy.attributes.append(classes: ColumnWidth.count(width).className)
//        return copy
//    }
//}
//
//public extension FormItem where Self: InlineElement {
//    /// Adjusts the number of columns assigned to this element.
//    /// - Parameter width: The new number of columns to use.
//    /// - Returns: A new element with the adjusted column width.
//    func width(_ width: Int) -> some FormItem {
//        var copy = self
//        copy.attributes.append(classes: ColumnWidth.count(width).className)
//        return copy
//    }
//}
