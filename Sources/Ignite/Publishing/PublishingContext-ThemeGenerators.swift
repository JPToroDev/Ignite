//
// PublishingContext-ThemeGenerators.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PublishingContext {
    /// Creates CSS rules for all themes and writes to themes.min.css
    func generateThemes(_ themes: [any Theme]) {
        guard !themes.isEmpty else { return }
        let rules = generateThemeRules(themes)
        writeThemeRules(rules, to: "css/ignite-core.css")
    }

    /// Writes CSS rules to a file
    private func writeThemeRules(_ rules: String, to path: String) {
        let cssPath = buildDirectory.appending(path: path)
        do {
            let existingContent = try String(contentsOf: cssPath, encoding: .utf8)
            let newContent = rules + "\n\n" + existingContent
            try newContent.write(to: cssPath, atomically: true, encoding: .utf8)
        } catch {
            fatalError(.failedToWriteFile(path))
        }
    }

    /// Generates CSS for all themes including font faces, colors, and typography settings, writing to themes.min.css.
    private func globalRulesets() -> String {
        guard let sourceURL = Bundle.module.url(forResource: "Resources/css/global-rules", withExtension: "css") else {
            fatalError(.missingSiteResource("css/global-rules.css"))
        }

        do {
            let contents = try String(contentsOf: sourceURL)
            return contents
        } catch {
            fatalError(.failedToCopySiteResource("css/global-rules.css"))
        }
    }

    /// Creates @font-face and @import rules for custom fonts in a theme.
    private func fontRules(for fonts: some Collection<Font>) -> [String] {
        let systemFonts = Font.systemFonts + Font.monospaceFonts
        let declarations = fonts.compactMap { font -> [String]? in
            guard let family = font.name,
                  !family.isEmpty,
                  !systemFonts.contains(family)
            else { return nil }
            return font.sources.compactMap { source in
                generateFontRule(family: family, source: source)
            }
        }

        return declarations.flatMap(\.self)
    }

    private func generateFontRule(family: String, source: FontSource) -> String? {
        if source.url.host()?.contains("fonts.googleapis.com") == true {
            return ImportRule(source.url).render()
        }

        return FontFaceRule(
            family: family,
            source: source.url,
            weight: source.weight.description,
            style: source.variant.rawValue
        ).render()
    }

    /// Creates CSS rules for a base theme
    private func themeRules(_ theme: any Theme) -> String {
        var rules = [any CSS]()

        if !site.hasMultipleThemes {
            rules.append(rootStyles(for: theme))
        } else if let overrides = themeOverrides(for: theme) {
            rules.append(overrides)
        }

        rules.append(contentsOf: baseThemeRules(theme))
        return rules.map { $0.render() }.joined(separator: "\n\n")
    }

    /// Collects all CSS rules for the themes
    private func generateThemeRules(_ themes: [any Theme]) -> String {
        guard site.supportsLightTheme || site.supportsDarkTheme else {
            fatalError(.missingDefaultTheme)
        }

        let customFontRules = fontRules(for: CSSManager.shared.customFonts)
        let themeFontRules: OrderedSet = OrderedSet(themes.flatMap { theme in
            let themeFonts = [theme.monospaceFont, theme.font, theme.headingFont]
            return fontRules(for: themeFonts)
        })

        var rules = [String]()
        rules.append(contentsOf: themeFontRules)
        rules.append(contentsOf: customFontRules)
        rules.append(globalRulesets())

        let (lightTheme, darkTheme) = configureDefaultThemes(site.lightTheme, site.darkTheme)

        if let lightTheme {
            rules.append(themeRules(lightTheme))
        }

        if let darkTheme {
            rules.append(themeRules(darkTheme))
        }

        for theme in site.alternateThemes {
            let styles = themeStyles(for: theme)
            let ruleset = Ruleset(.attribute("data-bs-theme", value: theme.cssID), styles: styles)
            let rulsetString = ruleset.render()
            rules.append(rulsetString)
        }

        return rules.joined(separator: "\n\n")
    }

    /// Configures default light and dark themes, inheriting properties when needed
    private func configureDefaultThemes(
        _ light: (any Theme)?,
        _ dark: (any Theme)?
    ) -> (light: (any Theme)?, dark: (any Theme)?) {
        var lightTheme = light
        var darkTheme = dark

        if let dark = darkTheme as? DefaultDarkTheme, let lightTheme, !lightTheme.isDefaultLightTheme {
            darkTheme = dark.merging(lightTheme)
        }

        if let light = lightTheme as? DefaultLightTheme, let darkTheme, !darkTheme.isDefaultDarkTheme {
            lightTheme = light.merging(darkTheme)
        }

        return (lightTheme, darkTheme)
    }

    /// Creates base theme rules (for root theme)
    private func baseThemeRules(_ theme: any Theme) -> [any CSS] {
        var rules: [any CSS] = []
        rules.append(contentsOf: containerMediaQueries(for: theme))
        rules.append(contentsOf: responsiveVariables(for: theme))
        rules.append(contentsOf: buttonColorVariants(for: theme))
        return rules
    }

    /// Creates theme override rulesets if needed
    private func themeOverrides(for theme: any Theme) -> Ruleset? {
        guard site.hasMultipleThemes else { return nil }
        return Ruleset(.attribute("data-bs-theme", value: theme.cssID)) {
            themeStyles(for: theme)
        }
    }

    /// Contains the various snap dimensions for different Bootstrap widths.
    private func containerMediaQueries(for theme: any Theme) -> [any CSS] {
        let breakpoints: [LengthUnit] = [
            theme.siteWidth.values[.small] ?? Bootstrap.smallContainer,
            theme.siteWidth.values[.medium] ?? Bootstrap.mediumContainer,
            theme.siteWidth.values[.large] ?? Bootstrap.largeContainer,
            theme.siteWidth.values[.xLarge] ?? Bootstrap.xLargeContainer,
            theme.siteWidth.values[.xxLarge] ?? Bootstrap.xxLargeContainer
        ]

        return breakpoints.map { minWidth in
            MediaQuery(.breakpoint(.custom(minWidth))) {
                Ruleset(.attribute("data-bs-theme", value: theme.cssID), .class("container")) {
                    InlineStyle(.maxWidth, value: "\(minWidth)")
                }
            }
        }
    }
}

private extension Site {
    var supportsLightTheme: Bool {
        lightTheme != nil
    }

    var supportsDarkTheme: Bool {
        darkTheme != nil
    }

    var hasMultipleThemes: Bool {
        (supportsLightTheme && supportsDarkTheme) ||
        !alternateThemes.isEmpty
    }
}

private extension Theme {
    var isDefaultLightTheme: Bool {
        self is DefaultLightTheme
    }

    var isDefaultDarkTheme: Bool {
        self is DefaultDarkTheme
    }
}
