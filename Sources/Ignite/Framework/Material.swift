//
// Material.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents different material effects that can be applied to views.
/// Material effects combine translucency, blur, and color to create the appearance
/// of frosted glass. The effect automatically adapts to light and dark color schemes.
public enum Material: Sendable {
    /// An ultra-thin material effect
    case ultraThinMaterial
    /// A thin material effect
    case thinMaterial
    /// A regular material effect
    case regularMaterial
    /// A thick material effect
    case thickMaterial
    /// An ultra-thick material effect
    case ultraThickMaterial

    /// Gets the CSS class name for this material
    var className: String {
        "material-\(rawValue)"
    }
}

extension Material {
    /// The raw string value for each material type
    var rawValue: String {
        switch self {
        case .ultraThinMaterial: return "ultra-thin"
        case .thinMaterial: return "thin"
        case .regularMaterial: return "regular"
        case .thickMaterial: return "thick"
        case .ultraThickMaterial: return "ultra-thick"
        }
    }
}
