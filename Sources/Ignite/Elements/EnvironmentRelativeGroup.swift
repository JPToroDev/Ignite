//
// EnvironmentRelativeGroup.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public struct EnvironmentRelativeGroup<T: Environment.MediaQueryValue>: BlockElement {
    public var columnWidth: ColumnWidth = .automatic
    private let content: [BlockElement]
    private let expectedValue: T
    public var attributes: CoreAttributes = CoreAttributes()
    
    public init(_ type: T.Type, equals value: T, @BlockElementBuilder content: () -> [BlockElement]) {
        self.content = content()
        self.expectedValue = value
    }
    
    public func render(context: PublishingContext) -> String {
        var output = "<div class=\"\(expectedValue.cssClass)\">"
        output += content.map { $0.render(context: context) }.joined()
        output += "</div>"
        return output
    }
}
