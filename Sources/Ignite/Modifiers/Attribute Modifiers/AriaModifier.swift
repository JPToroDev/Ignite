//
// AriaModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func ariaModifier(
    _ key: AriaType,
    value: String?,
    content: some HTML
) -> some HTML {
    var modified = ModifiedHTML(content)
    guard let value else { return modified }
    modified.attributes.aria.append(.init(name: key.rawValue, value: value))
    return modified
}

@MainActor private func ariaModifier(
    _ key: AriaType,
    value: String?,
    content: some InlineElement
) -> some InlineElement {
    var modified = ModifiedInlineElement(content)
    guard let value else { return modified }
    modified.attributes.aria.append(.init(name: key.rawValue, value: value))
    return modified
}

public extension HTML {
    /// Adds an ARIA attribute to the element.
    /// - Parameters:
    ///   - key: The ARIA attribute key
    ///   - value: The ARIA attribute value
    /// - Returns: The modified `HTML` element
    func aria(_ key: AriaType, _ value: String) -> some HTML {
        ariaModifier(key, value: value, content: self)
    }

    /// Adds an ARIA attribute to the element.
    /// - Parameters:
    ///   - key: The ARIA attribute key
    ///   - value: The ARIA attribute value
    /// - Returns: The modified `HTML` element
    func aria(_ key: AriaType, _ value: String?) -> some HTML {
        ariaModifier(key, value: value, content: self)
    }
}

public extension InlineElement {
    /// Adds an ARIA attribute to the element.
    /// - Parameters:
    ///   - key: The ARIA attribute key
    ///   - value: The ARIA attribute value
    /// - Returns: The modified `HTML` element
    func aria(_ key: AriaType, _ value: String) -> some InlineElement {
        ariaModifier(key, value: value, content: self)
    }

    /// Adds an ARIA attribute to the element.
    /// - Parameters:
    ///   - key: The ARIA attribute key
    ///   - value: The ARIA attribute value
    /// - Returns: The modified `InlineElement`
    func aria(_ key: AriaType, _ value: String?) -> some InlineElement {
        ariaModifier(key, value: value, content: self)
    }
}
