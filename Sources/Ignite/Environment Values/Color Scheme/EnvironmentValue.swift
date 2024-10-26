//
// EnvironmentValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

// EnvironmentValue.swift

// EnvironmentValue.swift

import Foundation

public struct Environment {
    
    public protocol MediaQueryValue: Equatable, RawRepresentable where RawValue == String {
        var key: String { get }
        var cssClass: String { get }
    }
}

extension Environment.MediaQueryValue {
   public var cssClass: String {
       "\(key)-\(rawValue)"
   }
}

public enum ColorScheme: String, Environment.MediaQueryValue {
    case light, dark
    public var key: String { "colorscheme" }
}

public enum DisplayMode: String, Environment.MediaQueryValue {
    case fullscreen, standalone, minimalUI, browser
    public var key: String { "displaymode" }
}

public enum Orientation: String, Environment.MediaQueryValue {
    case landscape, portrait
    public var key: String { "orientation" }
}

public enum Motion: String, Environment.MediaQueryValue {
    case reduced, normal
    public var key: String { "motion" }
}

public enum Transparency: String, Environment.MediaQueryValue {
    case reduced, normal
    public var key: String { "transparency" }
}

public enum Contrast: String, Environment.MediaQueryValue {
    case more, less, normal
    public var key: String { "contrast" }
}

public enum ColorInversion: String, Environment.MediaQueryValue {
    case inverted, normal
    public var key: String { "colors" }
}

public struct EnvironmentRelativeGroup<T: Environment.MediaQueryValue>: BlockElement {
    public var columnWidth: ColumnWidth = .automatic
    private let content: [BlockElement]
    private let expectedValue: T
    public var attributes: CoreAttributes = CoreAttributes()
    
    public init(_ type: T.Type, equals value: T, @BlockElementBuilder content: () -> [BlockElement]) {
        self.content = content()
        self.expectedValue = value
    }
    
    public func render(context: PublishingContext) -> String {
        var output = "<div class=\"\(expectedValue.cssClass)\">"
        output += content.map { $0.render(context: context) }.joined()
        output += "</div>"
        return output
    }
}

extension HTML {
    public func render(context: PublishingContext) -> String {
        var output = "<!doctype html>"
        output += "<html lang=\"\(context.site.language.rawValue)\"\(attributes.description)>"
        output += head?.render(context: context) ?? ""
        output += body?.render(context: context) ?? ""
        output += "</html>"
        return output
    }
}
