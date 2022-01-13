//
//  FLAxisLabelConfig.swift
//  FLCharts
//
//  Created by Francesco Leoni on 13/01/22.
//

import UIKit

public struct FLAxisLabelConfig {
    
    /// The color of the axes labels.
    public var color: UIColor = FLColors.darkGray
    
    /// The font of the axes label.
    public var font: UIFont = .preferredFont(for: .footnote, weight: .regular)
    
    public init(color: UIColor = FLColors.darkGray, font: UIFont = .preferredFont(for: .footnote, weight: .regular)) {
        self.color = color
        self.font = font
    }
}
