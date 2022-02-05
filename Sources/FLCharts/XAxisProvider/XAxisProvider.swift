//
//  XAxisProvider.swift
//  FLCharts
//
//  Created by Francesco Leoni on 04/02/22.
//

import UIKit

protocol XAxisProvider {
    
    var xPositions: [CGFloat] { get set }
    var labels: [Label] { get set }
    
    var chartData: FLChartData { get }
    var config: FLChartConfig { get }
    var chartRect: CGRect { get }
    
    init(data: FLChartData, config: FLChartConfig, chartRect: CGRect)
}

extension XAxisProvider {
    var chartLeft: CGFloat { chartRect.minX }
    var chartBottom: CGFloat { chartRect.maxY }
    var chartWidth: CGFloat { chartRect.width }
}
