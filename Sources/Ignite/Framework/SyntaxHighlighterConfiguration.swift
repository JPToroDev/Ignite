//
// SyntaxHighlighterConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Configuration for syntax highlighting behavior in code blocks.
@MainActor
public struct SyntaxHighlighterConfiguration {
    /// Whether long lines should wrap to the next line.
    var wrapLines: Bool

    /// Whether inline code should use syntax highlighting.
    var highlightInlineCode: Bool

    /// Whether and how to display line numbers.
    var lineNumberVisibility: Visibility

    /// The language that should automatically be applied to code blocks and inline code.
    var defaultLanguage: HighlighterLanguage?

    /// Default configuration that automatically detects languages.
    public static let automatic: Self = .init()

    /// Creates a new syntax highlighter configuration.
    /// - Parameters:
    ///   - defaultLanguage: The language automatically applied to code blocks and inline code.
    ///   - lineNumberVisibility: Whether to display line numbers.
    ///   - wrapLines: Whether long lines should wrap to the next line.
    ///   - highlightInlineCode: Whether inline code should use syntax highlighting.
    public init(
        defaultLanguage: HighlighterLanguage? = nil,
        lineNumberVisibility: Visibility = .hidden,
        wrapLines: Bool = false,
        highlightInlineCode: Bool = false
    ) {
        self.defaultLanguage = defaultLanguage
        self.highlightInlineCode = highlightInlineCode
        self.lineNumberVisibility = lineNumberVisibility
        self.wrapLines = wrapLines
    }
}
