//
// Text.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import XCTest

@testable import Ignite

/// Tests for the `Text` element.
@MainActor final class TextTests: ElementTest {
    func test_simpleString() {
        let element = Text("Hello")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<p>Hello</p>")
    }

    func test_simpleBuilderString() {
        let element = Text {
            "Hello"
        }

        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<p>Hello</p>")
    }

    func test_complexBuilderString() {
        let element = Text {
            "Hello, "
            Emphasis("world")

            Strikethrough {
                " - "
                Strong {
                    "this "
                    Underline("is")
                    " a"
                }
                " test!"
            }
        }

        let output = element.render(context: publishingContext)

        XCTAssertEqual(
            output,
            "<p>Hello, <em>world</em><s> - <strong>this <u>is</u> a</strong> test!</s></p>"
        )
    }

    func test_customFont() {
        for font in Font.Style.allCases {
            let element = Text("Hello").font(font)
            let output = element.render(context: publishingContext)

            if font == .lead {
                // This applies a paragraph class rather than a different tag.
                XCTAssertEqual(
                    output,
                    "<div class=\"lead\"><p class=\"font-inherit\">Hello</p></div>"
                )
            } else {
                XCTAssertEqual(
                    output,
                    "<div class=\"\(font.fontSizeClass)\"><p class=\"font-inherit\">Hello</p></div>"
                )
            }
        }
    }

    func test_markdown() {
        let element = Text(
            markdown:
                "Text in *italics*, text in **bold**, and text in ***bold italics***."
        )
        let output = element.render(context: publishingContext)

        XCTAssertEqual(
            output,
            "<p>Text in <em>italics</em>, text in <strong>bold</strong>, and text in <em><strong>bold italics</strong></em>.</p>"
        )
    }

    func test_markdownSoftBreaks() {
        let element = Text(
            markdown: "This is a single\nline of markdown with a soft break")
        let output = element.render(context: publishingContext)
        // swiftlint:disable line_length
        XCTAssertEqual(
            output, "<p>This is a single line of markdown with a soft break</p>"
        )
        // swiftlint:enable line_length
    }

    func test_markdownHardBreaks() {
        let markdown =
            """
            This is line 1  
            This is line 2  
            This is line 3  
            """
        let element = Text(markdown: markdown)
        let output = element.render(context: publishingContext)
        // swiftlint:disable line_length
        XCTAssertEqual(
            output,
            "<p>This is line 1<br />This is line 2<br />This is line 3</p>")
        // swiftlint:enable line_length
    }
}
