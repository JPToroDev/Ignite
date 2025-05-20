//
// Card.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A group of information placed inside a gently rounded
public struct Card<Header: HTML, Content: HTML, Footer: HTML>: HTML {
    /// Styling for this card.
    public enum Style: CaseIterable, Sendable {
        /// Default styling.
        case `default`

        /// Solid background color.
        case solid

        /// Solid border color.
        case bordered
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    var role = Role.default
    var style = Style.default

    var contentPosition = CardContentPosition.default
    var imageOpacity = 1.0

    var image: Image?
    private var header: Header
    private var footer: Footer
    private var items: Content

    var cardClasses: String? {
        switch style {
        case .default:
            nil
        case .solid:
            "text-bg-\(role.rawValue)"
        case .bordered:
            "border-\(role.rawValue)"
        }
    }

    public init(
        imageName: String? = nil,
        @HTMLBuilder body: () -> Content,
        @HTMLBuilder header: () -> Header = { EmptyHTML() },
        @HTMLBuilder footer: () -> Footer = { EmptyHTML() }
    ) {
        if let imageName {
            self.image = Image(decorative: imageName)
        }

        self.header = header()
        self.footer = footer()
        self.items = body()
    }

    public func role(_ role: Role) -> Card {
        var copy = self
        copy.role = role

        if style == .default {
            copy.style = .solid
        }

        return copy
    }

    /// Adjusts the rendering style of this card.
    /// - Parameter style: The new card style to use.
    /// - Returns: A new `Card` instance with the updated style.
    public func cardStyle(_ style: Style) -> Card {
        var copy = self
        copy.style = style
        return copy
    }

    /// Adjusts the position of this card's content relative to its image.
    /// - Parameter newPosition: The new content positio for this card.
    /// - Returns: A new `Card` instance with the updated content position.
    public func contentPosition(_ newPosition: CardContentPosition) -> Self {
        var copy = self
        copy.contentPosition = newPosition
        return copy
    }

    /// Adjusts the opacity of the image for this card. Use values
    /// lower than 1.0 to progressively dim the image.
    /// - Parameter opacity: The new opacity for this card.
    /// - Returns: A new `Card` instance with the updated image opacity.
    public func imageOpacity(_ opacity: Double) -> Self {
        var copy = self
        copy.imageOpacity = opacity
        return copy
    }

    public func markup() -> Markup {
        Section {
            if let image, contentPosition.addImageFirst {
                if imageOpacity != 1 {
                    image
                        .class(contentPosition.imageClass)
                        .style(.opacity, imageOpacity.description)
                } else {
                    image
                        .class(contentPosition.imageClass)
                }
            }

            if header.isEmpty == false {
                renderHeader()
            }

            renderItems()

            if let image, !contentPosition.addImageFirst {
                if imageOpacity != 1 {
                    image
                        .class(contentPosition.imageClass)
                        .style(.opacity, imageOpacity.description)
                } else {
                    image
                        .class(contentPosition.imageClass)
                }
            }

            if footer.isEmpty == false {
                renderFooter()
            }
        }
        .attributes(attributes)
        .class("card")
        .class(cardClasses)
        .markup()
    }

    private func renderHeader() -> some HTML {
        Section(header)
            .class("card-header")
    }

    private func renderItems() -> some HTML {
        Section {
//            let items = VariadicHTML([items]).children
//            ForEach(items) { item in
//                switch item {
//                case let text as any TextElement where text.fontStyle == .body || text.fontStyle == .lead:
//                    AnyHTML(text).class("card-text")
//                case is any TextElement:
//                    AnyHTML(item).class("card-title")
//                case is any LinkElement:
//                    AnyHTML(item).class("card-link")
//                case is any ImageElement:
//                    AnyHTML(item).class("card-img")
//                default:
//                    AnyHTML(item)
//                }
//            }
        }
        .class(contentPosition.bodyClasses)
    }

    private func renderFooter() -> some HTML {
        Section(footer)
            .class("card-footer", "text-body-secondary")
    }
}

public extension Card where Content == EmptyHTML {
    init(
        imageName: String? = nil,
        @HTMLBuilder header: () -> Header = { EmptyHTML() },
        @HTMLBuilder footer: () -> Footer = { EmptyHTML() }
    ) {
        if let imageName {
            self.image = Image(decorative: imageName)
        }

        self.header = header()
        self.footer = footer()
        self.items = EmptyHTML()
    }
}

public extension Card where Footer == EmptyHTML {
    init(
        imageName: String? = nil,
        @HTMLBuilder body: () -> Content,
        @HTMLBuilder header: () -> Header = { EmptyHTML() }
    ) {
        if let imageName {
            self.image = Image(decorative: imageName)
        }

        self.header = header()
        self.footer = EmptyHTML()
        self.items = body()
    }
}

public extension Card where Header == EmptyHTML, Footer == EmptyHTML {
    init(
        imageName: String? = nil,
        @HTMLBuilder body: () -> Content
    ) {
        if let imageName {
            self.image = Image(decorative: imageName)
        }

        self.header = EmptyHTML()
        self.footer = EmptyHTML()
        self.items = body()
    }
}

/// Where to position the content of the card relative to it image.
public enum CardContentPosition: CaseIterable, Sendable {
    public static let allCases: [CardContentPosition] = [
        .bottom, .top, .overlay(alignment: .topLeading)
    ]

    /// Positions content below the image.
    case bottom

    /// Positions content above the image.
    case top

    /// Positions content over the image.
    case overlay(alignment: CardContentAlignment)

    // Static entries for backward compatibilty
    public static let `default` = Self.bottom
    public static let overlay = Self.overlay(alignment: .topLeading)

    // MARK: Helpers for `render`

    var imageClass: String {
        switch self {
        case .bottom:
            "card-img-top"
        case .top:
            "card-img-bottom"
        case .overlay:
            "card-img"
        }
    }

    var bodyClasses: [String] {
        switch self {
        case .overlay(let alignment):
            ["card-img-overlay", alignment.textAlignment.rawValue, alignment.verticalAlignment.rawValue]
        default:
            ["card-body"]
        }
    }

    var addImageFirst: Bool {
        switch self {
        case .bottom, .overlay:
            true
        case .top:
            false
        }
    }
}

public enum CardContentAlignment: CaseIterable, Sendable {
    case topLeading
    case top
    case topTrailing
    case leading
    case center
    case trailing
    case bottomLeading
    case bottom
    case bottomTrailing


    enum TextAlignment: String, CaseIterable, Sendable {
        case start = "text-start"
        case center = "text-center"
        case end = "text-end"
    }

    enum VerticalAlignment: String, CaseIterable, Sendable {
        case start = "align-content-start"
        case center = "align-content-center"
        case end = "align-content-end"
    }

    var textAlignment: TextAlignment {
        switch self {
        case .topLeading, .leading, .bottomLeading:
            .start
        case .top, .center, .bottom:
            .center
        case .topTrailing, .trailing, .bottomTrailing:
            .end
        }
    }

    var verticalAlignment: VerticalAlignment {
        switch self {
        case .topLeading, .top, .topTrailing:
            .start
        case .leading, .center, .trailing:
            .center
        case .bottomLeading, .bottom, .bottomTrailing:
            .end
        }
    }

    public static let `default` = Self.topLeading
}
