//
//  FLAxesLineConfig.swift
//  FLCharts
//
//  Created by Francesco Leoni on 13/01/22.
//

import UIKit

public struct FLAxesLineConfig {
    
    /// The color of the axes.
    public var color: UIColor = FLColors.darkGray
    
    /// The width of the axes.
    public var lineWidth: CGFloat = 1
    
    public init(color: UIColor = FLColors.darkGray, lineWidth: CGFloat = 1) {
        self.color = color
        self.lineWidth = lineWidth
    }
}
