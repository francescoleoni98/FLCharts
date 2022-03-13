//
//  FLChartConfig.swift
//  FLCharts
//
//  Created by Francesco Leoni on 09/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

/// Defines the configuration of the chart.
/// You can assign a new configurations through the chart property ``FLChart/config`` or modifing the subproperties. Eg. `chart.config.dashedLines.color = .darkGray`.
///
/// - note: The order in which you modify this properties matter. Eg. if you assign a new ``FLChart/config`` and then modify the property ``FLChartConfig/axesLineWidth``, this will override the `lineWidth` property of ``FLAxisLineConfig`` and ``FLTickConfig``.
/// Conversly if you modify the ``FLChartConfig/axesLineWidth`` first and then assign a new ``FLAxisLineConfig``, the latter will override ``FLChartConfig/axesLineWidth``.
public class FLChartConfig {
        
    internal private(set) var margin: UIEdgeInsets = UIEdgeInsets(top: 5, left: 45, bottom: 25, right: 0)

    /// The granularity of the X axis.
    public var granularityX: Int
    
    /// The granularity of the Y axis.
    /// Eg. granularityY = 100 means that every number on the Y axes is a multiple of 100.
    public var granularityY: CGFloat
    
    /// The configuration of the axes ticks.
    public var tick: FLTickConfig
        
    /// The configuration of the axes labels.
    public var axesLabels: FLAxesLabelConfig

    /// The configuration of the axes lines.
    public var axesLines: FLAxesLineConfig

    /// The configuration of the value dashed lines.
    public var dashedLines: FLDashedLineConfig

    /// The configuration of the average view.
    public var averageView: FLAverageViewConfig

    /// The width of the axes lines and ticks.
    /// - note: If used after setting ``FLAxisLineConfig`` and ``FLTickConfig``, this will override their relative property.
    public var axesLineWidth: CGFloat = 1 {
        didSet {
            tick.lineWidth = axesLineWidth
            axesLines.lineWidth = axesLineWidth
        }
    }
    
    /// The color of the axes lines and ticks.
    /// - note: If used after setting ``FLAxisLabelConfig``, ``FLAxisLineConfig`` and ``FLTickConfig``, this will override their relative property.
    public var axesColor: UIColor = FLColor.darkGray {
        didSet {
            tick.color = axesColor
            axesLines.color = axesColor
            axesLabels.color = axesColor
        }
    }
            
    public init(granularityX: Int = 3,
                granularityY: CGFloat = 0,
                tick: FLTickConfig = FLTickConfig(),
                axesLabels: FLAxesLabelConfig = FLAxesLabelConfig(),
                axesLines: FLAxesLineConfig = FLAxesLineConfig(),
                dashedLines: FLDashedLineConfig = FLDashedLineConfig(),
                averageView: FLAverageViewConfig = FLAverageViewConfig(),
                axesLineWidth: CGFloat = 1,
                axesColor: UIColor = FLColor.darkGray) {
        self.granularityX = granularityX
        self.granularityY = granularityY
        self.tick = tick
        self.axesLabels = axesLabels
        self.axesLines = axesLines
        self.dashedLines = dashedLines
        self.averageView = averageView
        self.axesLineWidth = axesLineWidth
        self.axesColor = axesColor
    }
    
    // MARK: - Internal methods
    
    func setMarginTop(to value: CGFloat) {
        margin.top += value
    }

    func setMarginBottom(to value: CGFloat) {
        margin.bottom += value
    }
        
    func setMargin(for yPosition: YPosition, horizontalMargin: CGFloat) {
        switch yPosition {
        case .left:
            margin.left = horizontalMargin
            margin.right = 0
            
        case .right:
            margin.left = 0
            margin.right = horizontalMargin
        }
    }
    
    func resetDefaultMargins() {
        margin.top = 5
        margin.left = 45
        margin.bottom = 25
        margin.right = 0
    }
}
