//
//  FLChart.swift
//  FLCharts
//
//  Created by Francesco Leoni on 18/01/22.
//

import UIKit

public final class FLChart: UIView, FLStylable {
    
    public enum PlotType {
        case bar(bar: ChartBar.Type = FLMultipleValuesChartBar.self,
                 highlightView: HighlightedView? = nil,
                 config: FLBarConfig = FLBarConfig())
        case line(config: FLLineConfig = FLLineConfig())
    }
    
    public let cartesianPlane: FLCartesianPlane
    
    internal let plotView: FLPlotView

    public private(set) var chartData: FLChartData
    
    /// Whether to show the average line.
    /// - note: This option will be disabled for line chart with ``MultiPlotable`` data, since is not fair to calculate an average between multiple lines.
    public var showAverageLine: Bool = false {
        didSet {
            cartesianPlane.showAverageLine = showAverageLine
        }
    }

    public var config: FLChartConfig {
        didSet {
            cartesianPlane.config = config
            plotView.config = config
        }
    }
    
    public weak var highlightingDelegate: ChartHighlightingDelegate? {
        didSet {
            plotView.highlightingDelegate = highlightingDelegate
        }
    }
    
    // MARK: - Inits
    
    public init(data: FLChartData, type: PlotType) {
        self.config = FLChartConfig()
        self.chartData = data
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
            }
        }()
        
        super.init(frame: .zero)
        
        self.cartesianPlane.didUpdateChartLayoutGuide = { layoutGuide in
            self.plotView.constraints(equalTo: layoutGuide, directions: .all)
        }
        
        addSubview(cartesianPlane)
        cartesianPlane.constraints(equalTo: self, directions: .all)
        
        addSubview(plotView)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func updateChart(data: [PlotableData]) {
        chartData.dataEntries = data
        cartesianPlane.updateData(data)
        plotView.updateData(data)
    }
}
