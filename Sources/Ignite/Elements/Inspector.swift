//
// Inspector.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An inspector panel that slides in from the edge of the screen.
///
/// Inspectors are useful for displaying additional content, settings, or forms
/// without navigating away from the current page. They can be positioned on any edge
/// of the screen and support headers and scrollable content.
public struct Inspector<Content: HTML, Header: HTML>: HTML {
    /// The position of the inspector on the screen.
    public enum Position: CaseIterable, Sendable {
        /// Positions the inspector on the left edge of the screen.
        case leading

        /// Positions the inspector on the right edge of the screen.
        case trailing

        /// Positions the inspector on the top edge of the screen.
        case top

        /// Positions the inspector on the bottom edge of the screen.
        case bottom

        /// The CSS class name for the inspector position.
        var cssClass: String {
            switch self {
            case .leading: "offcanvas-start"
            case .trailing: "offcanvas-end"
            case .top: "offcanvas-top"
            case .bottom: "offcanvas-bottom"
            }
        }
    }

    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    private var isScrollDisabled = true
    private var position = Position.leading
    private var isBackgroundTintDisabled = false
    private var isDismissDisabled = false
    private var isExitCommandDisabled = false

    private let htmlID: String
    private var content: Content
    private var header: Header

    /// Creates a new inspector with the specified content.
    /// - Parameters:
    ///   - modalId: A unique identifier for the inspector.
    ///   - body: The main content of the inspector.
    ///   - header: Optional header content for the inspector.
    public init(
        id modalId: String,
        @HTMLBuilder body: () -> Content,
        @HTMLBuilder header: () -> Header = { EmptyHTML() }
    ) {
        self.htmlID = modalId
        self.content = body()
        self.header = header()
    }

    /// Controls whether the page behind the inspector can be scrolled while the inspector is open.
    /// - Parameter disabled: When `true`, prevents the page from scrolling.
    /// - Returns: A new `Inspector` instance with the updated scroll behavior.
    public func pageScrollDisabled(_ disabled: Bool) -> Self {
        var copy = self
        copy.isScrollDisabled = disabled
        return copy
    }

    /// Controls whether the inspector's backdrop is visible.
    /// - Parameter disabled: When `true`, hides the backdrop. Defaults to `true`.
    /// - Returns: A new `Inspector` instance with the updated backdrop visibility.
    public func backgroundTintDisabled(_ disabled: Bool = true) -> Self {
        var copy = self
        copy.isBackgroundTintDisabled = disabled
        return copy
    }

    /// Prevents the inspector from being dismissed by clicking outside of it.
    /// - Returns: A new `Inspector` instance that cannot be dismissed by clicking outside.
    public func interactiveDismissDisabled() -> Self {
        var copy = self
        copy.isDismissDisabled = true
        return copy
    }

    /// Controls whether the inspector can be dismissed using the Escape key.
    /// - Parameter disabled: When `true`, prevents dismissal via Escape key. Defaults to `true`.
    /// - Returns: A new `Inspector` instance with the updated keyboard dismissal behavior.
    public func exitCommandDisabled(_ disabled: Bool = true) -> Self {
        var copy = self
        copy.isExitCommandDisabled = disabled
        return copy
    }

    /// Sets the position of the inspector on the screen.
    /// - Parameter position: The desired position for the inspector.
    /// - Returns: A new `Inspector` instance with the updated position.
    public func inspectorPosition(_ position: Position) -> Self {
        var copy = self
        copy.position = position
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        Section {
            Section {
                if header.isEmptyHTML == false {
                    AnyHTML(header)
                        .class("offcanvas-title")
                        .id("offcanvasLabel")
                }
                Button()
                    .class("btn-close")
                    .aria(.label, "Close")
                    .data("bs-dismiss", "offcanvas")
            }
            .class("offcanvas-header")

            Section(content)
                .class("offcanvas-body")
        }
        .attributes(attributes)
        .class("offcanvas", position.cssClass)
        .data("bs-toggle", "offcanvas")
        .data("bs-keyboard", (!isExitCommandDisabled).description)
        .data("bs-backdrop", isDismissDisabled ? "static" : (!isBackgroundTintDisabled).description)
        .data("bs-scroll", (!isScrollDisabled).description)
        .aria(.labelledBy, "offcanvasLabel")
        .tabFocus(.focusable)
        .id(htmlID)
        .markup()
    }
}
