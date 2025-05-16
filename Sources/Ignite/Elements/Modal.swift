//
// Modal.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modal dialog presented on top of the screen that can be used to display content, forms, or alerts.
///
/// Modals are presented with a backdrop and can be customized with different sizes, positions, and behaviors.
/// They support headers and footers, and can be made scrollable for longer content.
public struct Modal: HTML {
    /// The size of the modal dialog.
    ///
    /// The height is determined by the content, while the width is fixed based on the selected size.
    public enum Size: CaseIterable, Sendable {
        /// A modal dialog with a small max-width of 300px.
        case small

        /// A modal dialog with a medium max-width of 500px.
        case medium

        /// A modal dialog with a large max-width of 800px.
        case large

        /// A modal dialog with an extra large max-width of 1140px.
        case xLarge

        /// A fullscreen modal dialog covering the entire viewport.
        case fullscreen

        /// The HTML class name for the modal size.
        var htmlClass: String? {
            switch self {
            case .small: "modal-sm"
            case .medium: nil
            case .large: "modal-lg"
            case .xLarge: "modal-xl"
            case .fullscreen: "modal-fullscreen"
            }
        }
    }

    /// The vertical position of the modal dialog on the screen.
    public enum Position: CaseIterable, Sendable {
        /// Positions the modal at the top of the screen.
        case top

        /// Positions the modal in the center of the screen.
        case center

        /// The HTML class name for the modal position.
        var htmlName: String? {
            switch self {
            case .top: nil
            case .center: "modal-dialog-centered"
            }
        }
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    private let htmlID: String
    private var content: any HTML
    private var header: any HTML
    private var footer: any HTML

    private var isAnimationDisabled = false
    private var isScrollDisabled = true
    private var size = Size.medium
    private var position = Position.center
    private var prefersDefaultFocus = true
    private var isExitCommandDisabled = false
    private var isBackgroundTintDisabled = false
    private var isDismissDisabled = false

    /// Creates a new modal dialog with the specified content.
    /// - Parameters:
    ///   - modalId: A unique identifier for the modal.
    ///   - body: The main content of the modal.
    ///   - header: Optional header content for the modal.
    ///   - footer: Optional footer content for the modal.
    public init(
        id modalId: String,
        @HTMLBuilder body: () -> some HTML,
        @HTMLBuilder header: () -> some HTML = { EmptyHTML() },
        @HTMLBuilder footer: () -> some HTML = { EmptyHTML() }
    ) {
        self.htmlID = modalId
        self.content = body()
        self.header = header()
        self.footer = footer()
    }

    /// Adjusts the size of the modal dialog.
    /// - Parameter size: The desired size for the modal.
    /// - Returns: A new `Modal` instance with the updated size.
    public func size(_ size: Size) -> Self {
        var copy = self
        copy.size = size
        return copy
    }

    /// Controls whether the modal's fade animation is enabled.
    /// - Parameter disabled: When `true`, disables the fade animation. Defaults to `true`.
    /// - Returns: A new `Modal` instance with the updated animation setting.
    public func animationDisabled(_ disabled: Bool = true) -> Self {
        var copy = self
        copy.isAnimationDisabled = disabled
        return copy
    }

    /// Sets the vertical position of the modal on the screen.
    /// - Parameter position: The desired vertical position.
    /// - Returns: A new `Modal` instance with the updated position.
    public func modalPosition(_ position: Position) -> Self {
        var copy = self
        copy.position = position
        return copy
    }

    /// Controls whether the modal's content is scrollable.
    /// - Parameter disabled: When `true`, prevents content from scrolling.
    /// - Returns: A new `Modal` instance with the updated scroll behavior.
    public func contentScrollDisabled(_ disabled: Bool) -> Self {
        var copy = self
        copy.isScrollDisabled = disabled
        return copy
    }

    /// Controls whether the modal automatically focuses when presented.
    /// - Parameter prefersDefaultFocus: When `true`, the modal will focus automatically.
    /// - Returns: A new `Modal` instance with the updated focus behavior.
    public func prefersDefaultFocus(_ prefersDefaultFocus: Bool) -> Self {
        var copy = self
        copy.prefersDefaultFocus = prefersDefaultFocus
        return copy
    }

    /// Controls whether the modal can be dismissed using the Escape key.
    /// - Parameter disabled: When `true`, prevents dismissal via Escape key. Defaults to `true`.
    /// - Returns: A new `Modal` instance with the updated keyboard dismissal behavior.
    public func exitCommandDisabled(_ disabled: Bool = true) -> Self {
        var copy = self
        copy.isExitCommandDisabled = disabled
        return copy
    }

    /// Controls whether the modal's backdrop is visible.
    /// - Parameter disabled: When `true`, hides the backdrop. Defaults to `true`.
    /// - Returns: A new `Modal` instance with the updated backdrop visibility.
    public func backgroundTintDisabled(_ disabled: Bool = true) -> Self {
        var copy = self
        copy.isBackgroundTintDisabled = disabled
        return copy
    }

    /// Prevents the modal from being dismissed by clicking outside of it.
    /// - Returns: A new `Modal` instance that cannot be dismissed by clicking outside.
    public func interactiveDismissDisabled() -> Self {
        var copy = self
        copy.isDismissDisabled = true
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        Section {
            Section {
                Section {
                    if !header.isEmpty {
                        Section(AnyHTML(header))
                            .class("modal-header")
                    }

                    Section(AnyHTML(content))
                        .class("modal-body")

                    if !footer.isEmpty {
                        Section(AnyHTML(footer))
                            .class("modal-footer")
                    }
                }
                .class("modal-content")
            }
            .class("modal-dialog")
            .class(size.htmlClass)
            .class(position.htmlName)
            .class(isScrollDisabled ? nil : "modal-dialog-scrollable")
        }
        .attributes(attributes)
        .class(isAnimationDisabled ? "modal" : "modal fade")
        .data("bs-keyboard", (!isExitCommandDisabled).description)
        .data("bs-backdrop", isDismissDisabled ? "static" : (!isBackgroundTintDisabled).description)
        .data("bs-focus", prefersDefaultFocus.description)
        .tabFocus(.focusable)
        .id(htmlID)
        .aria(.labelledBy, "modalLabel")
        .aria(.hidden, "true")
        .markup()
    }
}
