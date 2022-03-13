//
//  FLChart.swift
//  FLCharts
//
//  Created by Francesco Leoni on 18/01/22.
//

import UIKit

public final class FLChart: UIView, FLStylable, MutableCardableChart {
        
    public enum PlotType {
        case bar(bar: ChartBar.Type = FLMultipleValuesChartBar.self,
                 highlightView: HighlightedView? = nil,
                 config: FLBarConfig = FLBarConfig())
        case line(config: FLLineConfig = FLLineConfig())
        case scatter(dotDiameter: CGFloat = 3)
    }
    
    public private(set) var cartesianPlane: FLCartesianPlane
    
    internal private(set) var plotView: FLPlotView

    public private(set) var chartData: FLChartData
    
    public internal(set) var title: String = ""
    public internal(set) var legendKeys: [Key] = []
    public internal(set) var formatter: FLFormatter = .decimal(2)

    /// Whether the chart should scroll. The chart will start scrolling once there is bar outside of the right bound.
    ///
    /// - note: This property can be enabled only while using bar charts.
    public var shouldScroll: Bool = true {
        didSet {
            if let barPlotView = plotView as? FLBarPlotView {
                barPlotView.shouldScroll = shouldScroll
            }
        }
    }
    
    /// Whether to show the average line.
    ///
    /// - note: This option will be disabled for line chart with ``MultiPlotable`` data, since is not fair to calculate an average between multiple lines.
    public var showAverageLine: Bool = false {
        didSet {
            cartesianPlane.showAverageLine = showAverageLine
        }
    }

    /// Whether to show the axes ticks.
    public var showTicks: Bool = true {
        didSet {
            cartesianPlane.showTicks = showTicks
            
            if let barPlotView = plotView as? FLBarPlotView {
                barPlotView.showTicks = showTicks
            }
        }
    }

    public var config: FLChartConfig {
        didSet {
            cartesianPlane.config = config
            plotView.config = config
        }
    }
    
    /// The highlight view delegate that observes different states of the view.
    public weak var highlightingDelegate: ChartHighlightingDelegate? {
        didSet {
            plotView.highlightingDelegate = highlightingDelegate
        }
    }
    
    // MARK: - Inits
    
    public init(data: FLChartData, type: PlotType) {
        self.config = FLChartConfig()
        self.chartData = data
        self.title = data.title
        self.legendKeys = data.legendKeys
        self.formatter = data.yAxisFormatter
        self.cartesianPlane = FLCartesianPlane(data: data, type: type)
        self.plotView = {
            switch type {
            case .bar(let bar, let highlightView, let barConfig):
                let barPlotView = FLBarPlotView(data: data, bar: bar, highlightView: highlightView)
                barPlotView.barConfig = barConfig
                return barPlotView
                
            case .line(let lineConfig):
                let linePlotView = FLLinePlotView(data: data)
                linePlotView.lineConfig = lineConfig
                return linePlotView
                
            case .scatter(let diameter):
                let scatterPlotView = FLScatterPlotView(data: data)
                scatterPlotView.dotDiameter = diameter
                return scatterPlotView
            }
        }()

        super.init(frame: .zero)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        let data = FLChartData(title: "", data: [0], legendKeys: [], unitOfMeasure: "")
        self.chartData = data
        self.config = FLChartConfig()
        self.cartesianPlane = FLCartesianPlane(data: data, type: .bar())
        self.plotView = FLLinePlotView(data: data)
        super.init(coder: coder)
    }
    
    /// Sets up the chart from the storyboard.
    public func setup(data: FLChartData, type: PlotType) {
        self.config = FLChartConfig()
        self.chartData = data
        self.title = data.title
        self.legendKeys = data.legendKeys
        self.formatter = data.yAxisFormatter
        self.cartesianPlane = FLCartesianPlane(data: data, type: type)
        self.plotView = {
            switch type {
            case .bar(let bar, let highlightView, let barConfig):
                let barPlotView = FLBarPlotView(data: data, bar: bar, highlightView: highlightView)
                barPlotView.barConfig = barConfig
                return barPlotView
                
            case .line(let lineConfig):
                let linePlotView = FLLinePlotView(data: data)
                linePlotView.lineConfig = lineConfig
                return linePlotView
                
            case .scatter:
                return FLScatterPlotView(data: data)
            }
        }()
                
        self.commonInit()
    }
    
    private func commonInit() {
        self.cartesianPlane.didUpdateChartLayoutGuide = { layoutGuide in
            self.plotView.constraints(equalTo: layoutGuide, directions: .all)
        }
        
        addSubview(cartesianPlane)
        cartesianPlane.constraints(equalTo: self, directions: .all)
        
        addSubview(plotView)
    }
    
    // MARK: - Methods
    
    public func updateChart(data: [PlotableData]) {
        chartData.dataEntries = data
        cartesianPlane.updateData(data)
        plotView.updateData(data)
    }
    
    internal static func canShowAverage(chartType: FLChart.PlotType, data: FLChartData) -> Bool {
        if case .line = chartType, data.numberOfValues > 1 {
            return false
        }
        
        if case .scatter = chartType {
            return false
        }
        
        return true
    }
}
