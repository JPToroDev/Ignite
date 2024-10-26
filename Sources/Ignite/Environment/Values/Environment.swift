//
// Environment.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public struct Environment {
    
    public protocol MediaQueryValue: Equatable, RawRepresentable where RawValue == String {
        var key: String { get }
        var cssClass: String { get }
    }
}

extension Environment.MediaQueryValue {
   public var cssClass: String {
       "\(key)-\(rawValue)"
   }
}
