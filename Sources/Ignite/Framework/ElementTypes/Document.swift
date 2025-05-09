//
// Document.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines an HTML document.
/// - Warning: Do not conform to this protocol directly.
public protocol Document: MarkupElement {
    /// The main content section of the document.
    var body: Body { get }

    /// The metadata section of the document.
    var head: Head { get }
}

extension Document {
    /// Returns the appropriate theme attributes on the document
    /// root element based on the site's theme configuration.
    var themeAttribute: Attribute? {
        let site = publishingContext.site

        if site.isAutoThemeEnabled {
            return .init(name: "ig-auto-theme-enabled", value: "true")
        }

        guard !site.hasMultipleThemes else {
            return nil
        }

        return if site.lightTheme != nil {
            .init(name: "bs-theme", value: "light")
        } else if site.darkTheme != nil {
            .init(name: "bs-theme", value: "dark")
        } else {
            nil
        }
    }
}
