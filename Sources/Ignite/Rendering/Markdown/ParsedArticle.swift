//
// ArticleComponents.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public struct ParsedArticle {
    /// The title of this document.
    public var title: String

    /// The description of this document, which is the first paragraph.
    public var description: String

    /// The body text of this file, which includes its title by default.
    public var body: String

    public init(title: String, description: String, body: String) {
        self.title = title
        self.description = description
        self.body = body
    }
}
