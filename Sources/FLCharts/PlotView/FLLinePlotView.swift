//
//  FLLinePlotView.swift
//  FLCharts
//
//  Created by Francesco Leoni on 18/01/22.
//

import UIKit

internal final class FLLinePlotView: UIView, FLPlotView {
    
    private var chartData: FLChartData
    
    internal var config: FLChartConfig = FLChartConfig()
    
    internal var lineConfig: FLLineConfig = FLLineConfig()
    
    internal var minPlotYValue: CGFloat = 0
    
    internal var maxPlotYValue: CGFloat?

    internal weak var highlightingDelegate: ChartHighlightingDelegate?
    
    // MARK: - Drawing properties
    
    var context: CGContext!
    var maxEntry: CGFloat = 0
    var valuesCount: Int = 0
    
    var lineWidth: CGFloat = 0
    var halfLineWidth: CGFloat = 0
    
    var chartWidth: CGFloat = 0
    var chartHeight: CGFloat = 0
    
    // MARK: - Init
    
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
        
        if let context = UIGraphicsGetCurrentContext(),
           let maxEntry = chartData.maxYValue(forType: .line()) {
            self.context = context
            self.maxEntry = maxEntry
            self.valuesCount = chartData.numberOfValues
            
            self.lineWidth = lineConfig.width
            self.halfLineWidth = lineWidth.half
            
            self.chartWidth = frame.width
            self.chartHeight = frame.height - config.margin.bottom - halfLineWidth
            
            drawChartFillIfNeeded()
            drawChartLines()
        }
    }
    
    func drawChartFillIfNeeded() {
        if valuesCount == 1, let backgroundFill = lineConfig.backgroundFill {
            let fillPath = createPath(inSize: CGSize(width: chartWidth, height: chartHeight))
            fillPath.addLine(to: CGPoint(x: chartWidth, y: chartHeight + halfLineWidth))
            fillPath.addLine(to: CGPoint(x: 0, y: chartHeight + halfLineWidth))
            fillPath.close()
            
            drawGradient(path: fillPath.cgPath, colors: backgroundFill.colors, isVertical: true, isStroke: false)
        }
    }
    
    func drawChartLines() {
        for (prev, sec) in zip(chartData.dataEntries, chartData.dataEntries.dropFirst()) {
            guard prev.values.count == sec.values.count else {
                preconditionFailure("The number of values is not homogenous. Every PlotableData must have the same number of values.")
            }
        }
        
        // Inset chart size by line width to keep the caps inside of the bounds
        chartWidth -= lineWidth
        chartHeight -= halfLineWidth
        
        context.setLineWidth(lineWidth)
        context.setLineCap(lineConfig.capStyle)
        context.setLineJoin(.round)
        
        let dotSpacing = chartWidth / CGFloat(chartData.dataEntries.count - 1)
        
        // Draws a line for each set of values.
        for i in 0 ..< valuesCount {
            precondition(chartData.legendKeys.count - 1 >= i, "Not enough keys in legendKeys. The number of legendKeys must be equal or greater then the max number of values in one single PlotableData.")
            
            let setOfPoints = chartData.dataEntries.map { $0.values[i] }
            
            var points: [CGPoint] = []
            
            for (index, entry) in setOfPoints.enumerated() {
                let x = (dotSpacing * CGFloat(index)) + halfLineWidth
                
                let percentageOfTotal = (entry - minPlotYValue) / ((maxPlotYValue ?? maxEntry) - minPlotYValue)
                let y = chartHeight - (chartHeight * percentageOfTotal) + halfLineWidth
                points.append(CGPoint(x: x, y: y))
            }
            
            var linePath: UIBezierPath
            
            if lineConfig.isSmooth {
                linePath = ProfessionalCurveLine.quadCurvedPath(data: points)
            } else {
                linePath = Line(points: points)
            }
            
            let key = chartData.legendKeys[i]
            let color = key.color
          
            // Revert charts bounds to its original values
            chartWidth += lineWidth
            chartHeight += halfLineWidth

            drawGradient(path: linePath.cgPath, colors: color.colors, locations: color.locations, isVertical: key.isVertical, isStroke: true)
            drawCirclesIfNeeded(for: points)
        }
    }
    
    func drawCirclesIfNeeded(for points: [CGPoint]) {
        if lineConfig.showCircles {
            context.setFillColor(lineConfig.circleColor.cgColor)
            
            let insetWidth = lineWidth - 2
            let width = insetWidth < 4 ? lineWidth : insetWidth
            let halfWidth = width.half
            
            for point in points {
                context.addEllipse(in: CGRect(x: point.x - halfWidth, y: point.y - halfWidth,
                                              width: width, height: width))
            }
            context.fillPath()
        }
    }
    
    func createPath(inSize size: CGSize, offset: UIOffset = .zero) -> UIBezierPath {
        let dotSpacing: CGFloat = size.width / CGFloat(chartData.dataEntries.count - 1)
        
        var points: [CGPoint] = []
        
        for (index, entry) in chartData.dataEntries.enumerated() {
            let x = (dotSpacing * CGFloat(index)) + offset.horizontal

            let percentageOfTotal =  ((entry.total - minPlotYValue) / ((maxPlotYValue ?? maxEntry) - minPlotYValue))
            let y = size.height - (size.height * percentageOfTotal) + offset.vertical
            points.append(CGPoint(x: x, y: y))
        }
        
        if lineConfig.isSmooth {
            return ProfessionalCurveLine.quadCurvedPath(data: points, smoothness: 0.05)
        } else {
            return Line(points: points)
        }
    }
    
    func drawGradient(path: CGPath, colors: [UIColor], locations: [CGFloat]? = nil, isVertical: Bool, isStroke: Bool) {
        chartHeight += halfLineWidth

        context.addPath(path)
        if isStroke {
            context.replacePathWithStrokedPath()
        }
        context.clip()
        context.clip(to: CGRect(x: 0, y: 0, width: chartWidth, height: chartHeight))

        var colorComponents: [CGFloat] = []
        
        for color in colors {
            if let components = color.cgColor.components {
                colorComponents.append(contentsOf: components)
            }
        }
        
        let startPoint: CGPoint = .zero
        let endPoint: CGPoint
        
        if isVertical {
            endPoint = CGPoint(x: 0, y: chartHeight + lineWidth)
        } else {
            endPoint = CGPoint(x: bounds.width, y: 0)
        }
        
        context.drawLinearGradient(CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(),
                                              colorComponents: colorComponents,
                                              locations: locations,
                                              count: colors.count)!,
                                   start: startPoint,
                                   end: endPoint,
                                   options: CGGradientDrawingOptions(rawValue: 0))
        context.resetClip()
    }
}
