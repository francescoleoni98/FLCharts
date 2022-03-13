//
//  Chart+XT.swift
//  FLCharts
//
//  Created by Francesco Leoni on 09/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

extension RangeReplaceableCollection where Element: Equatable {
    
    @discardableResult
    mutating func remove(object element: Element) -> Element? {
        if let index = firstIndex(of: element) {
            return remove(at: index)
        }
        return nil
    }
    
    @discardableResult
    mutating func remove(objects elements: [Element]) -> [Element] {
        var removedObjects: [Element] = []
        
        for element in elements {
            if let index = firstIndex(of: element) {
                removedObjects.append(remove(at: index))
            }
        }
        
        return removedObjects
    }
}

extension Sequence {
    func maxFor<T: Comparable>(_ keyPath: KeyPath<Element, T>) -> T? {
        self.max { first, second in
            first[keyPath: keyPath] < second[keyPath: keyPath]
        }?[keyPath: keyPath]
    }
}

public extension CGFloat {

    var half: CGFloat {
        self / 2
    }
    
    static func degrees(_ degrees: CGFloat) -> CGFloat {
        degrees * .pi / 180
    }
}

public extension Int {

    var cgFloat: CGFloat {
        CGFloat(self)
    }
}

public extension UIFont {
    
    static func preferredFont(for style: TextStyle, weight: Weight, italic: Bool = false) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
            .addingAttributes([.traits : [UIFontDescriptor.TraitKey.weight : weight]])

        var font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)
        if italic {
            font = font.with([.traitItalic])
        }

        let metrics = UIFontMetrics(forTextStyle: style)
        return metrics.scaledFont(for: font)
    }
    
    private func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}

public extension UIViewController {
    
    func runOnMain(after interval: TimeInterval, execute work: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: work)
    }
}

extension String {
    func size(withSystemFontSize pointSize: CGFloat) -> CGSize {
        return (self as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: pointSize)])
    }
}

extension UIView {
    
    var intrinsicWidth: CGFloat {
        intrinsicContentSize.width
    }
    
    var intrinsicHeight: CGFloat {
        intrinsicContentSize.height
    }
    
    static func quickAnimation(_ animations: @escaping () -> Void) {
        animate(withDuration: 0.25, animations: animations)
    }
    
    static func animateContraints(for view: UIView, damping: CGFloat, response: CGFloat, delay: TimeInterval = 0) {
        animate(damping: 0.6, response: 0.7) {
            view.layoutIfNeeded()
        }
    }
    
    static func animate(damping: CGFloat, response: CGFloat, delay: TimeInterval = 0, animations: @escaping () -> Void, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        var animator = UIViewPropertyAnimator()
        let timingParameters = UISpringTimingParameters(damping: damping, response: response)
        animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
        animator.addAnimations(animations)
        if let completion = completion {
            animator.addCompletion(completion)
        }
        animator.startAnimation(afterDelay: delay)
    }
}

extension UISpringTimingParameters {
    
    /// A design-friendly way to create a spring timing curve.
    ///
    /// - Parameters:
    ///   - damping: The 'bounciness' of the animation. Value must be between 0 and 1.
    ///   - response: The 'speed' of the animation.
    ///   - initialVelocity: The vector describing the starting motion of the property. Optional, default is `.zero`.
    public convenience init(damping: CGFloat, response: CGFloat, initialVelocity: CGVector = .zero) {
        let stiffness = pow(2 * .pi / response, 2)
        let damp = 4 * .pi * damping / response
        self.init(mass: 1, stiffness: stiffness, damping: damp, initialVelocity: initialVelocity)
    }
}
