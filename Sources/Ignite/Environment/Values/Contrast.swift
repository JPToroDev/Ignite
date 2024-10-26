//
// Contrast.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public enum Contrast: String, Environment.MediaQueryValue {
    case more, less, normal
    public var key: String { "contrast" }
}
