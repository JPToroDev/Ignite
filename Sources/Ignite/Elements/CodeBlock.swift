//
// CodeBlock.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An separated section of programming code. For inline code that sit along other
/// text on your page, use `Code` instead.
///
/// - Important: If your code contains angle brackets (`<`...`>`), such as Swift generics,
/// the prettifier will interpret these as HTML tags and break the code's formatting.
/// To avoid this issue, either set your site's `shouldPrettify` property to `false`,
/// or replace `<` and `>` with their character entity references, `&lt;` and `&gt;` respectively.
public struct CodeBlock: HTML {
    /// Controls the visibility and formatting of line numbers.
    public enum LineNumberVisibility: Equatable, Sendable {
        /// Shows line numbers with the specified starting number and wrapping behavior.
        case visible(firstLine: Int)
        /// Hides line numbers.
        case hidden

        /// Shows line numbers starting at 1 without text wrapping.
        public static let visible: Self = .visible(firstLine: 1)
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The code to display.
    private var content: String

    /// The language of the code being shown.
    private var language: HighlighterLanguage?

    /// The visibility of line numbers.
    private var lineNumberVisibility: LineNumberVisibility?

    /// Whether long lines should break to the next line.
    private var isWrappingDisabled: Bool?

    /// The lines of the code block that should be highlighted.
    private var highlightedLineData: String?

    /// The syntax highlighter configuration used by the site.
    private let configuration = PublishingContext.shared.site.syntaxHighlighterConfiguration

    /// Computes the attributes needed for line wrapping based on instance and site settings.
    private var lineWrappingAttributes: CoreAttributes {
        let siteWrapping = configuration.wrapLines
        var attributes = CoreAttributes()

        if (isWrappingDisabled == nil && siteWrapping) || isWrappingDisabled == false {
            attributes.append(styles: .init(.whiteSpace, value: "pre-wrap"))
        }

        return attributes
    }

    /// Computes the attributes needed for line number display based on instance and site settings.
    private var lineNumberAttributes: CoreAttributes {
        let siteVisibility = configuration.lineNumberVisibility
        var attributes = CoreAttributes()

        if lineNumberVisibility == nil, siteVisibility == .visible {
            attributes.append(classes: "line-numbers")
        }

        if case .hidden = lineNumberVisibility, siteVisibility == .visible {
            attributes.append(classes: "no-line-numbers")
        }

        if case .visible(let firstLine) = lineNumberVisibility, siteVisibility == .hidden {
            attributes.append(classes: "line-numbers")
            if firstLine != 1 {
                attributes.append(dataAttributes: .init(name: "start", value: firstLine.formatted()))
            }
        }

        return attributes
    }

    /// Creates a new `Code` instance from the given content.
    /// - Parameters:
    ///   - language: The programming language for the code. This affects
    ///   how the content is tagged, which in turn affects syntax highlighting.
    ///   - content: The code you want to render.
    public init(_ language: HighlighterLanguage? = .automatic, _ content: () -> String) {
        self.language = language
        self.content = content()
    }

    /// A code block with highlighted lines.
    /// - Parameter lines: Individual line numbers to highlight.
    /// - Returns: A copy of this code block with the specified lines highlighted.
    public func highlightedLines(_ lines: Int...) -> Self {
        var copy = self
        let highlights = lines.map { "\($0)" }
        let lineData = highlights.joined(separator: ",")
        copy.highlightedLineData = lineData
        return copy
    }

    /// A code block with highlighted line ranges.
    /// - Parameter ranges: Ranges of lines to highlight.
    /// - Returns: A copy of this code block with the specified line ranges highlighted.
    public func highlightedRanges(_ ranges: ClosedRange<Int>...) -> Self {
        var copy = self
        let highlights = ranges.map { "\($0.lowerBound)-\($0.upperBound)" }
        let lineData = highlights.joined(separator: ",")
        copy.highlightedLineData = lineData
        return copy
    }

    /// A code block with highlighted lines and ranges.
    /// - Parameters:
    ///   - lines: Individual line numbers to highlight.
    ///   - ranges: Ranges of lines to highlight.
    /// - Returns: A copy of this code block with the specified lines highlighted.
    public func highlightedLines(_ lines: Int..., ranges: ClosedRange<Int>...) -> Self {
        let singleLines = lines.map { "\($0)" }
        let rangeLines = ranges.map { "\($0.lowerBound)-\($0.upperBound)" }
        let allHighlights = singleLines + rangeLines

        var copy = self
        let lineData = allHighlights.joined(separator: ",")
        copy.highlightedLineData = lineData
        return copy
    }

    /// Configures whether line numbers are shown for this code block.
    /// - Parameter visibility: The visibility configuration for line numbers,
    /// including start line and text wrapping options.
    /// - Returns: A copy of this code block with the specified line number visibility.
    public func lineNumberVisibility(_ visibility: LineNumberVisibility) -> Self {
        var copy = self
        copy.lineNumberVisibility = visibility
        return copy
    }

    /// Configures whether line wrapping should be disabled for this code block.
    /// - Parameter disabled: True to disable line wrapping, false to enable it.
    /// - Returns: A copy of this code block with the specified line wrapping setting.
    public func lineWrappingDisabled(_ disabled: Bool) -> Self {
        var copy = self
        copy.isWrappingDisabled = disabled
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        guard publishingContext.site.allHighlighterThemes.isEmpty == false else {
            fatalError(.missingDefaultSyntaxHighlighterTheme)
        }

        let siteVisibility = configuration.lineNumberVisibility
        if lineNumberVisibility == .visible ||
            siteVisibility == .visible ||
            // When line numbering is disabled but highlighting and wrapping are enabled,
            // Prism incorrectly treats wrapped portions as separate lines and displays
            // line numbers that ignore wrapping for the highlighted lines. Loading
            // this resource hides these erroneous line numbers to make workarounds easier.
            (highlightedLineData != nil && isWrappingDisabled == false) {
            // Resources must be added in markup().
            // Adding in other methods results in adding the resource
            // to a temporary set of environment values
            publishingContext.environment.resources.insert(.prismLineNumberingJS)
        }

        let resolvedLanguage = language == .automatic ? configuration.defaultLanguage : language
        var codeAttributes = lineWrappingAttributes
        var preAttributes = attributes
        preAttributes.merge(lineWrappingAttributes)
        preAttributes.merge(lineNumberAttributes)

        if let highlightedLineData {
            preAttributes.append(dataAttributes: .init(name: "line", value: highlightedLineData))
            publishingContext.environment.resources.insert(.prismLineHighlightingJS)
        }

        if let resolvedLanguage, resolvedLanguage != .automatic {
            publishingContext.environment.syntaxHighlighters.insert(resolvedLanguage)
            codeAttributes.append(classes: "language-\(resolvedLanguage)")
            return Markup("""
            <pre\(preAttributes)>\
            <code\(codeAttributes)>\
            \(content)\
            </code>\
            </pre>
            """)
        }

        return Markup("""
        <pre\(preAttributes)>\
        <code\(codeAttributes)>\(content)</code>\
        </pre>
        """)
    }
}
