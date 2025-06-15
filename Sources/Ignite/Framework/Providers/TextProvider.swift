//
// TextProvider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type whose root view has a configurable font style.
@MainActor
protocol TextProvider {
    /// The font to use for this text.
    var fontStyle: FontStyle { get set }
}
