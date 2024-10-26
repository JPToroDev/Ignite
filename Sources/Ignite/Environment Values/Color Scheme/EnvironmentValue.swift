//
// EnvironmentValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

// EnvironmentValue.swift

// EnvironmentValue.swift

import Foundation

public enum ColorScheme: String {
    case light
    case dark
}

public struct EnvironmentCondition {
    let key: String
    let value: String
    let query: String
    
    init(key: String, value: String, query: String = "prefers-color-scheme") {
        self.key = key
        self.value = value
        self.query = query
    }
}

// Changed operator to hide when the schemes DON'T match
public func ==(lhs: ColorScheme, rhs: ColorScheme) -> EnvironmentCondition {
    EnvironmentCondition(key: "colorscheme", value: rhs == .light ? "dark" : "light")
}

extension PublishingContext {
    public var colorScheme: ColorScheme { .light }
    
//    func environmentStyles() -> String {
//        let styles = [
//            generateColorSchemeStyles()
//        ].joined(separator: "\n\n")
//        
//        return """
//        <style>
//        \(styles)
//        </style>
//        """
//    }
    
    private func generateColorSchemeStyles() -> String {
        """
        @media (prefers-color-scheme: light) {
            .env-colorscheme-light-hidden { display: none !important; }
        }
        
        @media (prefers-color-scheme: dark) {
            .env-colorscheme-dark-hidden { display: none !important; }
        }
        """
    }
}

extension HTML {
    public func render(context: PublishingContext) -> String {
        var output = "<!doctype html>"
        output += "<html lang=\"\(context.site.language.rawValue)\" data-bs-theme=\"light\"\(attributes.description)>"
        output += head?.render(context: context) ?? ""
        output += context.environmentStyles()
        output += body?.render(context: context) ?? ""
        output += "</html>"
        return output
    }
}

public extension PageElement {
    
    func hidden(_ condition: EnvironmentCondition) -> Self {
        var copy = self
        copy.attributes.classes.append("env-\(condition.key)-\(condition.value)-hidden")
        return copy
    }
}

//public enum ColorScheme: String {
//    case light
//    case dark
//}

//public enum ColorScheme: String {
//    case light
//    case dark
//}

public struct EnvironmentRelativeGroup: BlockElement {
    public var columnWidth: ColumnWidth = .automatic
    
    private let content: [BlockElement]
    public var attributes: CoreAttributes = CoreAttributes()
    
    public init(_ type: ColorScheme.Type, equals value: ColorScheme, @BlockElementBuilder content: () -> [BlockElement]) {
        self.content = content()
        // Hide element when in the opposite color scheme
        self.attributes.classes.append("env-colorscheme-\(value == .light ? "dark" : "light")-hidden")
    }
    
    public func render(context: PublishingContext) -> String {
        let group = Group(items: content, context: context)
        return group.attributes(attributes).render(context: context)
    }
}

extension PublishingContext {
    func environmentStyles() -> String {
        """
        <style>
        @media (prefers-color-scheme: light) {
            .env-colorscheme-light-hidden { display: none !important; }
        }
        
        @media (prefers-color-scheme: dark) {
            .env-colorscheme-dark-hidden { display: none !important; }
        }
        </style>
        """
    }
}
