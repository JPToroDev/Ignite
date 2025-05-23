//
// Amount.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

enum Amount<Exact, Semantic> {
    case exact(Exact)
    case semantic(Semantic)
}
