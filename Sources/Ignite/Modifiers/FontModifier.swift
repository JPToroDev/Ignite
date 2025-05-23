//
// FontModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func fontModifier(_ font: Font, content: any InlineElement) -> any InlineElement {
    content.attributes(getAttributes(for: font, includeStyle: true))
}

@MainActor private func getAttributes(for font: Font, includeStyle: Bool) -> CoreAttributes {
    var attributes = CoreAttributes()

    if let weight = font.weight {
        attributes.append(styles: .init(.fontWeight, value: weight.description))
    }

    if let name = font.name, !name.isEmpty {
        attributes.append(styles: .init(.fontFamily, value: "'\(name)'"))
    }

    if let responsiveSize = font.responsiveSize {
        let className = CSSManager.shared.registerFont(responsiveSize)
        attributes.append(classes: className)
    } else if let size = font.size {
        attributes.append(styles: .init(.fontSize, value: size.stringValue))
    }

    if includeStyle, let style = font.style, let sizeClass = style.sizeClass {
        attributes.append(classes: sizeClass)
    }

    return attributes
}

@MainActor private func registerFontIfNeeded(_ font: Font) {
    guard let name = font.name, !name.isEmpty else { return }
    CSSManager.shared.registerFontFamily(font)
}

public extension HTML {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> some HTML {
        registerFontIfNeeded(font)
        return FontModifiedHTML(self, font: font)
    }

    /// Adjusts the font of this text using responsive sizing.
    /// - Parameter font: The responsive font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font.Responsive) -> some HTML {
        registerFontIfNeeded(font.font)
        return FontModifiedHTML(self, font: font.font)
    }
}

public extension InlineElement {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> some InlineElement {
        registerFontIfNeeded(font)
        return AnyInlineElement(fontModifier(font, content: self))
    }

    /// Adjusts the font of this text using responsive sizing.
    /// - Parameter font: The responsive font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font.Responsive) -> some InlineElement {
        registerFontIfNeeded(font.font)
        return AnyInlineElement(fontModifier(font.font, content: self))
    }
}

public extension ElementProxy {
    /// Adjusts the font of this text.
    /// - Parameter font: The font configuration to apply.
    /// - Returns: A new instance with the updated font.
    func font(_ font: Font) -> Self {
        registerFontIfNeeded(font)
        return style(buildFontStyles(font))
    }

    private func buildFontStyles(_ font: Font) -> [InlineStyle] {
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

        return styles
    }
}

private struct FontModifiedHTML<Content: HTML>: HTML {
    var attributes = CoreAttributes()

    var body: Never { fatalError() }

    var content: Content
    var font: Font

    init(_ content: Content, font: Font) {
        self.content = content
        self.font = font
    }

    func markup() -> Markup {
        if var text = content as? any TextProvider & HTML {
            if let style = font.style { text.fontStyle = style }
            return text.attributes(getAttributes(for: font, includeStyle: false))
                .markup()
        }

        return Section(content.class("font-inherit"))
            .attributes(getAttributes(for: font, includeStyle: true))
            .markup()
    }
}
