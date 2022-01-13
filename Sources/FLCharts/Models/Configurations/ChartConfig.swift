//
//  ChartConfig.swift
//  FLCharts
//
//  Created by Francesco Leoni on 09/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

/// Defines the configuration of the chart.
/// You can assign a new configurations through the chart property ``FLBarChart/config`` or modifing the subproperties. Eg. `chart.config.dashedLines.color = .darkGray`.
///
/// - note: The order in which you modify this properties matter. Eg. if you assign a new ``FLBarChart/config`` and then modify the property ``ChartConfig/axesLineWidth``, this will override the `lineWidth` property of ``FLAxisLineConfig`` and ``FLTickConfig``.
/// Conversly if you modify the ``ChartConfig/axesLineWidth`` first and then assign a new ``FLAxisLineConfig``, the latter will override ``ChartConfig/axesLineWidth``.
public struct ChartConfig {
        
    let margin: UIOffset = UIOffset(horizontal: 45, vertical: 20)

    /// The granularity of the X axis.
    public var deltaX: Int
    
    /// The granularity of the Y axis.
    /// Eg. deltaY = 100 means that every number on the Y axes is a multiple of 100.
    public var deltaY: CGFloat
    
    /// The configuration of the bars.
    public var bar: FLBarConfig

    /// The configuration of the axes ticks.
    public var tick: FLTickConfig
        
    /// The configuration of the axes labels.
    public var axesLabels: FLAxisLabelConfig

    /// The configuration of the axes lines.
    public var axesLines: FLAxisLineConfig

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
    public var axesColor: UIColor = FLColors.darkGray {
        didSet {
            tick.color = axesColor
            axesLines.color = axesColor
            axesLabels.color = axesColor
        }
    }
            
    public init(deltaX: Int = 3,
                deltaY: CGFloat = 100,
                bar: FLBarConfig = FLBarConfig(),
                tick: FLTickConfig = FLTickConfig(),
                axesLabels: FLAxisLabelConfig = FLAxisLabelConfig(),
                axesLines: FLAxisLineConfig = FLAxisLineConfig(),
                dashedLines: FLDashedLineConfig = FLDashedLineConfig(),
                averageView: FLAverageViewConfig = FLAverageViewConfig(),
                axesLineWidth: CGFloat = 1,
                axesColor: UIColor = FLColors.darkGray) {
        self.deltaX = deltaX
        self.deltaY = deltaY
        self.bar = bar
        self.tick = tick
        self.axesLabels = axesLabels
        self.axesLines = axesLines
        self.dashedLines = dashedLines
        self.averageView = averageView
        self.axesLineWidth = axesLineWidth
        self.axesColor = axesColor
    }
}
