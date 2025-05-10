//
//  Material.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Material` type.
@Suite("Material Tests")
struct MaterialTests {
    @Test("Correct class name without color scheme.", arguments: zip(
        [Material.ultraThinMaterial,
         Material.thinMaterial,
         Material.regularMaterial,
         Material.thickMaterial,
         Material.ultraThickMaterial],
        ["ultra-thin",
         "thin",
         "regular",
         "thick",
         "ultra-thick"]))
    func className(material: Material, type: String) throws {
        #expect(material.className == "material-\(type)")
    }
}
