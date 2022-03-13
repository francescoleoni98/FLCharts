//
//  FLRadarChart.swift
//  FLCharts
//
//  Created by Francesco Leoni on 13/03/22.
//

import UIKit

/// A radar chart, or Kiviat chart.
public final class FLRadarChart: UIView, MutableCardableChart {
    
    /// Whether to show the Y axis labels.
    public var showYAxisLabels: Bool = true
    
    /// Whether to show the X axis labels.
    public var showXAxisLabels: Bool = true

    /// Whether to show the Y axis and X axis labels.
    /// - Note: This property can override ``showYAxisLabels`` and ``showXAxisLabels``.
    public var showLabels: Bool = true {
        didSet {
            showXAxisLabels = showLabels
            showYAxisLabels = showLabels
        }
    }

    public internal(set) var title: String = ""
    public internal(set) var legendKeys: [Key] = []
    public internal(set) var formatter: FLFormatter = .decimal(2)
    
    private var labels: Labels = Labels()
    private var data: [FLDataSet]
    private var isFilled: Bool = true
    private var categories: [String] = []
    private var config: FLRadarGridConfig = FLRadarGridConfig()

    /// Creates a radar chart.
    /// - Parameters:
    ///   - title: The title of the chart. It will be displayed if the chart is embedded in a ``FLCard``.
    ///   - categories: The name of the category represented by each axis.
    ///   - data: The data of the chart.
    ///   - isFilled: Whether the data representation layers are filled or empty.
    ///   - formatter: The formatter to use for the ``FLCard`` ``FLLegend``.
    ///   - config: The configuration for the chart grid.
    public init(title: String, categories: [String], data: [FLDataSet], isFilled: Bool = true, formatter: FLFormatter = .decimal(2), config: FLRadarGridConfig = FLRadarGridConfig()) {
        Self.checkDataValidity(data: data, categories: categories)

        self.title = title
        self.categories = categories
        self.data = data
        self.isFilled = isFilled
        self.config = config
        self.legendKeys = data.map { $0.key }
        self.formatter = formatter
        self.labels = Labels(font: config.labelsFont)
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        self.data = []
        super.init(coder: coder)
    }
    
    /// Setup for storyboard.
    /// Creates a radar chart.
    /// - Parameters:
    ///   - title: The title of the chart. It will be displayed if the chart is embedded in a ``FLCard``.
    ///   - categories: The name of the category represented by each axis.
    ///   - data: The data of the chart.
    ///   - isFilled: Whether the data representation layers are filled or empty.
    ///   - formatter: The formatter to use for the ``FLCard`` ``FLLegend``.
    ///   - config: The configuration for the chart grid.
    public func setup(title: String, categories: [String], data: [FLDataSet], isFilled: Bool = true, formatter: FLFormatter = .decimal(2), config: FLRadarGridConfig = FLRadarGridConfig()) {
        Self.checkDataValidity(data: data, categories: categories)
        self.title = title
        self.categories = categories
        self.data = data
        self.isFilled = isFilled
        self.config = config
        self.legendKeys = data.map { $0.key }
        self.formatter = formatter
        self.labels = Labels(font: config.labelsFont)
        self.setNeedsDisplay()
    }
    
    /// Updates the radar chart data with new data.
    public func updateData(_ data: [FLDataSet], newCategories: [String]? = nil) {
        Self.checkDataValidity(data: data, categories: newCategories ?? categories)
        self.data = data
        
        if let newCategories = newCategories {
            self.categories = newCategories
        }

        self.setNeedsDisplay()
    }
    
    private static func checkDataValidity(data: [FLDataSet], categories: [String]) {
        for (prev, sec) in zip(data, data.dropFirst()) {
            guard prev.data.count == sec.data.count else {
                preconditionFailure("The number of values is not homogenous. Every DataSet must have the same number of values.")
            }
            
            guard prev.data.count == categories.count else {
                preconditionFailure("The number of categories (\(categories.count)) must be equal to the number of values (\(prev.data.count)).")
            }
        }
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        labels.clearLabels()
        
        var rect = rect

        if showLabels && showYAxisLabels {
            rect.origin.y += 20
            rect.size.height -= 40
        }
        
        if showLabels && showXAxisLabels {
            var widestLabel: CGFloat = 0
            
            for category in categories {
                let width = category.size(withSystemFontSize: config.labelsFont.pointSize).width
                
                if widestLabel < width {
                    widestLabel = width
                }
            }
            
            rect.origin.x += widestLabel
            rect.size.width -= widestLabel * 2
        }
        
        context.addPath(gridPath(in: rect).cgPath)
        context.setStrokeColor(config.color.cgColor)
        context.setLineWidth(config.lineWidth)
        context.strokePath()

        labels.drawLabels(color: config.labelsColor)
        
        for dataSet in data {
            context.addPath(dataPath(in: rect, data: dataSet.data).cgPath)
            context.setStrokeColor(dataSet.key.color.mainColor.cgColor)
            context.setFillColor(dataSet.key.color.mainColor.withAlphaComponent(0.4).cgColor)
            context.setLineWidth(2)
            context.setLineJoin(.round)
            
            if isFilled {
                context.drawPath(using: .fillStroke)
            } else {
                context.strokePath()
            }
        }
    }
    
    private func dataPath(in rect: CGRect, data: [CGFloat]) -> UIBezierPath {
        guard 3 <= data.count else {
            preconditionFailure("The number of values must be three or more.")
        }

        guard let minimum = self.data.min,
              0 <= minimum,
              let maximum = self.data.max else { return UIBezierPath() }
                
        let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY)
        let path = UIBezierPath()
        
        for (index, entry) in data.enumerated() {
            switch index {
            case 0:
                path.move(to: CGPoint(x: rect.midX + CGFloat(entry / maximum) * cos(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius,
                                      y: rect.midY + CGFloat(entry / maximum) * sin(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius))
                
            default:
                path.addLine(to: CGPoint(x: rect.midX + CGFloat(entry / maximum) * cos(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius,
                                         y: rect.midY + CGFloat(entry / maximum) * sin(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius))
            }
        }
        path.close()
        
        return path
    }

    private func gridPath(in rect: CGRect) -> UIBezierPath {
        let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY)
        let stride = radius / CGFloat(config.divisions)
        let maxY = data.max ?? 0
                
        let path = UIBezierPath()
        
        for (index, category) in categories.enumerated() {
            let cos = cos(CGFloat(index + 1) * 2 * .pi / CGFloat(categories.count) - .pi / 2)
            let sin = sin(CGFloat(index + 1) * 2 * .pi / CGFloat(categories.count) - .pi / 2)
            
            let endPoint = CGPoint(x: rect.midX + cos * radius,
                                   y: rect.midY + sin * radius)

            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addLine(to: endPoint)
            
            if showLabels && showXAxisLabels {
                let size = category.size(withSystemFontSize: config.labelsFont.pointSize)
                var labelPoint = CGPoint(x: rect.midX + cos * (radius + 7),
                                         y: rect.midY + sin * (radius + 7))
                labelPoint.x -= size.width.half
                labelPoint.y -= size.height.half
                
                if abs(sin) != 1 {
                    if cos > 0 {
                        labelPoint.x += size.width.half
                    } else {
                        labelPoint.x -= size.width.half
                    }
                }
                
                if category == categories.last {
                    labelPoint.y -= 5
                }
                
                labels.add(Label(text: category, point: labelPoint, type: .xLabel))
            }
        }
        
        for step in 1 ... config.divisions {
            let rad = CGFloat(step) * stride

            let startPoint = CGPoint(x: rect.midX + cos(-.pi / 2) * rad,
                                     y: rect.midY + sin(-.pi / 2) * rad)
            
            let increment = maxY / CGFloat(config.divisions)
            let labelValue = increment * CGFloat(step)
            
            if showLabels && showYAxisLabels {
                var labelPoint = startPoint
                labelPoint.x += 3
                labels.add(Label(text: formatter.string(from: NSNumber(value: labelValue)), point: labelPoint, type: .yLabel))
            }
            
            path.move(to: startPoint)
            
            for (index, _) in categories.enumerated() {
                path.addLine(to: CGPoint(x: rect.midX + cos(CGFloat(index + 1) * 2 * .pi / CGFloat(categories.count) - .pi / 2) * rad,
                                         y: rect.midY + sin(CGFloat(index + 1) * 2 * .pi / CGFloat(categories.count) - .pi / 2) * rad))
            }
        }
        
        return path
    }
}
