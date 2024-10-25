//
// EnvironmentValues.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public enum EnvironmentValues {
    case colorScheme
    
    var key: String {
        switch self {
        case .colorScheme: return "colorScheme"
        }
    }
    
    var eventName: String {
        switch self {
        case .colorScheme: return "colorSchemeChange"
        }
    }
}
