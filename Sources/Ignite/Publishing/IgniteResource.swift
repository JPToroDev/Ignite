//
// IgniteResource.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Represents built-in resources provided by the Ignite framework
enum IgniteResource: Sendable {
    /// JavaScript code for implementing split view functionality
    case splitViewJS

    /// JavaScript code for implementing line numbering in code blocks
    case prismLineNumberingJS

    /// JavaScript code for implementing line highlighting in code blocks
    case prismLineHighlightingJS

    /// The path relative to the framework bundle
    var bundleRelativePath: String {
        switch self {
        case .splitViewJS: "js/ignite-split-view.js"
        case .prismLineNumberingJS: "js/prism-line-numbering.js"
        case .prismLineHighlightingJS: "js/prism-line-highlighting.js"
        }
    }

    /// The path relative to the website root
    var rootRelativePath: String {
        switch self {
        case .splitViewJS: "/js/ignite-split-view.js"
        case .prismLineNumberingJS: "/js/prism-line-numbering.js"
        case .prismLineHighlightingJS: "/js/prism-line-highlighting.js"
        }
    }
}
