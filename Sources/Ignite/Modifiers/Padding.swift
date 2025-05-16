//
// Padding.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private enum PaddingType {
    case exact(LengthUnit), semantic(SpacingAmount)
}

@MainActor private func paddingModifier(
    _ padding: PaddingType,
    edges: Edge = .all,
    content: some HTML
) -> some HTML {
    var modified = ModifiedHTML(content)

    switch padding {
    case .exact(let unit):
        let styles = Edge.edgeAdjustedStyles(prefix: "padding", edges, unit.stringValue)
        modified.attributes.append(styles: styles)
    case .semantic(let amount):
        let classes = Edge.edgeAdjustedClasses(prefix: "p", edges, amount.rawValue)
        modified.attributes.append(classes: classes)
    }

    return modified
}

@MainActor private func paddingModifier(
    _ padding: PaddingType,
    edges: Edge = .all,
    content: some InlineElement
) -> some InlineElement {
    var modified = ModifiedInlineElement(content)

    switch padding {
    case .exact(let unit):
        let styles = Edge.edgeAdjustedStyles(prefix: "padding", edges, unit.stringValue)
        modified.attributes.append(styles: styles)
    case .semantic(let amount):
        let classes = Edge.edgeAdjustedClasses(prefix: "p", edges, amount.rawValue)
        modified.attributes.append(classes: classes)
    }

    return modified
}

public extension HTML {
    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: Int = 20) -> some HTML {
        paddingModifier(.exact(.px(length)), content: self)
    }

    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: LengthUnit) -> some HTML {
        paddingModifier(.exact(length), content: self)
    }

    /// Applies padding on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ amount: SpacingAmount) -> some HTML {
        paddingModifier(.semantic(amount), content: self)
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: Int = 20) -> some HTML {
        paddingModifier(.exact(.px(length)), edges: edges, content: self)
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: LengthUnit) -> some HTML {
        paddingModifier(.exact(length), edges: edges, content: self)
    }

    /// Applies padding on selected sides of this element using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ amount: SpacingAmount) -> some HTML {
        paddingModifier(.semantic(amount), edges: edges, content: self)
    }
}

public extension InlineElement {
    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: Int = 20) -> some InlineElement {
        paddingModifier(.exact(.px(length)), content: self)
    }

    /// Applies padding on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ length: LengthUnit) -> some InlineElement {
        paddingModifier(.exact(length), content: self)
    }

    /// Applies padding on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ amount: SpacingAmount) -> some InlineElement {
        paddingModifier(.semantic(amount), content: self)
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: Int = 20) -> some InlineElement {
        paddingModifier(.exact(.px(length)), edges: edges, content: self)
    }

    /// Applies padding on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: LengthUnit) -> some InlineElement {
        paddingModifier(.exact(length), edges: edges, content: self)
    }

    /// Applies padding on selected sides of this element using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - amount: The amount of padding to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ amount: SpacingAmount) -> some InlineElement {
        paddingModifier(.semantic(amount), edges: edges, content: self)
    }
}

public extension ElementProxy {
    /// Applies padding on selected sides of this element.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: Int) -> Self {
        let styles = Edge.edgeAdjustedStyles(prefix: "padding", edges, "\(length)px")
        return self.style(styles)
    }

    /// Applies padding on selected sides of this element.
    /// - Parameters:
    ///   - edges: The edges where this padding should be applied.
    ///   - length: The amount of padding to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new padding applied.
    func padding(_ edges: Edge, _ length: LengthUnit) -> Self {
        let styles = Edge.edgeAdjustedStyles(prefix: "padding", edges, length.stringValue)
        return self.style(styles)
    }
}
