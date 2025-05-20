//
// NavigationChildren.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

//struct NavigationChildren: HTML, @preconcurrency Sequence {
//    var body: some HTML { fatalError() }
//
//    var attributes = CoreAttributes()
//
//    var children = [NavigationItem]()
//
//    init(_ children: [NavigationItem] = []) {
//        self.children = children
//    }
//
//    init(_ child: NavigationItem) {
//        self.children = [child]
//    }
//
//    init(_ content: any NavigationElement) {
//        if let variad = content as? any VariadicNavigationContent {
//            self.children = variad.children.map(\.self)
//        } else {
//            self.children = [NavigationItem(content)]
//        }
//    }
//
//    /// Creates an iterator over the sequence's elements
//    /// - Returns: An iterator that provides access to each HTML element
//    func makeIterator() -> IndexingIterator<[NavigationItem]> {
//        children.map {
//            var child = $0
//            child.attributes.merge(attributes)
//            return child
//        }.makeIterator()
//    }
//
//    func markup() -> Markup {
//        children.map {
//            var child = $0
//            child.attributes.merge(attributes)
//            return child.markup()
//        }.joined()
//    }
//}
