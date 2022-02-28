//
//  FLAverageViewConfig.swift
//  FLCharts
//
//  Created by Francesco Leoni on 13/01/22.
//

import UIKit

public struct FLAverageViewConfig {
    
    /// The width of the average line.
    public var lineWidth: CGFloat
    
    /// The color of the average line.
    public var lineColor: UIColor

    /// The font of the value label.
    public var primaryFont: UIFont
    
    /// The font of the unit of measure label.
    public var secondaryFont: UIFont
    
    /// The color of the value label.
    public var primaryColor: UIColor
    
    /// The color of the unit of measure label.
    public var secondaryColor: UIColor
    
    public init(lineWidth: CGFloat = 2,
                primaryFont: UIFont = .preferredFont(for: .subheadline, weight: .semibold),
                secondaryFont: UIFont = .preferredFont(for: .footnote, weight: .medium),
                primaryColor: UIColor = FLColor.black,
                secondaryColor: UIColor = FLColor.darkGray,
                lineColor: UIColor = FLColor.darkGray) {
        self.lineWidth = lineWidth
        self.primaryFont = primaryFont
        self.secondaryFont = secondaryFont
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.lineColor = lineColor
    }
}
