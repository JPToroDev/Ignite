//
// Button.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
public protocol ButtonElement {}

/// A clickable button with a label and styling.
public struct Button<Label: InlineElement>: InlineElement, FormItem {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this button should submit a form or not. Defaults to `.plain`.
    var type = ButtonType.plain

    /// How large this button should be drawn. Defaults to `.medium`.
    var size = ButtonSize.medium

    /// How this button should be styled on the screen. Defaults to `.default`.
    var role = Role.default

    /// Elements to render inside this button.
    var label: any InlineElement

    /// The icon element to display before the title.
    var systemImage: String?

    /// Whether the button is disabled and cannot be interacted with.
    private var isDisabled = false

    /// Creates a button with no label. Used in some situations where
    /// exact styling is performed by Bootstrap, e.g. in Carousel.
    public init() where Label == EmptyInlineElement {
        self.label = EmptyInlineElement()
    }

    /// Creates a button with a label.
    /// - Parameter label: The label text to display on this button.
    public init(_ label: Label) {
        self.label = label
    }

    /// Creates a button from a more complex piece of HTML.
    /// - Parameter label: An inline element builder of all the content
    /// for this button.
    public init(@InlineElementBuilder label: () -> Label) {
        self.label = label()
    }

    /// Creates a button with a label.
    /// - Parameters:
    ///   - title: The label text to display on this button.
    ///   - systemImage: An image name chosen from https://icons.getbootstrap.com.
    ///   - actions: An element builder that returns an array of actions to run when this button is pressed.
    public init(
        _ title: String,
        systemImage: String? = nil,
        @ActionBuilder actions: () -> [Action] = { [] }
    ) where Label == String {
        self.label = title
        self.systemImage = systemImage
        addEvent(name: "onclick", actions: actions())
    }

    /// Creates a button with a label.
    /// - Parameters:
    ///   - title: The label text to display on this button.
    ///   - systemImage: An image name chosen from https://icons.getbootstrap.com.
    ///   - action: The action to run when this button is pressed.
    public init(
        _ title: String,
        systemImage: String? = nil,
        action: any Action
    ) where Label == String {
        self.label = title
        self.systemImage = systemImage
        dataAttributes(for: action)
        addEvent(name: "onclick", actions: [action])
    }

    /// Creates a button with a label and actions to run when it's pressed.
    /// - Parameters:
    ///   - actions: An element builder that returns an array of actions to run when this button is pressed.
    ///   - label: The label text to display on this button.
    public init(
        @ActionBuilder actions: () -> [Action],
        @InlineElementBuilder label: () -> Label
    ) {
        self.label = label()
        addEvent(name: "onclick", actions: actions())
    }

    /// Creates a button with a label and actions to run when it's pressed.
    /// - Parameters:
    ///   - action: The action to run when this button is pressed.
    ///   - label: The label text to display on this button.
    public init(
        action: any Action,
        @InlineElementBuilder label: () -> Label
    ) {
        self.label = label()
        dataAttributes(for: action)
        addEvent(name: "onclick", actions: [action])
    }

    /// Adjusts the size of this button.
    /// - Parameter size: The new size.
    /// - Returns: A new `Button` instance with the updated size.
    public func buttonSize(_ size: ButtonSize) -> Self {
        var copy = self
        copy.size = size
        return copy
    }

    /// Adjusts the style of this button.
    /// - Parameter style: The new style.
    /// - Returns: A new `Button` instance with the updated style.
    public func buttonStyle(_ style: ButtonStyle) -> Self {
        var copy = self
        StyleManager.shared.registerButtonStyle(style)
        copy.attributes.append(classes: style.className)
        return copy
    }

    /// Adjusts the role of this button.
    /// - Parameter role: The new role
    /// - Returns: A new `Button` instance with the updated role.
    public func role(_ role: Role) -> Self {
        var copy = self
        copy.role = role
        return copy
    }

    /// Sets the button type, determining its behavior.
    /// - Parameter type: The type of button, such as `.plain` or `.submit`.
    /// - Returns: A new `Button` instance with the updated type.
    public func type(_ type: ButtonType) -> Self {
        var copy = self
        copy.type = type
        return copy
    }

    /// Disables this button.
    /// - Parameter disabled: Whether the button should be disabled.
    /// - Returns: A new `Button` instance with the updated disabled state.
    public func disabled(_ disabled: Bool = true) -> Self {
        var copy = self
        copy.isDisabled = disabled
        return copy
    }

    /// Adds the required data attributes for actions that use collpase animations.
    /// - Parameter action: The action of the this button.
    private mutating func dataAttributes(for action: any Action) {
        guard let toggleSidebar = action as? ToggleSidebar else { return }
        attributes.append(dataAttributes: .init(name: "bs-toggle", value: "collapse"))
        attributes.append(dataAttributes: .init(name: "bs-target", value: "#\(toggleSidebar.id)"))
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        var buttonAttributes = attributes
            .appending(classes: size.classes(forRole: role))
            .appending(aria: role.aria())

        if isDisabled {
            buttonAttributes.append(customAttributes: .disabled)
        }

        var labelHTML = ""
        if let systemImage, !systemImage.isEmpty {
            labelHTML = "<i class=\"bi bi-\(systemImage)\"></i> "
        }
        labelHTML += label.markupString()
        return Markup("<button type=\"\(type.htmlName)\"\(buttonAttributes)>\(labelHTML)</button>")
    }
}

public extension Button {
    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A copy of the current element with the adjusted column width.
    func width(_ width: Int) -> some InlineElement {
        self.class("w-100", ColumnWidth.count(width).className)
    }
}

extension Button: ButtonElement {}
