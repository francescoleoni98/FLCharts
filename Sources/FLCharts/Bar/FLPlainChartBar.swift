//
//  FLPlainChartBar.swift
//  FLCharts
//
//  Created by Francesco Leoni on 12/01/22.
//

import UIKit

/// A plain chart bar.
public final class FLPlainChartBar: UIView, ChartBar {
    
    public var config: FLChartConfig?
    public var barConfig: FLBarConfig?
    
    public var horizontalRepresentedValues: Bool = false

    public func configureViews() { }
    
    public func configureBar(for barHeight: CGFloat, chartData: FLChartData, barData: PlotableData, legendKeys: [Key]) {
        backgroundColor = legendKeys.first?.color.mainColor
    }
}
