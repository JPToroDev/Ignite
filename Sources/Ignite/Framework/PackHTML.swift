//
// PackHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
struct PackHTML<each Content>: Sendable {

    var attributes = CoreAttributes()

    var content: (repeat each Content)

    init(_ content: repeat each Content) {
        self.content = (repeat each content)
    }
}

extension PackHTML: HTML, SubviewsProvider, VariadicHTML where repeat each Content: HTML {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }
    
    var subviews: SubviewsCollection {
        var children = SubviewsCollection()
        for element in repeat each content {
            // Using the attributes() modifier will change the type to ModifiedHTML,
            // so to keep the type info, we'll modify the attributes directly
            var child = Subview(element)
            child.attributes.merge(attributes)
            children.elements.append(child)
        }
        return children
    }

    func render() -> Markup {
        subviews.map { $0.render() }.joined()
    }
}

extension PackHTML: InlineElement, InlineSubviewsProvider, CustomStringConvertible where repeat each Content: InlineElement {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    var children: InlineSubviewsCollection {
        var children = InlineSubviewsCollection()
        for element in repeat each content {
            var child = InlineSubview(element)
            child.attributes.merge(attributes)
            children.elements.append(child)
        }
        return children
    }

    func render() -> Markup {
        children.map { $0.render() }.joined()
    }
}

extension PackHTML: NavigationElement, NavigationSubviewsProvider where repeat each Content: NavigationElement {

    var children: NavigationSubviewsCollection {
        var children = NavigationSubviewsCollection()
        for element in repeat each content {
            var child = NavigationSubview(element)
            child.attributes.merge(attributes)
            children.elements.append(child)
        }
        return children
    }
    
    func render() -> Markup {
        // This method is required by NavigationElement, but we'll always
        // deconstruct PackHTML before rendering it.
        fatalError("Please file a bug report with the Ignite project.")
    }
}

extension PackHTML: AccordionElement, AccordionSubviewsProvider where repeat each Content: AccordionElement {
    var children: AccordionSubviewsCollection {
        var children = AccordionSubviewsCollection()
        for element in repeat each content {
            var child = AccordionSubview(element)
            child.attributes.merge(attributes)
            children.elements.append(child)
        }
        return children
    }

    func render() -> Markup {
        // This method is required by AccordionElement, but we'll always
        // deconstruct PackHTML before rendering it.
        fatalError("Please file a bug report with the Ignite project.")
    }
}

extension PackHTML: ButtonElement where repeat each Content: ButtonElement {
    func render() -> Markup {
        var markup = Markup()
        for var element in repeat each content {
            element.attributes.merge(attributes)
            markup += element.render()
        }
        return markup
    }
}

extension PackHTML: TableRowElement where repeat each Content: TableRowElement {
    func render() -> Markup {
        var markup = Markup()
        for var element in repeat each content {
            element.attributes.merge(attributes)
            markup += element.render()
        }
        return markup
    }
}

extension PackHTML: CarouselElement, CarouselSubviewsProvider where repeat each Content: CarouselElement {
    var children: CarouselSubviewsCollection {
        var children = CarouselSubviewsCollection()
        for element in repeat each content {
            var child = CarouselSubview(element)
            child.attributes.merge(attributes)
            children.elements.append(child)
        }
        return children
    }

    func render() -> Markup {
        // This method is required by CarouselElement, but we'll always
        // deconstruct PackHTML before rendering it.
        fatalError("Please file a bug report with the Ignite project.")
    }
}

extension PackHTML: ControlGroupElement, FormSubviewsProvider where repeat each Content: ControlGroupElement {
    var children: ControlGroupSubviewsCollection {
        var children = ControlGroupSubviewsCollection()
        for element in repeat each content {
            var child = ControlGroupSubview(element)
            child.attributes.merge(attributes)
            children.elements.append(child)
        }
        return children
    }

    func render() -> Markup {
        // This method is required by CarouselElement, but we'll always
        // deconstruct PackHTML before rendering it.
        fatalError("Please file a bug report with the Ignite project.")
    }
}

extension PackHTML: DropdownElement where repeat each Content: DropdownElement {
    func render() -> Markup {
        var markup = Markup()
        for var element in repeat each content {
            element.attributes.merge(attributes)
            if let element = element as? any DropdownElementRepresentable {
                markup += element.renderAsDropdownElement()
            } else {
                markup += element.render()
            }
        }
        return markup
    }
}
