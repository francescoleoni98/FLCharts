//
//  FLTickConfig.swift
//  FLCharts
//
//  Created by Francesco Leoni on 13/01/22.
//

import UIKit

public struct FLTickConfig {
    
    /// The color of the tick lines.
    public var color: UIColor

    /// The height of the ticks.
    public var lineLength: CGFloat

    /// The width of the tick lines.
    public var lineWidth: CGFloat
    
    public init(color: UIColor = FLColor.darkGray, lineWidth: CGFloat = 1, lineLength: CGFloat = 5) {
        self.color = color
        self.lineWidth = lineWidth
        self.lineLength = lineLength
    }
}
