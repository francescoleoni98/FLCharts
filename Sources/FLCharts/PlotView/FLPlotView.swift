//
//  FLPlotView.swift
//  FLCharts
//
//  Created by Francesco Leoni on 18/01/22.
//

import UIKit

/// A `UIView` that can display a plotable chart.
internal protocol FLPlotView: UIView, FLStylable {
    
    var highlightingDelegate: ChartHighlightingDelegate? { get set }
    
    var minPlotYValue: CGFloat { get set }
    var maxPlotYValue: CGFloat? { get set }
    
    /// Updates the chart with the new data.
    func updateData(_ data: [PlotableData])
}
