//
//  FLDashedLineConfig.swift
//  FLCharts
//
//  Created by Francesco Leoni on 13/01/22.
//

import UIKit

public struct FLDashedLineConfig {
    
    /// The color of the dashed lines.
    public var color: UIColor
    
    /// The width of the dashed lines.
    public var lineWidth: CGFloat
    
    /// The width of each dash.
    public var dashWidth: CGFloat
    
    public init(color: UIColor = FLColor.darkGray, lineWidth: CGFloat = 1, dashWidth: CGFloat = 3) {
        self.color = color
        self.lineWidth = lineWidth
        self.dashWidth = dashWidth
    }
}
