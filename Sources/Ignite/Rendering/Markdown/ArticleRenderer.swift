//
// ArticleRenderer.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A protocol defining the basic information we need to get good
/// article parsing. This is implemented by the default
/// `MarkdownToHTML` parser included with Ignite, but users
/// can override that default in their `Site` conformance to
/// get a custom parser if needed.
public protocol ArticleRenderer {
    /// Whether to remove the article's title from its body. This only applies
    /// to the first heading.
    var removeTitleFromBody: Bool { get set }

    /// The default syntax highlighter for code snippets.
    var defaultHighlighter: String? { get set }

    /// Whether inline code should use syntax highlighting.
    var highlightInlineCode: Bool { get set }

    /// Returns the processed title, description, and body of the raw markup.
    mutating func parse(_ markup: String) throws -> ParsedArticle
}
