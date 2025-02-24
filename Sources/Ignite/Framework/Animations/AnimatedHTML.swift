//
// AnimatedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private typealias AnimationInfo = [AnimationTrigger: [any Animatable]]

struct AnimatedHTML: HTML {
    /// The content and behavior of this HTML.
    var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    var isPrimitive: Bool { true }

    /// The content to place inside the text.
    var content: any HTML

    /// The animations applied to this element.
    private var animations = AnimationInfo()

    /// Creates a section that renders as a `div` element.
    /// - Parameter content: The content to display within this section.
    init(_ content: any HTML, animation: any Animatable, trigger: AnimationTrigger) {
        if let animatedContent = content as? AnimatedHTML {
            self.attributes.merge(animatedContent.attributes)
            self.animations = animatedContent.animations
            self.content = animatedContent.content
        } else {
            self.content = content
        }
        self.animations[trigger, default: []].append(animation)
    }

    func render() -> String {
        // Extract color styles from the element so that we can later
        // transplant them to a place in the div hierarchy that won't conflict with animations
        let baseStyles = content.attributes.get(styles: .background, .backgroundColor, .color)
        let registeredAnimations = registerAnimations()

        var innerAttributes = CoreAttributes()
        innerAttributes.add(styles: baseStyles)

        var outerAttributes = CoreAttributes()

        assignClickClasses(outer: &outerAttributes, inner: &innerAttributes)
        assignHoverClass(&innerAttributes)
        assignAppearClasses(&innerAttributes)

        var content: any HTML = content
        content.attributes.remove(styles: .background, .backgroundColor, .color)

        if innerAttributes.isEmpty == false {
            content = Section(content).attributes(innerAttributes)
        }

        if outerAttributes.isEmpty == false {
            content = Section(content).attributes(outerAttributes)
        }

        return content.attributes(attributes).render()

        func assignAppearClasses(_ attributes: inout CoreAttributes) {
            guard let appearAnimations = registeredAnimations[.appear] else { return }
            let animationClasses = Set(appearAnimations.map { "animation-\($0.id)" })
            let newClasses = animationClasses.subtracting(outerAttributes.classes)
            attributes.add(classes: newClasses)
        }

        func assignClickClasses(outer outerAttr: inout CoreAttributes, inner innerAttr: inout CoreAttributes) {
            guard let clickAnimations = registeredAnimations[.click] else { return }
            innerAttr.add(classes: clickAnimations.map { "click-\($0.id)" })
            outerAttr.add(classes: clickAnimations.map { "animation-\($0.id)" })
            let clickEvent = Event(.click, actions: [CustomAction("igniteToggleClickAnimation(this)")])
            outerAttr.events.insert(clickEvent)
        }

        func assignHoverClass(_ attributes: inout CoreAttributes) {
            guard let hoverAnimations = registeredAnimations[.hover] else { return }
            attributes.add(styles: .init(.transformStyle, value: "preserve-3d"))
            attributes.add(classes: hoverAnimations.map { "animation-\($0.id)-hover" })

            let classes = hoverAnimations.compactMap { $0 as? Animation }.compactMap {
                if $0.fillMode == .backwards || $0.fillMode == .both {
                    return "fill-\($0.id)-\($0.fillMode.rawValue)"
                }
                return nil
            }

            attributes.add(classes: classes)
        }
    }

    /// Registers each of the element's animations and returns their class names by trigger
    private func registerAnimations() -> AnimationInfo {
        var finalAnimations = AnimationInfo()
        for trigger in AnimationTrigger.allCases {
            guard let triggerAnimation = animations[trigger] else { continue }
            let animations = triggerAnimation.compactMap { $0 as? Animation }
            let transitions = triggerAnimation.compactMap { $0 as? Transition }

            if transitions.isEmpty == false {
                var aggreateTransition = Transition()
                aggreateTransition.data = transitions.flatMap(\.data)
                AnimationManager.default.register(aggreateTransition, for: trigger)
                finalAnimations[trigger, default: []].append(aggreateTransition)
            }

            if animations.isEmpty == false {
                var aggreateAnimation = Animation()
                aggreateAnimation.direction = animations.last?.direction ?? .automatic
                aggreateAnimation.frames = animations.flatMap(\.frames)
                AnimationManager.default.register(aggreateAnimation, for: trigger)
                finalAnimations[trigger, default: []].append(aggreateAnimation)
            }
        }
        return finalAnimations
    }
}
