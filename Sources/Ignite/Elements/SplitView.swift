//
// HSplitView.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public struct SplitView: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    private var sidebar: any BodyElement
    private var content: any BodyElement
    private var dividerColor: Color?
    private var dividerHoverColor: Color?
    private var idealWidth: LengthUnit?
    private var minWidth: LengthUnit?
    private var maxWidth: LengthUnit?
    private var isDismissDisabled = true
    private let htmlID: String

    public init(
        id: String,
        @HTMLBuilder sidebar: () -> some HTML,
        @HTMLBuilder content: () -> some HTML
    ) {
        self.htmlID = id
        self.sidebar = sidebar()
        self.content = content()
    }

    public func dividerColor(_ base: Color, hover: Color) -> Self {
        var copy = self
        copy.dividerColor = base
        copy.dividerHoverColor = hover
        return copy
    }

    public func dividerColor(_ color: Color) -> Self {
        var copy = self
        copy.dividerColor = color
        copy.dividerHoverColor = color
        return copy
    }

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

    public func interactiveDismissDisabled(_ disabled: Bool) -> Self {
        var copy = self
        copy.isDismissDisabled = disabled
        return copy
    }

    public func markup() -> Markup {
        Section {
            Section(sidebar)
                .class("left-panel")
                .class("collapse collapse-horizontal show")
                .style(.init("--hsplitview-divider-color", value: dividerColor?.description ?? ""))
                .style(.init("--splitview-min-width", value: minWidth?.stringValue ?? ""))
                .style(.init("--splitview-default-width", value: idealWidth?.stringValue ?? ""))
                .style(.init("--splitview-max-width", value: maxWidth?.stringValue ?? ""))
                .style(.init("--splitview-collapse-on-min", value: (!isDismissDisabled).description))
                .id(htmlID)

            Section {
                Section()
                    .class("divider-hitarea")
                    .id("divider-hitarea")
                Section()
                    .style(.init("--hsplitview-divider-color", value: dividerColor?.description ?? ""))
                    .style(.init("--hsplitview-divider-active-color", value: dividerHoverColor?.description ?? ""))
                    .class("divider-line")
            }
            .class("divider-wrapper")

            Section(content)
                .class("right-panel")
        }
        .attributes(attributes)
        .class("hsplitview")
        .markup()
    }
}
