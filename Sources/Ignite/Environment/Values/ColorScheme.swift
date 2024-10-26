//
// ColorScheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public enum ColorScheme: String, Environment.MediaQueryValue {
    case light, dark
    public var key: String { "colorscheme" }
}
