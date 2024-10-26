//
// Orientation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public enum Orientation: String, Environment.MediaQueryValue {
    case landscape, portrait
    public var key: String { "orientation" }
}
