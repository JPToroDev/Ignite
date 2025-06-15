//
// Never.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension Never: HTML, InlineElement {
    public var body: Never {
        return fatalError("Never has no body")
    }
    public var attributes: CoreAttributes {
        get { CoreAttributes() }
        set {}
    }
    public var isPrimitive: Bool { true }
    public func render() -> Markup {
        fatalError("Never cannot produce markup")
    }
}

extension Never: @retroactive CustomStringConvertible {}
