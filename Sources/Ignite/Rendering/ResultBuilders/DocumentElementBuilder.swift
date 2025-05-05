//
// DocumentBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A result builder that enables declarative syntax for constructing layouts.
@MainActor
@resultBuilder
public struct DocumentBuilder {
    public static func buildBlock(_ head: Head, _ body: Body) -> some Document {
        PlainDocument(head: head, body: body)
    }

    public static func buildBlock(_ body: Body) -> some Document {
        PlainDocument(head: Head(), body: body)
    }

    public static func buildBlock<Content: Document>(_ component: Content) -> Content {
        component
    }
}
