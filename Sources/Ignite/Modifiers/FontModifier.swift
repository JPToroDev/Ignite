//
// FontModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func fontModifier(_ font: Font, content: any InlineElement) -> any InlineElement {
    let styles = buildFontStyles(font)
    var sizeClass: String?

    if let responsiveSize = font.responsiveSize {
        sizeClass = CSSManager.shared.registerFont(responsiveSize)
    }

    return content
        .style(styles)
        .class(sizeClass)
}

@MainActor private func fontModifier(_ font: Font, content: any HTML) -> any HTML {
    let styles = buildFontStyles(font)
    var sizeClass: String?
    if let responsiveSize = font.responsiveSize {
        sizeClass = CSSManager.shared.registerFont(responsiveSize)
    }

    return if let content = content.as(Text.self) {
        content
            .style(styles)
            .class(sizeClass)
    } else {
        Section(content.class("font-inherit"))
            .style(styles)
            .class(sizeClass)
    }
}

@MainActor private func buildFontStyles(_ font: Font) -> [InlineStyle] {
    var styles = [InlineStyle]()

    if let weight = font.weight {
        styles.append(.init(.fontWeight, value: weight.description))
    }

    if let name = font.name, !name.isEmpty {
        styles.append(.init(.fontFamily, value: "'\(name)'"))
    }

    if let style = font.style, let sizeVariable = style.sizeVariable {
        styles.append(.init(.fontSize, value: sizeVariable))
    }

    if let size = font.size {
        styles.append(.init(.fontSize, value: size.stringValue))
    }

    return styles
}

public extension HTML {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> some HTML {
        if let name = font.name, !name.isEmpty {
            CSSManager.shared.registerFontFamily(font)
        }
        return AnyHTML(fontModifier(font, content: self))
    }

    /// Adjusts the font of this text using responsive sizing.
    /// - Parameter font: The responsive font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font.Responsive) -> some HTML {
        let baseFont = font.font
        if let name = baseFont.name, !name.isEmpty {
            CSSManager.shared.registerFontFamily(baseFont)
        }
        return AnyHTML(fontModifier(baseFont, content: self))
    }
}

public extension InlineElement {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> some InlineElement {
        if let name = font.name, !name.isEmpty {
            CSSManager.shared.registerFontFamily(font)
        }
        return AnyInlineElement(fontModifier(font, content: self))
    }

    /// Adjusts the font of this text using responsive sizing.
    /// - Parameter font: The responsive font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font.Responsive) -> some InlineElement {
        let baseFont = font.font
        if let name = baseFont.name, !name.isEmpty {
            CSSManager.shared.registerFontFamily(baseFont)
        }
        return AnyInlineElement(fontModifier(baseFont, content: self))
    }
}

public extension StyledHTML {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> Self {
        if let name = font.name, !name.isEmpty {
            CSSManager.shared.registerFontFamily(font)
        }

        var styles = [InlineStyle]()

        if let weight = font.weight {
            styles.append(.init(.fontWeight, value: weight.description))
        }

        if let style = font.style {
            styles.append(.init(.fontStyle, value: style.rawValue))
        }

        if let name = font.name, !name.isEmpty {
            styles.append(.init(.fontFamily, value: "'\(name)'"))
        }

        if let size = font.size {
            styles.append(.init(.fontSize, value: size.stringValue))
        }

        return self.style(styles)
    }
}
