//
// DisplayMode.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public enum DisplayMode: String, Environment.MediaQueryValue {
    case fullscreen, standalone, minimalUI, browser
    public var key: String { "displaymode" }
}
