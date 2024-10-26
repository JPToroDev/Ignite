//
// EnvironmentValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

// EnvironmentValue.swift

import Foundation

// Protocol for environment values that can be used in conditions
public protocol EnvironmentValueType: RawRepresentable where RawValue == String {
    static var environmentKey: String { get }
    static func generateRule(for value: Self) -> EnvironmentRule
}

// Structure to represent a CSS rule for an environment value
public struct EnvironmentRule {
    let selector: String
    let value: String
    
    public init(selector: String, value: String) {
        self.selector = selector
        self.value = value
    }
}

// Environment condition that will be used for generating CSS classes
public struct EnvironmentCondition {
    let key: String
    let value: String
}

// Generic operator for environment value types
public func ==<T: EnvironmentValueType>(lhs: T, rhs: T) -> EnvironmentCondition {
    EnvironmentCondition(key: T.environmentKey, value: rhs.rawValue)
}

// ColorScheme implementation
public enum ColorScheme: String, CaseIterable, EnvironmentValueType {
    case light
    case dark
    
    public static var environmentKey: String { "colorscheme" }
    
    public static func generateRule(for value: ColorScheme) -> EnvironmentRule {
        EnvironmentRule(
            selector: "@media (prefers-color-scheme: \(value.rawValue))",
            value: value.rawValue
        )
    }
}

// Example of ReduceMotion implementation
public enum ReduceMotion: String, CaseIterable, EnvironmentValueType {
    case reduce
    case noPreference
    
    public static var environmentKey: String { "reducemotion" }
    
    public static func generateRule(for value: ReduceMotion) -> EnvironmentRule {
        EnvironmentRule(
            selector: "@media (prefers-reduced-motion: \(value == .reduce ? "reduce" : "no-preference"))",
            value: value.rawValue
        )
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

// Extension for PublishingContext to support environment values
public extension PublishingContext {
    var colorScheme: ColorScheme { .light }
    var reduceMotion: ReduceMotion { .noPreference }
    
    func environmentStyles() -> String {
        let styles = [
            generateEnvironmentStyle(for: ColorScheme.self),
            generateEnvironmentStyle(for: ReduceMotion.self)
        ].joined(separator: "\n\n")
        
        return """
        <style>
        \(styles)
        </style>
        """
    }
    
    private func generateEnvironmentStyle<T: EnvironmentValueType & CaseIterable>(for type: T.Type) -> String {
        T.allCases.map { value in
            let rule = T.generateRule(for: value)
            return """
            \(rule.selector) {
                .env-\(T.environmentKey)-\(rule.value)-hidden { display: none !important; }
            }
            """
        }.joined(separator: "\n\n")
    }
}

// Extension for PageElement to support hiding based on environment conditions
public extension PageElement {
    func hidden(_ condition: EnvironmentCondition) -> Self {
        var copy = self
        copy.attributes.classes.append("env-\(condition.key)-\(condition.value)-hidden")
        return copy
    }
}
