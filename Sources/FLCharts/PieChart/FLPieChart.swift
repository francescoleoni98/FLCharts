//
//  FLPieChartView.swift
//  FLCharts
//
//  Created by Francesco Leoni on 25/02/22.
//

import UIKit

public final class FLPieChart: UIView, MutableCardableChart {
        
    internal var border: FLPieBorder = .full
    internal var chartData: [FLPiePlotable] = []
    public internal(set) var title: String = ""
    public internal(set) var legendKeys: [Key] = []
    public internal(set) var formatter: FLFormatter = .decimal(2)
    private var shapes: [SliceShape] = []
    private var circleRect: CGRect = .zero
    private var animated: Bool = true
    
    private var sum: CGFloat {
        chartData.reduce(0.0) { sum, value in
            var sum = sum
            sum += value.value
            return sum
        }
    }
    
    /// Initializes the pie chart.
    /// - Parameters:
    ///   - title: The title of the chart. It will be displayed if the chart is embedded in a ``FLCard``.
    ///   - data: The data of the chart.
    ///   - border: The style of the chart.
    ///   - formatter: The formatter to use for the ``FLCard`` ``FLLegend``.
    ///   - animated: Whether to show the data with an animation.
    public init(title: String, data: [FLPiePlotable], border: FLPieBorder = .full, formatter: FLFormatter = .decimal(2), animated: Bool = true) {
        self.title = title
        self.chartData = data
        self.border = border
        self.formatter = formatter
        self.legendKeys = data.map { $0.key }
        self.animated = animated
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Setup for storyboard.
    /// Initializes the pie chart.
    /// - Parameters:
    ///   - title: The title of the chart. It will be displayed if the chart is embedded in a ``FLCard``.
    ///   - data: The data of the chart.
    ///   - border: The style of the chart.
    ///   - formatter: The formatter to use for the ``FLCard`` ``FLLegend``.
    ///   - animated: Whether to show the data with an animation.
    public func setup(title: String, border: FLPieBorder = .full, formatter: FLFormatter = .decimal(2), animated: Bool = true, data: [FLPiePlotable]) {
        self.title = title
        self.border = border
        self.formatter = formatter
        self.chartData = data
        self.legendKeys = data.map { $0.key }
        self.animated = animated
        self.backgroundColor = .clear
        self.setNeedsDisplay()
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        for subview in subviews where subview is SliceShape {
            subview.removeFromSuperview()
        }
                
        let sum = sum
        var startPercentage: CGFloat = 0
        let minEdge = min(frame.width, frame.height)
        let borderWidth: CGFloat = {
            switch border {
            case .full: return minEdge / 2
            case .width(let width): return min(width, minEdge / 2)
            }
        }()

        let widthCircle = minEdge - borderWidth
        circleRect = CGRect(x: (frame.width - widthCircle) / 2, y: borderWidth / 2, width: widthCircle, height: widthCircle)
      
        for datum in chartData {
            let degrees = datum.value / sum
                        
            let shape = SliceShape(data: datum,
                                   width: border,
                                   color: datum.key.color.mainColor,
                                   rect: circleRect,
                                   from: startPercentage, to: startPercentage + degrees,
                                   animated: animated)
            self.shapes.append(shape)
            
            startPercentage += degrees

            self.addSubview(shape)
        }
    }
    
    /// Updates the pie chart data with new data.
    public func updateData(_ data: [FLPiePlotable], animated: Bool) {
        self.chartData = data
        
        let sum = sum
        var startPercentage: Double = 0
        var notCurrentlyDisplayed: [FLPiePlotable] = data
        
        for shape in shapes {
            if !data.contains(shape.data) {
                UIView.animate(withDuration: 0.4, delay: 0, options: []) {
                    shape.alpha = 0
                } completion: { success in
                    if success {
                        shape.removeFromSuperview()
                    }
                }
            }
            
            if let newData = data.first(where: { $0 == shape.data }) {
                notCurrentlyDisplayed.remove(object: newData)
            }
        }
        
        if !notCurrentlyDisplayed.isEmpty {
            self.setNeedsDisplay()
            return
        }
        
        for (shape, datum) in zip(shapes, data) {
            let degrees = datum.value / sum
            shape.data = datum
            shape.animateShape(from: startPercentage, to: startPercentage + degrees, animated: animated)
            startPercentage += degrees
        }
    }
}
