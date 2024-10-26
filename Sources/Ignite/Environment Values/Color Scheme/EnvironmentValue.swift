//
// EnvironmentValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

// EnvironmentValue.swift

// EnvironmentValue.swift

import Foundation

public enum ColorScheme: String, EnvironmentValue {
    public func getValue(from context: PublishingContext) -> String? {
        return context.colorScheme.rawValue
    }
    
    case light, dark
    public var key : String { "colorScheme" }
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
    
    func environmentStyles() -> String {
        let styles = [
            generateColorSchemeStyles()
        ].joined(separator: "\n\n")
        
        return """
        <style>
        \(styles)
        </style>
        """
    }
    
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

//public enum EnvironmentValue {
//    case colorScheme
//}

//extension PublishingContext {
//    func environmentStyles() -> String {
//        """
//        <style>
//        @media (prefers-color-scheme: light) {
//            .env-colorscheme-light-hidden { display: none !important; }
//        }
//        
//        @media (prefers-color-scheme: dark) {
//            .env-colorscheme-dark-hidden { display: none !important; }
//        }
//        </style>
//        """
//    }
//}

// Represents available environment values
public protocol EnvironmentValue: RawRepresentable, Equatable where RawValue == String {
    // Helper to get the key string for CSS classes
    var key: String { get }
    // Get value from context based on key
    func getValue(from context: PublishingContext) -> String?
}

public struct EnvironmentRelativeGroup: BlockElement {
    public var columnWidth: ColumnWidth = .automatic
    private let content: [BlockElement]
    private let value: any EnvironmentValue
    private let expectedValue: String
    public var attributes: CoreAttributes = CoreAttributes()
    
    public init(_ environment: any EnvironmentValue, equals value: String, @BlockElementBuilder content: () -> [BlockElement]) {
        self.content = content()
        self.value = environment
        self.expectedValue = value
    }
    
    public func render(context: PublishingContext) -> String {
        var copy = self
        if let currentValue = value.getValue(from: context),
           currentValue.description != expectedValue.description {
            copy.attributes.classes.append("env-\(value.key)-\(expectedValue.description)-hidden")
        }
        
        let group = Group(items: content, context: context)
        return group.attributes(copy.attributes).render(context: context)
    }
}
