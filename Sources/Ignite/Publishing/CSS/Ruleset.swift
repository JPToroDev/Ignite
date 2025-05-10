//
// Ruleset.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structured representation of a CSS ruleset including selectors and styles
struct Ruleset: CSS {
    /// CSS selectors for this ruleset
    var selector: Selector?

    /// CSS declarations
    var styles: [InlineStyle]

    init(_ selector: Selector?, styles: [InlineStyle] = []) {
        self.selector = selector
        self.styles = styles
    }

    init(_ selector: Selector?, @StyleBuilder styles: () -> [InlineStyle]) {
        self.selector = selector
        self.styles = styles()
    }

    func render() -> String {
        guard !styles.isEmpty else { return "" }
        if let selector {
            let styleBlock = styles
                .map { "    " + $0.description + ";" }
                .joined(separator: "\n")

            return """
            \(selector.value) {
            \(styleBlock)
            }
            """
        } else {
            return styles.map { $0.description + ";" }.joined(separator: "\n")
        }
    }
}
