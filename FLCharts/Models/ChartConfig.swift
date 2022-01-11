//
//  ChartConfig.swift
//  FLCharts
//
//  Created by Francesco Leoni on 09/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

public struct ChartConfig {
    
    public enum Radius {
        
        case none
        
        /// Rounds up the shorter side of the bar.
        case capsule
        
        /// Applies the specified radius to the bar.
        case custom(CGFloat)
        
        /// Applies the specified radius to the given corners of the bar.
        case corners(corners: CACornerMask, CGFloat)
    }
    
    let margin: UIOffset = UIOffset(horizontal: 45, vertical: 20)

    /// The granularity of the X axis.
    public var deltaX: Int = 3
    
    /// The granularity of the Y axis.
    /// Eg. deltaY = 100 means that every number on the Y axes is a multiple of 100.
    public var deltaY: CGFloat = 100
    
    /// The height of the ticks.
    public var ticksHeight: CGFloat = 5
    
    /// The width of the axes lines.
    public var axesLineWidth: CGFloat = 1
    
    /// The color of the axes lines.
    public var axesColor: UIColor = UIColor(white: 0.75, alpha: 1)

    /// The color of the average line and label.
    public var averageViewColor: UIColor = UIColor(white: 0.7, alpha: 1)
    
    /// The color of the bars. The first color corrisponds to to bottom portion of the bar.
    public var barColors: [UIColor] = [.systemBlue, .systemPink, .systemGreen]

    /// The style of the bars corners.
    public var barRadius: Radius = .corners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], 3)

    /// The width of the bar.
    /// - note: This value will be used only if ``FLBarChart/shouldScroll`` is set to `true`. Else the width of the bar will be calculated based on the width of the chart.
    public var barWidth: CGFloat = 12
    
    /// The space between each chart bar.
    public var barSpacing: CGFloat = 5
    
    /// Whether the chart should show the ticks on the axes.
    var showTicks: Bool = true
    
    public init(deltaX: Int = 3,
                deltaY: CGFloat = 100,
                ticksHeight: CGFloat = 5,
                axesLineWidth: CGFloat = 1,
                axesColor: UIColor = UIColor(white: 0.75, alpha: 1),
                averageViewColor: UIColor = UIColor(white: 0.7, alpha: 1),
                barColors: [UIColor] = [.systemBlue, .systemPink, .systemGreen],
                barRadius: ChartConfig.Radius = .corners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], 3),
                barWidth: CGFloat = 12,
                barSpacing: CGFloat = 5) {
        self.deltaX = deltaX
        self.deltaY = deltaY
        self.ticksHeight = ticksHeight
        self.axesLineWidth = axesLineWidth
        self.axesColor = axesColor
        self.averageViewColor = averageViewColor
        self.barColors = barColors
        self.barRadius = barRadius
        self.barWidth = barWidth
        self.barSpacing = barSpacing
    }
}
