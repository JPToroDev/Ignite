//
// SyntaxHighlighterConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Configuration for syntax highlighting behavior in code blocks.
@MainActor
public struct SyntaxHighlighterConfiguration: Sendable {
    /// Controls the visibility and formatting of line numbers.
    public enum LineNumberVisibility: Sendable {
        /// Shows line numbers with the specified starting number and wrapping behavior.
        case visible(firstLine: Int, linesWrap: Bool)
        /// Hides line numbers.
        case hidden

        /// Shows line numbers starting at 1 without text wrapping.
        public static let visible: Self = .visible(firstLine: 1, linesWrap: false)
    }


    /// Whether and how to display line numbers.
    var lineNumberVisibility: LineNumberVisibility

    /// The number to start counting from when showing line numbers.
    var firstLineNumber: Int

    /// Whether long lines should wrap to the next line.
    var wrapLines: Bool

    /// Whether inline code should use syntax highlighting.
    var highlightInlineCode: Bool

    /// The language that should automatically be applied to code blocks and inline code.
    var defaultLanguage: HighlighterLanguage? {
        didSet {
            if let defaultLanguage {
                PublishingContext.shared.syntaxHighlighters.insert(defaultLanguage)
            }
        }
    }

    /// Default configuration that automatically detects languages.
    public static let automatic: Self = .init()

    /// Creates a new syntax highlighter configuration.
    /// - Parameters:
    ///   - defaultLanguage: The language automatically applied to code blocks and inline code.
    ///   - highlightInlineCode: Whether inline code should use syntax highlighting.
    ///   - lineNumberVisibility: Whether and how to display line numbers.
    ///   - firstLineNumber: The number to start counting from when showing line numbers.
    ///   - wrapLines: Whether long lines should wrap to the next line.
    public init(
        defaultLanguage: HighlighterLanguage? = nil,
        highlightInlineCode: Bool = false,
        lineNumberVisibility: LineNumberVisibility = .hidden,
        firstLineNumber: Int = 1,
        wrapLines: Bool = false,
    ) {
        self.defaultLanguage = defaultLanguage
        self.highlightInlineCode = highlightInlineCode
        self.lineNumberVisibility = lineNumberVisibility
        self.firstLineNumber = firstLineNumber
        self.wrapLines = wrapLines
    }
}
