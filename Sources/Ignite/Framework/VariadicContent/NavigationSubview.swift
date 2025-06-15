//
// NavigationHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct NavigationSubview: HTML {
    var body: Never { fatalError() }
    
    var attributes = CoreAttributes()
   
    var content: any NavigationElement

    var navigationBarVisibility: NavigationBarVisibility = .automatic
    
    init(_ content: any NavigationElement) {
        self.content = content

        if let provider = content as? any NavigationBarVisibilityProvider {
            self.navigationBarVisibility = provider.navigationBarVisibility
        }
    }
    
    func render() -> Markup {
        var content = content
        content.attributes.merge(attributes)

        return if let element = content as? any NavigationElementRepresentable {
            element.renderAsNavigationElement()
        } else {
            content.render()
        }
    }
}
