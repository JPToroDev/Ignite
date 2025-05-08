//
// SystemImage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Icons provided by the framework.
@MainActor
public struct SystemImage {
    /// The class of the Bootstrap icon.
    private var value: String

    public var rawValue: String {
        value
    }

    /// Creates a new instance from the specified raw value.
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init?(rawValue: String) {
        self.value = rawValue
    }

    private init(value: String) {
        self.value = value
    }

    /// A hamburger menu icon (three horizontal lines).
    public static var navigationMenu: Self = .init(value: "navbar-toggler-icon")

    /// A three-dots menu icon.
    public static var ellipsis: Self = .init(value: "bi-three-dots")
}
