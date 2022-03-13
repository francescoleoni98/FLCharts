//
//  FLShadow.swift
//  FLCharts
//
//  Created by Francesco Leoni on 13/01/22.
//

import UIKit

/// Creates a custom shadow layer.
///
/// By default it is applied to the primary button.
///
/// You can create a shadow using the custom initializer:
///
/// ```swift
/// let shadow = ABTShadow(color: .black,
///                        radius: 10,
///                        opacity: 0.2,
///                        offset: .zero)
/// ```
///
/// And apply it using the ``apply(to:)`` method.
///
/// ```swift
/// shadow.apply(to: targetView)
/// ```
public struct FLShadow {
    
    /// The color of the layer’s shadow.
    public let color: UIColor
    
    /// The blur radius (in points) used to render the layer’s shadow.
    public let radius: CGFloat
    
    /// The opacity of the layer’s shadow.
    public let opacity: Float
    
    /// The offset (in points) of the layer’s shadow.
    public let offset: CGSize
    
    /// Initializes the custom shadow.
    public init(color: UIColor, radius: CGFloat, opacity: Float, offset: CGSize = .zero) {
        self.color = color
        self.radius = radius
        self.opacity = opacity
        self.offset = offset
    }
    
    /// Add an ``FLShadow`` to a specifc `UIView`.
    /// - Parameter view: The view to which apply the shadow.
    public func apply(to view: UIView) {
        view.layer.shadowColor = color.cgColor
        view.layer.shadowRadius = radius
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = offset
    }
}

public extension FLShadow {
    
    static let basic = FLShadow(color: .black, radius: 10, opacity: 0.1)
}
