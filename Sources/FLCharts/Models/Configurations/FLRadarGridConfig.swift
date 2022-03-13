//
//  FLRadarGridConfig.swift
//  FLCharts
//
//  Created by Francesco Leoni on 13/03/22.
//

import UIKit

public struct FLRadarGridConfig {
    
    /// The number of divisions of the grid.
    public var divisions: Int

    /// The color of the tick lines.
    public var color: UIColor

    /// The width of the tick lines.
    public var lineWidth: CGFloat
    
    /// The font of the labels.
    public var labelsFont: UIFont
    
    /// The color of the labels.
    public var labelsColor: UIColor

    public init(divisions: Int = 3, color: UIColor = FLColor.mediumGray.mainColor, lineWidth: CGFloat = 1, labelsFont: UIFont = .systemFont(ofSize: 10), labelsColor: UIColor = FLColor.black) {
        self.divisions = divisions
        self.color = color
        self.lineWidth = lineWidth
        self.labelsFont = labelsFont
        self.labelsColor = labelsColor
    }
}
