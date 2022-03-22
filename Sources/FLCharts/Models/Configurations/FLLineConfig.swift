//
//  FLLineConfig.swift
//  FLCharts
//
//  Created by Francesco Leoni on 21/01/22.
//

import UIKit

public struct FLLineConfig {

    /// The width of the line.
    public var width: CGFloat

    /// The cap style of the line.
    public var capStyle: CGLineCap
    
    /// The background fill of the line chart.
    /// - note: The background fill will be applied only for ``SinglePlotable`` charts.
    public var backgroundFill: FLColor?

    /// Whether to show a circle that represents a specific point.
    public var showCircles: Bool
    
    /// Whether to show a smooth quadratic line or a segmented one.
    public var isSmooth: Bool

    /// The configuration of the circles.
    public var circleColor: UIColor
    
    public init(width: CGFloat = 4, capStyle: CGLineCap = .round, backgroundFill: FLColor? = FLColor.Gradient.lightBlue, showCircles: Bool = false, isSmooth: Bool = true, circleColor: UIColor = .white) {
        self.width = width
        self.capStyle = capStyle
        self.showCircles = showCircles
        self.circleColor = circleColor
        self.isSmooth = isSmooth
        self.backgroundFill = backgroundFill
    }
}
