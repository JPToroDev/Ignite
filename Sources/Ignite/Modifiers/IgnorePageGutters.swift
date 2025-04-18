//
// ScreenFrame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension Element {
    /// Determines whether this element should observe the site
    /// width or extend from one edge of the screen to the other.
    /// - Parameters:
    ///   - ignore: Whether this HTML should ignore the page gutters. Defaults to `true`.
    /// - - Returns: A modified element that either obeys or ignores the page gutters.
    func ignorePageGutters(_ ignore: Bool = true) -> some Element {
        AnyHTML(ignorePageGuttersModifer(ignore))
    }
}

private extension Element {
    func ignorePageGuttersModifer(_ shouldIgnore: Bool = true) -> any Element {
        if shouldIgnore {
            self.style(.init(.width, value: "100vw"), .init(.marginInline, value: "calc(50% - 50vw)"))
        } else {
            self.class("container")
        }
    }
}
