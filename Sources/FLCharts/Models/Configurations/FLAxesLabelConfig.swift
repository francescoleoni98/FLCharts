//
//  FLAxesLabelConfig.swift
//  FLCharts
//
//  Created by Francesco Leoni on 13/01/22.
//

import UIKit

public struct FLAxesLabelConfig {
    
    /// The color of the axes labels.
    public var color: UIColor = FLColor.darkGray
    
    /// The font of the axes label.
    public var font: UIFont = .preferredFont(for: .footnote, weight: .regular)
    
    public init(color: UIColor = FLColor.darkGray, font: UIFont = .preferredFont(for: .footnote, weight: .regular)) {
        self.color = color
        self.font = font
    }
}
