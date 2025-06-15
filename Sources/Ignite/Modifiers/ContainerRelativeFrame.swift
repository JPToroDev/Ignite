//
// ContainerRelativeFrame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Creates a flex container that allows its child to be positioned relative to its container.
    /// - Parameter alignment: How to align the content within the container. Default is `.center`.
    /// - Returns: A modified copy of the element with container-relative positioning applied.
    func containerRelativeFrame(_ alignment: Alignment = .center) -> some HTML {
        containerRelativeFrameModifer(alignment)
    }
}

private let edgeAlignmentRules: [InlineStyle] = [
    .init(.top, value: "0"),
    .init(.right, value: "0"),
    .init(.bottom, value: "0"),
    .init(.left, value: "0")
]

private extension HTML {
    func containerRelativeFrameModifer(_ alignment: Alignment) -> some HTML {
        ContainerRelativeFrame(self, alignment: alignment)
    }
}

struct ContainerRelativeFrame<Content: HTML>: HTML {
    var attributes = CoreAttributes()

    var body: Never { fatalError() }

    var content: Content
    var alignment: Alignment

    init(_ content: Content, alignment: Alignment) {
        self.content = content
        self.alignment = alignment
    }

    func render() -> Markup {
        let content = content
            .style(.marginBottom, "0")
            .style(alignment.itemAlignmentRules)

        let finalContent: any HTML = if content.requiresPositioningContext {
            Section(content)
        } else {
            content
        }

        return finalContent
            .style(.display, "flex")
            .style(self is any ImageProvider ? .init(.flexDirection, value: "column") : nil)
            .style(.overflow, "hidden")
            .style(edgeAlignmentRules)
            .style(alignment.flexAlignmentRules)
            .style(.width, "100%")
            .style(.height, "100%")
            .render()
    }
}
