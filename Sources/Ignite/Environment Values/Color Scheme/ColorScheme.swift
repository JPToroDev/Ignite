//
// ColorScheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public enum ColorScheme {
    case light, dark
    
    // Helper to convert from JS boolean
    static func fromDarkMode(_ isDark: Bool) -> ColorScheme {
        isDark ? .dark : .light
    }
}
