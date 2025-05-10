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

    /// Controls how the renderer handles syntax highlighting.
    /// Use `nil` to disabled syntax highlighting in an article.
    var syntaxHighlighterConfiguration: ArticleSyntaxHighlighterConfiguration? { get }

    /// Returns the processed title, description, and body of the raw markup.
    mutating func parse(_ markup: String) throws -> ParsedArticle
}

public extension ArticleRenderer {
    /// Defaults to the same configuration used by `Site`.
    var syntaxHighlighterConfiguration: ArticleSyntaxHighlighterConfiguration? {
        get { .automatic }
        set {} // swiftlint:disable:this unused_setter_value
    }
}

