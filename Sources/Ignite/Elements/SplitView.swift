//
// HSplitView.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A resizable split view that divides content into a
/// sidebar and main content area with an interactive divider.
public struct SplitView: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The sidebar content of the split view.
    private var sidebar: any BodyElement

    /// The main content of the split view.
    private var content: any BodyElement

    /// The base color of the divider between sidebar and content.
    private var dividerColor: Color?

    /// The color of the divider when hovered.
    private var dividerHoverColor: Color?

    /// The preferred width of the sidebar.
    private var idealWidth: LengthUnit?

    /// The minimum width the sidebar can be resized to.
    private var minWidth: LengthUnit?

    /// The maximum width the sidebar can be resized to.
    private var maxWidth: LengthUnit?

    /// Whether the sidebar can be dismissed by dragging.
    private var isDismissDisabled = true

    /// The unique identifier for this split view.
    private let htmlID: String

    /// Creates a new split view with the specified sidebar and content.
    /// - Parameters:
    ///   - id: A unique identifier for this split view.
    ///   - sidebar: A closure that returns the sidebar content.
    ///   - content: A closure that returns the main content.
    public init(
        id: String,
        @HTMLBuilder sidebar: () -> some HTML,
        @HTMLBuilder content: () -> some HTML
    ) {
        self.htmlID = id
        self.sidebar = sidebar()
        self.content = content()
    }

    /// Sets different colors for the divider in its normal and hover states.
    /// - Parameters:
    ///   - base: The default color of the divider.
    ///   - hover: The color of the divider when hovered.
    /// - Returns: A modified split view with the specified divider colors.
    public func dividerColor(_ base: Color, hover: Color) -> Self {
        var copy = self
        copy.dividerColor = base
        copy.dividerHoverColor = hover
        return copy
    }

    /// Sets the same color for the divider in both normal and hover states.
    /// - Parameter color: The color to use for the divider in all states.
    /// - Returns: A modified split view with the specified divider color.
    public func dividerColor(_ color: Color) -> Self {
        var copy = self
        copy.dividerColor = color
        copy.dividerHoverColor = color
        return copy
    }

    /// Configures the width constraints for the sidebar.
    /// - Parameters:
    ///   - minWidth: The minimum width the sidebar can be resized to.
    ///   - idealWidth: The preferred width of the sidebar.
    ///   - maxWidth: The maximum width the sidebar can be resized to.
    /// - Returns: A modified split view with the specified width constraints.
    public func sidebarWidth(
        minWidth: LengthUnit? = nil,
        idealWidth: LengthUnit? = nil,
        maxWidth: LengthUnit? = nil
    ) -> Self {
        var copy = self
        copy.idealWidth = idealWidth
        copy.minWidth = minWidth
        copy.maxWidth = maxWidth
        return copy
    }

    /// Controls whether the sidebar can be dismissed by dragging.
    /// - Parameter disabled: When `true`, prevents the sidebar from being dismissed by dragging.
    /// - Returns: A modified split view with the specified dismiss behavior.
    public func interactiveDismissDisabled(_ disabled: Bool) -> Self {
        var copy = self
        copy.isDismissDisabled = disabled
        return copy
    }

    /// Generates the HTML markup for this split view.
    /// - Returns: The markup representation of this split view.
    public func markup() -> Markup {
        Section {
            Section(sidebar)
                .class("splitview-sidebar")
                .class("collapse collapse-horizontal show")
                .style("--splitview-divider-color", dividerColor?.description)
                .style("--splitview-min-width", minWidth?.stringValue)
                .style("--splitview-default-width", idealWidth?.stringValue)
                .style("--splitview-max-width", maxWidth?.stringValue)
                .style("--splitview-collapse-on-min", (!isDismissDisabled).description)
                .id(htmlID)

            Section {
                Section()
                    .class("splitview-divider-hitarea")
                    .id("splitview-divider-hitarea")
                Section()
                    .style("--splitview-divider-color", dividerColor?.description)
                    .style("--splitview-divider-active-color", dividerHoverColor?.description)
                    .class("splitview-divider-line")
            }
            .class("splitview-divider")

            Section(content)
                .class("splitview-content")
        }
        .class("splitview")
        .attributes(attributes)
        .markup()
    }
}
