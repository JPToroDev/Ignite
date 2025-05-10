//
// ArticleSyntaxHighlighterConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Configuration for syntax highlighting behavior in articles.
public struct ArticleSyntaxHighlighterConfiguration: Equatable, Sendable {
    /// Whether inline code should use syntax highlighting.
    var highlightInlineCode: Bool

    /// The default syntax highlighter for code snippets.
    var defaultHighlighter: String?

    /// Creates a new syntax highlighter configuration.
    /// - Parameters:
    ///   - highlightInlineCode: Whether to apply syntax highlighting to inline code.
    ///   - defaultHighlighter: The default language to use for syntax highlighting when none is specified.
    /// - Returns: A new configuration with the specified settings.
    public init(highlightInlineCode: Bool, defaultHighlighter: String?) {
        self.highlightInlineCode = highlightInlineCode
        self.defaultHighlighter = defaultHighlighter
    }

    /// A configuration that matches the configuration used by `Site`.
    public static let automatic: Self = .init(highlightInlineCode: false, defaultHighlighter: nil)
}
