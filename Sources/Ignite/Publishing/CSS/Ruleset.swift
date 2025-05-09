//
// Ruleset.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structured representation of a CSS ruleset including selectors and styles
struct Ruleset: CSS {
    /// CSS selectors for this ruleset
    var selectors: [Selector]

    /// CSS declarations
    var styles: [InlineStyle]

    init(_ selectors: Selector..., styles: [InlineStyle] = []) {
        self.selectors = selectors
        self.styles = styles
    }

    init(_ selectors: [Selector], styles: [InlineStyle] = []) {
        self.selectors = selectors
        self.styles = styles
    }

    init(_ selectors: [Selector], @StyleBuilder styles: () -> [InlineStyle]) {
        self.selectors = selectors
        self.styles = styles()
    }

    init(_ selectors: Selector..., @StyleBuilder styles: () -> [InlineStyle]) {
        self.selectors = selectors
        self.styles = styles()
    }

    func render() -> String {
        if selectors.isEmpty {
            return styles.map { $0.description + ";" }.joined(separator: "\n")
        } else if !styles.isEmpty {
            let combinedSelector = selectors.map(\.value).joined(separator: " ")

            let styleBlock = styles
                .map { "    " + $0.description + ";" }
                .joined(separator: "\n")

            return """
            \(combinedSelector) {
            \(styleBlock)
            }
            """
        } else {
            return ""
        }
    }
}
