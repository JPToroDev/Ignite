//
// Style.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//


    /// Styling options for tables.
    public enum Style {
        /// All table rows and columns look the same. The default.
        case plain

        /// Applies a "zebra stripe" effect where alternate rows have a
        /// varying color.
        case stripedRows

        /// Applies a "zebra stripe" effect where alternate columns have a
        /// varying color.
        case stripedColumns
    }