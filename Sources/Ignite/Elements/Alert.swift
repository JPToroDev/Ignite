//
// Alert.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Shows a clearly delineated box on your page, providing important information
/// or warnings to users.
public struct Alert<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    var content: Content

    var role = Role.default

    var alertClasses: [String] {
        var outputClasses = ["alert"]
        outputClasses.append(contentsOf: attributes.classes)

        switch role {
        case .default:
            break

        default:
            outputClasses.append("alert-\(role.rawValue)")
        }

        return outputClasses
    }

    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }

    public func role(_ role: Role) -> Alert {
        var copy = self
        copy.role = role
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        Section(content)
            .class(alertClasses)
            .attributes(attributes)
            .markup()
    }
}
