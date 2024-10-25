//
// EnvironmentValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public struct EnvironmentValue {
    let key: String
    
    init(_ key: String) {
        self.key = key
    }
}

extension EnvironmentValue {
    static let colorScheme = EnvironmentValue("colorScheme")
}
