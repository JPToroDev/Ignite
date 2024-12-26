//
// ResponsiveAlignment.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Defines horizontal alignment behavior across different screen sizes.
///
/// Use `ResponsiveAlignment` to specify how content should align horizontally at different breakpoints:
/// ```swift
/// Text("Hello")
///     .horizontalAlignment(
///         .small(.center),    // Center on mobile
///         .medium(.leading)   // Left-align on tablets and up
///     )
/// ```
public enum ResponsiveAlignment {
    /// Applies alignment at the small breakpoint (≤576px)
    case small(HorizontalAlignment)

    /// Applies alignment at the medium breakpoint (≥768px)
    case medium(HorizontalAlignment)

    /// Applies alignment at the large breakpoint (≥992px)
    case large(HorizontalAlignment)

    /// Applies alignment at the extra large breakpoint (≥1200px)
    case extraLarge(HorizontalAlignment)

    /// Applies alignment at the extra extra large breakpoint (≥1400px)
    case extraExtraLarge(HorizontalAlignment)

    /// Applies alignment without a breakpoint
    case base(HorizontalAlignment)

    /// The corresponding Bootstrap class for this responsive alignment
    var bootstrapClass: String {
        let (breakpoint, alignment): (String?, HorizontalAlignment) = switch self {
        case .small(let align): (nil, align)
        case .medium(let align): ("md", align)
        case .large(let align): ("lg", align)
        case .extraLarge(let align): ("xl", align)
        case .extraExtraLarge(let align): ("xxl", align)
        case .base(let align): (nil, align)
        }

        let alignmentClass = alignment.rawValue.dropFirst(5)

        if let breakpoint {
            return "text-\(breakpoint)-\(alignmentClass)"
        }
        return "text-\(alignmentClass)"
    }
}
