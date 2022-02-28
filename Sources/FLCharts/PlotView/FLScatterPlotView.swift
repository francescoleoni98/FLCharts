//
//  FLScatterPlotView.swift
//  FLCharts
//
//  Created by Francesco Leoni on 28/01/22.
//

import UIKit

public struct ScatterPlotable: PlotableData {
    
    public var name: String
    public var values: [CGFloat]
    
    var xValue: CGFloat
    var yValue: CGFloat
    
    public init(x: CGFloat, y: CGFloat) {
        self.name = "\(x)"
        self.values = [y]
        self.xValue = x
        self.yValue = y
    }
}

internal final class FLScatterPlotView: UIView, FLPlotView {
    
    private var chartData: FLChartData
    
    internal var config: FLChartConfig = FLChartConfig()
    
    internal var dotDiameter: CGFloat = 6
    
    internal weak var highlightingDelegate: ChartHighlightingDelegate?
    
    internal init(data: FLChartData) {
        self.chartData = data
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func updateData(_ data: [PlotableData]) {
        self.chartData.dataEntries = data
        self.setNeedsDisplay()
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    internal override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let data = chartData.dataEntries as? [ScatterPlotable] else {
            fatalError("Trying to instanciate a ScatterPlotView but the chart data passed are not 'ScatterPlotable'.")
        }
        
        guard let context = UIGraphicsGetCurrentContext(),
              let maxYValue = chartData.maxYValue(forType: .scatter()),
              let maxXValue = data.maxFor(\.xValue) else { return }
                        
        let chartWidth = frame.width
        let chartHeight = frame.height - config.margin.bottom
        
        let maxX = maxXValue + (maxXValue * 0.1)
        let maxY = maxYValue + (maxYValue * 0.1)
        
        context.setFillColor(chartData.legendKeys.first?.color.mainColor.cgColor ?? UIColor.blue.cgColor)
        
        let points = data.map { entry -> CGPoint in
            let x = chartWidth * (entry.xValue / maxX)
            let y = chartHeight - (chartHeight * (entry.yValue / maxY))
            return CGPoint(x: x, y: y)
        }
        
        let aggregations = Aggregator(points: points).aggregate(diameter: dotDiameter)
        
        for (point, numberOfAggregations) in aggregations {
            let diameter = CGFloat(numberOfAggregations) * dotDiameter
            let circleRadius = diameter.half
            
            context.addEllipse(in: CGRect(x: point.x - circleRadius, y: point.y - circleRadius,
                                          width: diameter, height: diameter))
        }
        
        context.fillPath()
    }
}
