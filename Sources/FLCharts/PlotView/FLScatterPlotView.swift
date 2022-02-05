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
            let circleRadius = diameter / 2
            
            context.addEllipse(in: CGRect(x: point.x - circleRadius, y: point.y - circleRadius,
                                          width: diameter, height: diameter))
        }
        
        context.fillPath()
    }
}

class Aggregator {
    
    let points: [CGPoint]
    var diameter: CGFloat = 0
    
    init(points: [CGPoint]) {
        self.points = points
    }
    
    func aggregate(diameter: CGFloat) -> [(point: CGPoint, numberOfAggregations: Int)] {
        self.diameter = diameter
        var aggregatedPoints: [(CGPoint, Int)] = []
        var pointsToSkip: [CGPoint] = []

        for point in points {
            guard !pointsToSkip.contains(point) else { continue }
            
            let pointsToAggregate = points.filter { pointToIntersect in
                rectFor(point).intersects(rectFor(pointToIntersect))
            }

            let centerPoint = pointsToAggregate.centroid() ?? point
            aggregatedPoints.append((centerPoint, pointsToAggregate.count))
            pointsToSkip.append(contentsOf: pointsToAggregate)
        }
        
        return aggregatedPoints
    }
    
    private func rectFor(_ point: CGPoint) -> CGRect {
        let radius = diameter / 2
        return CGRect(x: point.x - radius, y: point.y - radius, width: diameter, height: diameter)
    }
}

extension Array where Element == CGPoint {
    
    /// The center of the polygon created by points.
    func centroid() -> CGPoint? {
        guard let firstCoordinate = first else { return nil }
        
        guard self.count > 1 else { return firstCoordinate }
        
        var minX = firstCoordinate.x
        var maxX = firstCoordinate.x
        var minY = firstCoordinate.y
        var maxY = firstCoordinate.y
        
        for i in 1 ..< self.count {
            let current = self[i]
            if minX > current.x {
                minX = current.x
            } else if maxX < current.x {
                maxX = current.x
            } else if minY > current.y {
                minY = current.y
            } else if maxY < current.y {
                maxY = current.y
            }
        }
        
        let centerX = minX + ((maxX - minX) / 2)
        let centerY = minY + ((maxY - minY) / 2)
        return CGPoint(x: centerX, y: centerY)
    }
}

extension RangeReplaceableCollection where Element: Equatable {
    
    @discardableResult
    mutating func remove(object element: Element) -> Element? {
        if let index = firstIndex(of: element) {
            return remove(at: index)
        }
        return nil
    }
    
    @discardableResult
    mutating func remove(objects elements: [Element]) -> [Element] {
        var removedObjects: [Element] = []
        
        for element in elements {
            if let index = firstIndex(of: element) {
                removedObjects.append(remove(at: index))
            }
        }
        
        return removedObjects
    }
}

extension Sequence {
    func maxFor<T: Comparable>(_ keyPath: KeyPath<Element, T>) -> T? {
        self.max { first, second in
            first[keyPath: keyPath] < second[keyPath: keyPath]
        }?[keyPath: keyPath]
    }
}
