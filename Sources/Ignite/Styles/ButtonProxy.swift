//
// StyledButton.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A configuration that defines the visual styling properties for a button.
public struct ButtonProxy: Sendable {
    /// The default styles of the button.
    var defaultStyles = [InlineStyle]()

    /// The active styles of the button.
    // Bootstrap adds a border by default. Rather than removing the border, which
    // affects sizing, we simply make it transparent.
    var pressedStyles = [InlineStyle(.borderColor, value: Color.clear.description)]

    /// The hover styles of the button.
    var hoveredStyles = [InlineStyle]()

    /// The disabled styles of the button.
    var disabledStyles = [InlineStyle]()

    /// Sets the font weight of the button text.
    /// - Parameters:
    ///   - default: The default font weight.
    ///   - hovered: The font weight when the button is hovered over.
    ///   - pressed: The font weight when the button is pressed.
    ///   - disabled: The font weight when the button is disabled.
    /// - Returns: A new button with the updated font weights.
    public func fontWeight(
        _ default: FontWeight,
        hovered: FontWeight? = nil,
        pressed: FontWeight? = nil,
        disabled: FontWeight? = nil
    ) -> Self {
        var copy = self
        copy.defaultStyles.append(.init(.fontWeight, value: `default`.rawValue.formatted()))
        if let hovered {
            copy.hoveredStyles.append(.init(.fontWeight, value: hovered.rawValue.formatted()))
        }
        if let pressed {
            copy.pressedStyles.append(.init(.fontWeight, value: pressed.rawValue.formatted()))
        }
        if let disabled {
            copy.disabledStyles.append(.init(.fontWeight, value: disabled.rawValue.formatted()))
        }
        return copy
    }

    /// Configures the text color of the button for different states.
    /// - Parameters:
    ///   - default: The default text color.
    ///   - hovered: The text color when the button is hovered over.
    ///   - pressed: The text color when the button is pressed.
    ///   - disabled: The text color when the button is disabled.
    /// - Returns: A new button with the updated text colors.
    public func foregroundStyle(
        _ default: Color?,
        hovered: Color? = nil,
        pressed: Color? = nil,
        disabled: Color? = nil
    ) -> Self {
        var copy = self
        if let `default` {
            copy.defaultStyles.append(.init(.color, value: `default`.description))
        }
        if let hovered {
            copy.hoveredStyles.append(.init(.color, value: hovered.description))
        }
        if let pressed {
            copy.pressedStyles.append(.init(.color, value: pressed.description))
        }
        if let disabled {
            copy.disabledStyles.append(.init(.color, value: disabled.description))
        }
        return copy
    }

    /// Configures the background color of the button for different states.
    /// - Parameters:
    ///   - default: The default background color.
    ///   - hovered: The background color when the button is hovered over.
    ///   - pressed: The background color when the button is pressed.
    ///   - disabled: The background color when the button is disabled.
    /// - Returns: A new button with the updated background colors.
    public func background(
        _ default: Color?,
        hovered: Color? = nil,
        pressed: Color? = nil,
        disabled: Color? = nil
    ) -> Self {
        var copy = self
        if let `default` {
            copy.defaultStyles.append(.init(.backgroundColor, value: `default`.description))
        }
        if let hovered {
            copy.hoveredStyles.append(.init(.backgroundColor, value: hovered.description))
        }
        if let pressed {
            copy.pressedStyles.append(.init(.backgroundColor, value: pressed.description))
        }
        if let disabled {
            copy.disabledStyles.append(.init(.backgroundColor, value: disabled.description))
        }
        return copy
    }

    /// Configures the border color of the button for different states.
    /// - Parameters:
    ///   - default: The default border color.
    ///   - hovered: The border color when the button is hovered over.
    ///   - pressed: The border color when the button is pressed.
    ///   - disabled: The border color when the button is disabled.
    /// - Returns: A new button with the updated border colors.
    public func borderColor(
        _ default: Color?,
        hovered: Color? = nil,
        pressed: Color? = nil,
        disabled: Color? = nil
    ) -> Self {
        var copy = self
        if let `default` {
            copy.defaultStyles.append(.init(.borderColor, value: `default`.description))
        }
        if let hovered {
            copy.hoveredStyles.append(.init(.borderColor, value: hovered.description))
        }
        if let pressed {
            copy.pressedStyles.append(.init(.borderColor, value: pressed.description))
        }
        if let disabled {
            copy.disabledStyles.append(.init(.borderColor, value: disabled.description))
        }
        return copy
    }

    /// Sets the width of the button's border.
    /// - Parameters:
    ///   - default: The default border width.
    ///   - hovered: The border width when the button is hovered over.
    ///   - pressed: The border width when the button is pressed.
    ///   - disabled: The border width when the button is disabled.
    /// - Returns: A new button with the updated border widths.
    public func borderWidth(
        _ default: Double?,
        hovered: Double? = nil,
        pressed: Double? = nil,
        disabled: Double? = nil
    ) -> Self {
        var copy = self
        if let `default` {
            copy.defaultStyles.append(.init(.borderWidth, value: `default`.formatted()+"px"))
        }
        if let hovered {
            copy.hoveredStyles.append(.init(.borderWidth, value: hovered.formatted()+"px"))
        }
        if let pressed {
            copy.pressedStyles.append(.init(.borderWidth, value: pressed.formatted()+"px"))
        }
        if let disabled {
            copy.disabledStyles.append(.init(.borderWidth, value: disabled.formatted()+"px"))
        }
        return copy
    }

    /// Sets the corner radius of the button.
    /// - Parameters:
    ///   - default: The default corner radius configuration.
    ///   - hovered: The corner radius when the button is hovered over.
    ///   - pressed: The corner radius when the button is pressed.
    ///   - disabled: The corner radius when the button is disabled.
    /// - Returns: A new button with the updated corner radius configurations.
    public func cornerRadius(
        _ default: CornerRadii?,
        hovered: CornerRadii? = nil,
        pressed: CornerRadii? = nil,
        disabled: CornerRadii? = nil
    ) -> Self {
        var copy = self
        if let `default` {
            copy.defaultStyles.append(.init(.borderRadius, value: `default`.css))
        }
        if let hovered {
            copy.hoveredStyles.append(.init(.borderRadius, value: hovered.css))
        }
        if let pressed {
            copy.pressedStyles.append(.init(.borderRadius, value: pressed.css))
        }
        if let disabled {
            copy.disabledStyles.append(.init(.borderRadius, value: disabled.css))
        }
        return copy
    }

    /// Configures the shadow properties of the button for different states.
    /// - Parameters:
    ///   - default: The shadow configuration for the default state.
    ///   - hovered: The shadow configuration when the button is hovered over.
    ///   - pressed: The shadow configuration when the button is pressed.
    ///   - disabled: The shadow configuration when the button is disabled.
    /// - Returns: A new button with the updated shadow configurations.
    public func shadow(
        _ default: Shadow?,
        hovered: Shadow? = nil,
        pressed: Shadow? = nil,
        disabled: Shadow? = nil
    ) -> Self {
        var copy = self
        if let `default` {
            copy.defaultStyles.append(.init(.boxShadow, value: `default`.description))
        }
        if let hovered {
            copy.hoveredStyles.append(.init(.boxShadow, value: hovered.description))
        }
        if let pressed {
            copy.pressedStyles.append(.init(.boxShadow, value: pressed.description))
        }
        if let disabled {
            copy.disabledStyles.append(.init(.boxShadow, value: disabled.description))
        }
        return copy
    }

    /// Configures the inner shadow properties of the button for different states.
    /// - Parameters:
    ///   - default: The shadow configuration for the default state.
    ///   - hovered: The shadow configuration when the button is hovered over.
    ///   - pressed: The shadow configuration when the button is pressed.
    ///   - disabled: The shadow configuration when the button is disabled.
    /// - Returns: A new button with the updated shadow configurations.
    public func innerShadow(
        _ default: Shadow?,
        hovered: Shadow? = nil,
        pressed: Shadow? = nil,
        disabled: Shadow? = nil
    ) -> Self {
        var copy = self
        if var `default` {
            `default`.inset = true
            copy.defaultStyles.append(.init(.boxShadow, value: `default`.description))
        }
        if var hovered {
            hovered.inset = true
            copy.hoveredStyles.append(.init(.boxShadow, value: hovered.description))
        }
        if var pressed {
            pressed.inset = true
            copy.pressedStyles.append(.init(.boxShadow, value: pressed.description))
        }
        if var disabled {
            disabled.inset = true
            copy.disabledStyles.append(.init(.boxShadow, value: disabled.description))
        }
        return copy
    }

    /// Sets the padding of the button along specified axes.
    /// - Parameters:
    ///   - axis: The axis or axes to apply padding to (horizontal, vertical, or both).
    ///   - amount: The amount of padding to apply.
    /// - Returns: A new button with the updated padding.
    public func padding(_ axis: Axis, _ amount: LengthUnit) -> Self {
        var copy = self
        if axis.contains(.horizontal) {
            copy.defaultStyles.append(.init(.paddingInline, value: amount.stringValue))
        }
        if axis.contains(.vertical) {
            copy.defaultStyles.append(.init(.paddingBlock, value: amount.stringValue))
        }
        return copy
    }
}
