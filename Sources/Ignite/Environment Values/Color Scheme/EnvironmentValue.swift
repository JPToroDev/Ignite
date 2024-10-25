//
// EnvironmentValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

// Protocol defining what makes an environment value
public protocol EnvironmentValue {
    associatedtype Value
    
    /// The key used to identify this value in the DOM
    var key: String { get }
    /// The name of the event fired when this value changes
    var eventName: String { get }
    /// JavaScript code to detect and update this environment value
    var detectionScript: String { get }
}
