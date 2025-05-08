//
//  ArticleRenderer.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for `ArticleRenderer`.
@Suite("ArticleRenderer Tests")
@MainActor
struct ArticleRendererTests {
    @Test(
        "Markdown headings from string",
        arguments: ["# Heading 1", "## Heading 2", "### Heading 3", "# Heading with a #hashtag"]
    )
    func convertMarkdownHeadingsToHTML(markdown: String) async throws {
        var parser = MarkdownToHTML()
        parser.markup = markdown
        parser.removeTitleFromBody = false
        let body = parser.parse().body

        let expectedTag = "h\(numberOfHashtags(in: markdown))"
        let expectedContent = String(markdown.drop(while: { $0 == "#" }))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        #expect(body == "<\(expectedTag)>\(expectedContent)</\(expectedTag)>")
    }

    @Test("Markdown heading remove title from body")
    func removeMarkdownTitleFromBody() async throws {
        var parser = MarkdownToHTML()
        parser.markup = "# Test Heading\n\nTest content"
        parser.removeTitleFromBody = true
        let body = parser.parse().body
        #expect(body == "<p>Test content</p>")
    }

    @Test("Markdown paragraphs from string", arguments: ["Paragraph one\n\nParagraph two"])
    func convertMarkdownParagraphsToHTML(markdown: String) async throws {
        var parser = MarkdownToHTML()
        parser.markup = markdown
        parser.removeTitleFromBody = false
        let body = parser.parse().body

        let paragraphs = markdown.split(separator: "\n\n")
        let expectedHTML = paragraphs
            .map {
                "<p>\($0)</p>"
            }
            .joined()
        #expect(body == "\(expectedHTML)")
    }

    @Test("Markdown block quotes from string", arguments: ["> Here is an example quote"])
    func convertMarkdownBlockQuotesToHTML(markdown: String) async throws {
        var parser = MarkdownToHTML()
        parser.markup = markdown
        parser.removeTitleFromBody = false
        let body = parser.parse().body

        let content = markdown.replacingOccurrences(of: "> ", with: "")
        #expect(body == "<blockquote><p>\(content)</p></blockquote>")
    }

    @Test("Markdown image from string", arguments: ["Here is an ![Image description](path/to/example/image.jpg)"])
    func convertMarkdownImageToHTML(markdown: String) async throws {
        var parser = MarkdownToHTML()
        parser.markup = markdown
        parser.removeTitleFromBody = false
        let body = parser.parse().body

        let expectedImageHTML = "<img src=\"path/to/example/image.jpg\" alt=\"Image description\" class=\"img-fluid\">"
        #expect(body == "<p>Here is an \(expectedImageHTML)</p>")
    }

    @Test("Markdown code block from string", arguments: ["Here is some `var code = \"great\"`"])
    func convertMarkdownCodeBlockToHTML(markdown: String) async throws {
        var parser = MarkdownToHTML()
        parser.markup = markdown
        parser.removeTitleFromBody = false
        let body = parser.parse().body

        #expect(body == "<p>Here is some <code>var code = \"great\"</code></p>")
    }

    @Test("Markdown emphasis from string", arguments: ["Here is some *emphasized* text"])
    func convertMarkdownEmphasisToHTML(markdown: String) async throws {
        var parser = MarkdownToHTML()
        parser.markup = markdown
        parser.removeTitleFromBody = false
        let body = parser.parse().body

        #expect(body == "<p>Here is some <em>emphasized</em> text</p>")
    }

    @Test("Markdown link from string", arguments: ["Here is a [link](https://example.com)"])
    func convertMarkdownLinkToHTML(markdown: String) async throws {
        var parser = MarkdownToHTML()
        parser.markup = markdown
        parser.removeTitleFromBody = false
        let body = parser.parse().body

        #expect(body == "<p>Here is a <a href=\"https://example.com\">link</a></p>")
    }

    @Test("Markdown list from string")
    func convertMarkdownListToHTML() async throws {
        var parser = MarkdownToHTML()
        parser.markup = """
        - Item 1
        - Item 2
        """
        parser.removeTitleFromBody = false
        let body = parser.parse().body

        #expect(body == "<ul><li>Item 1</li><li>Item 2</li></ul>")
    }

    @Test("Markdown ordered list from string")
    func convertMarkdownOrderedListToHTML() async throws {
        var parser = MarkdownToHTML()
        parser.markup = """
        1. Item 1
        2. Item 2
        """
        parser.removeTitleFromBody = false
        let body = parser.parse().body

        #expect(body == "<ol><li>Item 1</li><li>Item 2</li></ol>")
    }

    @Test("Markdown strikethrough from string")
    func convertMarkdownStrikethroughToHTML() async throws {
        var parser = MarkdownToHTML()
        parser.markup = "Example text with some of it ~crossed out~"
        parser.removeTitleFromBody = false
        let body = parser.parse().body

        #expect(body == "<p>Example text with some of it <s>crossed out</s></p>")
    }

    @Test("Markdown strong from string")
    func convertMarkdownStrongToHTML() async throws {
        var parser = MarkdownToHTML()
        parser.markup = "Example of **strong** text"
        parser.removeTitleFromBody = false
        let body = parser.parse().body

        #expect(body == "<p>Example of <strong>strong</strong> text</p>")
    }

    @Test("Markdown table from string")
    func convertMarkdownTableToHTML() async throws {
        var parser = MarkdownToHTML()
        parser.markup = """
        | Title 1 | Title 2 |
        | --- | --- |
        | Content 1 | Content 2|
        """
        parser.removeTitleFromBody = false
        let body = parser.parse().body

        #expect(body == """
        <table class="table">\
        <thead>\
        <th scope="col">Title 1</th>\
        <th scope="col">Title 2</th>\
        </thead>\
        <tbody>\
        <tr>\
        <td>Content 1</td>\
        <td>Content 2</td>\
        </tr>\
        </tbody>\
        </table>
        """)
    }

    @Test("Markdown thematic break from string")
    func convertMarkdownThematicBreakToHTML() async throws {
        var parser = MarkdownToHTML()
        parser.markup = """
        Text above

        ---

        Text below
        """
        parser.removeTitleFromBody = false
        let body = parser.parse().body

        #expect(body == "<p>Text above</p><hr /><p>Text below</p>")
    }
}

extension ArticleRendererTests {
    private func numberOfHashtags(in markdown: String) -> Int {
        return markdown.prefix(while: { $0 == "#" }).count
    }
}
