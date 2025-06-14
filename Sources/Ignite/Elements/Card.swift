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
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    var role = Role.default
    var style = Style.default

    var contentPosition = CardContentPosition.default
    var imageOpacity = 1.0

    var image: Image?
    private var header: Header
    private var footer: Footer
    private var children: SubviewsCollection

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
        @HTMLBuilder content: () -> Content,
        @HTMLBuilder header: () -> Header,
        @HTMLBuilder footer: () -> Footer
    ) {
        if let imageName {
            self.image = Image(decorative: imageName)
        }

        self.header = header()
        self.footer = footer()
        self.children = SubviewsCollection(content())
    }

    public init(
        imageName: String? = nil,
        @HTMLBuilder header: () -> Header,
        @HTMLBuilder footer: () -> Footer
    ) where Content == EmptyHTML {
        if let imageName {
            self.image = Image(decorative: imageName)
        }

        self.header = header()
        self.footer = footer()
        self.children = SubviewsCollection()
    }

    public init(
        imageName: String? = nil,
        @HTMLBuilder content: () -> Content
    ) where Header == EmptyHTML, Footer == EmptyHTML {
        if let imageName {
            self.image = Image(decorative: imageName)
        }

        self.header = EmptyHTML()
        self.footer = EmptyHTML()
        self.children = SubviewsCollection(content())
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

            if header.isEmptyHTML == false {
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

            if footer.isEmptyHTML == false {
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
            ForEach(children) {
                $0.configuredAsCardItem()
            }
        }
        .class(contentPosition.bodyClasses)
    }

    private func renderFooter() -> some HTML {
        Section(footer)
            .class("card-footer", "text-body-secondary")
    }
}
