//
// Margin.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private enum MarginType {
    case exact(LengthUnit), semantic(SpacingAmount)
}

@MainActor private func marginModifier(
    _ margin: MarginType,
    edges: Edge = .all,
    content: some HTML
) -> some HTML {
    var modified = ModifiedHTML(content)

    switch margin {
    case .exact(let unit):
        let styles = Edge.edgeAdjustedStyles(prefix: "margin", edges, unit.stringValue)
        modified.attributes.append(styles: styles)
    case .semantic(let amount):
        let classes = Edge.edgeAdjustedClasses(prefix: "m", edges, amount.rawValue)
        modified.attributes.append(classes: classes)
    }

    return modified
}

@MainActor private func marginModifier(
    _ margin: MarginType,
    edges: Edge = .all,
    content: some InlineElement
) -> some InlineElement {
    var modified = ModifiedInlineElement(content)

    switch margin {
    case .exact(let unit):
        let styles = Edge.edgeAdjustedStyles(prefix: "margin", edges, unit.stringValue)
        modified.attributes.append(styles: styles)
    case .semantic(let amount):
        let classes = Edge.edgeAdjustedClasses(prefix: "m", edges, amount.rawValue)
        modified.attributes.append(classes: classes)
    }

    return modified
}

public extension HTML {
    /// Applies margins on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of margin to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ length: Int = 20) -> some HTML {
        marginModifier(.exact(.px(length)), content: self)
    }

    /// Applies margins on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ length: LengthUnit) -> some HTML {
        marginModifier(.exact(length), content: self)
    }

    /// Applies margins on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of margin to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ amount: SpacingAmount) -> some HTML {
        marginModifier(.semantic(amount), content: self)
    }

    /// Applies margins on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ length: Int = 20) -> some HTML {
        marginModifier(.exact(.px(length)), edges: edges, content: self)
    }

    /// Applies margins on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ length: LengthUnit) -> some HTML {
        marginModifier(.exact(length), edges: edges, content: self)
    }

    /// Applies margins on selected sides of this element, using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - amount: The amount of margin to apply, specified as a
    ///   `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ amount: SpacingAmount) -> some HTML {
        marginModifier(.semantic(amount), edges: edges, content: self)
    }
}

public extension InlineElement {
    /// Applies margins on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of margin to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ length: Int = 20) -> some InlineElement {
        marginModifier(.exact(.px(length)), content: self)
    }

    /// Applies margins on all sides of this element. Defaults to 20 pixels.
    /// - Parameter length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ length: LengthUnit) -> some InlineElement {
        marginModifier(.exact(length), content: self)
    }

    /// Applies margins on all sides of this element using adaptive sizing.
    /// - Parameter amount: The amount of margin to apply, specified as a
    /// `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ amount: SpacingAmount) -> some InlineElement {
        marginModifier(.semantic(amount), content: self)
    }

    /// Applies margins on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in pixels.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ length: Int = 20) -> some InlineElement {
        marginModifier(.exact(.px(length)), edges: edges, content: self)
    }

    /// Applies margins on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ length: LengthUnit) -> some InlineElement {
        marginModifier(.exact(length), edges: edges, content: self)
    }

    /// Applies margins on selected sides of this element, using adaptive sizing.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - amount: The amount of margin to apply, specified as a
    ///   `SpacingAmount` case.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ amount: SpacingAmount) -> some InlineElement {
        marginModifier(.semantic(amount), edges: edges, content: self)
    }
}

public extension ElementProxy {
    /// Applies margins on selected sides of this element. Defaults to 20 pixels.
    /// - Parameters:
    ///   - edges: The edges where this margin should be applied.
    ///   - length: The amount of margin to apply, specified in
    /// units of your choosing.
    /// - Returns: A copy of the current element with the new margins applied.
    func margin(_ edges: Edge, _ length: LengthUnit) -> Self {
        let styles = Edge.edgeAdjustedStyles(prefix: "margin", edges, length.stringValue)
        return self.style(styles)
    }
}
