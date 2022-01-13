//
//  Chart+XT.swift
//  FLCharts
//
//  Created by Francesco Leoni on 09/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

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


extension String {
    func size(withSystemFontSize pointSize: CGFloat) -> CGSize {
        return (self as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: pointSize)])
    }
}

extension UIView {
    
    static func animateContraints(for view: UIView, damping: CGFloat, response: CGFloat, delay: TimeInterval = 0) {
        UIView.animate(damping: 0.6, response: 0.7) {
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
