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
    case light, dark
    public var keyPath: KeyPath<PublishingContext, ColorScheme> { \PublishingContext.colorScheme }
    public var key : String { "colorscheme" }
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
//    
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
//    
//    private func generateColorSchemeStyles() -> String {
//        """
//        @media (prefers-color-scheme: light) {
//            .env-colorscheme-light-hidden { display: none !important; }
//        }
//        
//        @media (prefers-color-scheme: dark) {
//            .env-colorscheme-dark-hidden { display: none !important; }
//        }
//        """
    }
//}

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

public protocol EnvironmentValue: Equatable, RawRepresentable where RawValue == String {
    associatedtype Value: EnvironmentValue
    var key: String { get }
    var keyPath: KeyPath<PublishingContext, Value> { get }
}

public struct EnvironmentRelativeGroup<T: EnvironmentValue>: BlockElement {
    public var columnWidth: ColumnWidth = .automatic
    private let content: [BlockElement]
    private let expectedValue: T
    public var attributes: CoreAttributes = CoreAttributes()
    
    public init(_ type: T.Type, equals value: T, @BlockElementBuilder content: () -> [BlockElement]) {
        self.content = content()
        self.expectedValue = value
    }
    
    public func render(context: PublishingContext) -> String {
        var output = "<div"
        // Simply show when we match this value
        output += " class=\"env-\(expectedValue.key)-\(expectedValue.rawValue)-show\""
        output += ">"
        output += content.map { $0.render(context: context) }.joined()
        output += "</div>"
        return output
    }
}

extension PublishingContext {
    func environmentStyles() -> String {
        """
        <style>
        /* Content visibility */
        [class*='env-colorscheme'] { display: none; }
        
        /* Light mode */
        @media (prefers-color-scheme: light) {
            .env-colorscheme-light-show { display: block; }
            html { 
                --bs-theme: light;
            }
        }
        
        /* Dark mode */
        @media (prefers-color-scheme: dark) {
            .env-colorscheme-dark-show { display: block; }
            html {
                --bs-theme: dark;
            }
        }
        
        /* Apply theme */
        html {
            data-bs-theme: var(--bs-theme);
        }
        </style>
        """
    }
}

extension HTML {
    public func render(context: PublishingContext) -> String {
        var output = "<!doctype html>"
        // Let the CSS handle the theme value
        output += "<html lang=\"\(context.site.language.rawValue)\"\(attributes.description)>"
        output += head?.render(context: context) ?? ""
        output += context.environmentStyles()
        output += body?.render(context: context) ?? ""
        output += "</html>"
        return output
    }
}
