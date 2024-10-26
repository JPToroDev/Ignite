//
// ColorInversion.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public enum ColorInversion: String, Environment.MediaQueryValue {
    case inverted, normal
    public var key: String { "colors" }
}
