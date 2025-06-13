//
// GridItemSize.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public enum GridItemSize: Sendable {
    case automatic
    case adaptive(minimum: LengthUnit)

    public static func adaptive(minimum: Int) -> Self {
        .adaptive(minimum: .px(minimum))
    }

    var inlineStyles: [InlineStyle] {
        switch self {
        case .automatic: []
        case .adaptive(let minimum): [.init("--grid-min-width", value: minimum.stringValue)]
        }
    }
}
