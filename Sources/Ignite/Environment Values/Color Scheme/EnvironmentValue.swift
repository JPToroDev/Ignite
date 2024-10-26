//
// EnvironmentValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public enum ColorScheme: String {
    case light
    case dark
}

public struct EnvironmentCondition {
    let key: String
    let value: String
}

public func ==(lhs: ColorScheme, rhs: ColorScheme) -> EnvironmentCondition {
    EnvironmentCondition(key: "colorscheme", value: rhs.rawValue)
}

extension PublishingContext {
    public var colorScheme: ColorScheme { .light }
    
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
