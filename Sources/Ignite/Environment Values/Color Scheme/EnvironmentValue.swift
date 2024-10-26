//
// EnvironmentValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

// EnvironmentValue.swift

// EnvironmentValue.swift

import Foundation

public protocol EnvironmentValue: RawRepresentable, Equatable where RawValue == String {
    static var key: String { get }
    static var query: String { get }
}

public enum ColorScheme: String, EnvironmentValue {
    case light, dark
    public static let key: String = "colorScheme"
    public static let query: String = "prefers-color-scheme"
}

public struct EnvironmentCondition {
    let key: String
    let value: String
    
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}

// Overload '==' to return EnvironmentCondition
public func ==<T: EnvironmentValue>(lhs: T, rhs: T) -> EnvironmentCondition {
    EnvironmentCondition(key: T.key, value: rhs.rawValue)
}

// Provide a method to compare for equality when Bool is needed
public extension EnvironmentValue where Self.RawValue: Equatable {
    func equals(_ other: Self) -> Bool {
        return self.rawValue == other.rawValue
    }
}

// Overload '===' to return Bool
public func ===<T: EnvironmentValue>(lhs: T, rhs: T) -> Bool where T.RawValue: Equatable {
    return lhs.rawValue == rhs.rawValue
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
