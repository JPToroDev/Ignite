//
// Style.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines a style that can be resolved based on environment conditions.
/// Styles are used to create reusable visual treatments that can adapt based on media queries
/// and theme settings.
///
/// Example:
/// ```swift
/// struct MyCustomStyle: Style {
///     func style(content: Content, environment: EnvironmentConditions) -> Content {
///         if environment.colorScheme == .dark {
///             content.foregroundStyle(.red)
///         } else {
///             content.foregroundStyle(.blue)
///         }
///     }
/// }
/// ```
@MainActor
public protocol Style: Hashable {
    /// Resolves the style for the given HTML content and environment conditions
    /// - Parameters:
    ///   - element: An HTML element to apply styles to
    ///   - environmentConditions: The current media query condition to resolve against
    /// - Returns: A modified HTML element with the appropriate styles applied
    typealias Content = ElementProxy
    func style(content: Content, environment: EnvironmentConditions) -> Content
}

extension Style {
    /// The name of the CSS class this `Style` generates,
    /// derived from the type name.
    var className: String {
        let typeName = String(describing: type(of: self))
        let className = typeName.kebabCased()
        return className
    }
}
