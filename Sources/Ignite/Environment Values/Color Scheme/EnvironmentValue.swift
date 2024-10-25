//
// EnvironmentValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public protocol EnvironmentValue {
    associatedtype Value
    var key: String { get }
    var eventName: String { get }
    var detectionScript: String { get }
}
