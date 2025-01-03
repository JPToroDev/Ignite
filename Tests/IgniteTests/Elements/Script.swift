//
// Script.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import XCTest

@testable import Ignite

/// Tests for the `Script` element.
@MainActor final class ScriptTests: ElementTest {
    func test_code() {
        let element = Script(code: "javascript code")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<script>javascript code</script>")
    }

    func test_file() {
        let element = Script(file: "/code.js")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<script src=\"/code.js\"></script>")
    }

    func test_attributes() {
        let element = Script(file: "/code.js")
            .data("key", "value")
            .customAttribute(name: "custom", value: "part")
        let output = element.render(context: publishingContext)
        let normalizedOutput = normalizeHTML(output)

        XCTAssertEqual(
            normalizedOutput,
            "<script custom=\"part\" key=\"value\" src=\"/code.js\"></script>")
    }
}
