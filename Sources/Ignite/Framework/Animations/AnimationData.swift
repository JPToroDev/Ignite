//
// StandardAnimation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A basic animation type that transitions a single CSS property from one value to another.
public struct AnimationData {
    /// The starting value for the animated property
    var initial: String
    
    /// The ending value for the animated property
    var final: String
    
    /// The CSS property to animate (e.g., "opacity", "transform", "background-color")
    var property: AnimatableProperty
    
    /// The duration of the animation in seconds.
    var duration: Double = 0.35
    
    /// The timing function that controls the animation's acceleration curve.
    var timing: AnimationCurve = .automatic

    /// The delay before the animation begins, in seconds.
    var delay: Double = 0
    
    /// The number of times the animation should repeat.
    /// - Note: Set to `nil` for no repetition, or `.infinity` for endless repetition.
    var repeatCount: Double = 1
    
    /// Whether the animation should reverse direction on alternate cycles
    var autoreverses: Bool = false
    
    /// Creates a new value animation for a specific CSS property.
    /// - Parameters:
    ///   - property: The CSS property to animate
    ///   - from: The starting value for the property
    ///   - to: The ending value for the property
    public init(_ property: AnimatableProperty, from: String, to: String) {
        self.property = property
        self.initial = from
        self.final = to
    }
    
    public init(_ property: AnimatableProperty, value: String) {
        self.property = property
        self.final = value
        // Set appropriate default 'from' value based on property
        switch property {
        case .backgroundColor:
            self.initial = "inherit"
        case .color:
            self.initial = "inherit"
        case .transform:
            self.initial = "none"
        case .opacity:
            self.initial = "1"
        default:
            self.initial = "initial"
        }
    }
}
