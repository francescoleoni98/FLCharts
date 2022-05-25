//
//  FLChartSwiftUI.swift
//  FLCharts
//
//  Created by Francesco Leoni on 23/05/22.
//

import SwiftUI

public protocol FLCardableView {
    var chart: CardableChart { get set }
}

@available(iOS 13.0, *)
public struct FLChartView: UIViewRepresentable, FLCardableView {
    
    public var data: Binding<FLChartData>
    public var type: FLChart.PlotType
    public var dataEntries: Binding<[PlotableData]>

    public var chart: CardableChart

    private var shouldScroll: Bool = true
    private var showAverageLine: Bool = false
    private var showTicks: Bool = true
    private var showDashedLines: Bool = true
    private var showUnitsOfMeasure: Bool = true
    private var config: FLChartConfig = FLChartConfig()
    private var yAxisPosition: YPosition = .left
    private weak var highlightingDelegate: ChartHighlightingDelegate?
    
    public init(data: Binding<FLChartData>, type: FLChart.PlotType) {
        self.data = data
        self.type = type
        self.dataEntries = data.dataEntries
        self.chart = FLChart(data: self.data.wrappedValue, type: self.type)
    }
    
    public func makeUIView(context: Context) -> FLChart {
        return chart as! FLChart
    }
    
    public func updateUIView(_ uiView: FLChart, context: Context) {
        uiView.shouldScroll = shouldScroll
        uiView.showAverageLine = showAverageLine
        uiView.showTicks = showTicks
        uiView.cartesianPlane.showDashedLines = showDashedLines
        uiView.cartesianPlane.showUnitsOfMeasure = showUnitsOfMeasure
        uiView.config = config
        uiView.cartesianPlane.yAxisPosition = yAxisPosition
        uiView.highlightingDelegate = highlightingDelegate
        uiView.updateChart(data: data.dataEntries.wrappedValue)
    }
}

@available(iOS 13.0, *)
extension FLChartView {
    
    /// Whether the chart should scroll. The chart will start scrolling once there is bar outside of the right bound.
    ///
    /// - note: This property can be enabled only while using bar charts.
    public func shouldScroll(_ flag: Bool) -> Self {
        var view = self
        view.shouldScroll = flag
        return view
    }
    
    /// Whether to show the average line.
    ///
    /// - note: This option will be disabled for line chart with ``MultiPlotable`` data, since is not fair to calculate an average between multiple lines.
    public func showAverageLine(_ flag: Bool) -> Self {
        var view = self
        view.showAverageLine = flag
        return view
    }
    
    /// Whether to show the axes ticks.
    public func showTicks(_ flag: Bool) -> Self {
        var view = self
        view.showTicks = flag
        return view
    }
    
    /// Whether to show the dash lines.
    public func showDashedLines(_ flag: Bool) -> Self {
        var view = self
        view.showDashedLines = flag
        return view
    }
    
    /// Whether to show the axes unit of measure.
    public func showUnitsOfMeasure(_ flag: Bool) -> Self {
        var view = self
        view.showUnitsOfMeasure = flag
        return view
    }
    
    /// The config of the chart.
    public func config(_ config: FLChartConfig) -> Self {
        var view = self
        view.config = config
        return view
    }
    
    /// The position of the y axis.
    public func yAxisPosition(_ yAxisPosition: YPosition) -> Self {
        var view = self
        view.yAxisPosition = yAxisPosition
        return view
    }
    
    /// The highlight view delegate that observes different states of the view.
    public func highlightingDelegate(_ highlightingDelegate: ChartHighlightingDelegate?) -> Self {
        var view = self
        view.highlightingDelegate = highlightingDelegate
        return view
    }
    
//    public func updateChart(data: [PlotableData]) -> Self {
//        var view = self
//        view.data.dataEntries = data
//        view.updateData = true
//
//        defer {
//            view.updateData = false
//        }
//
//        return view
//    }
}


@available(iOS 13, *)
public struct FLRadarChartView: UIViewRepresentable {
    
    private var title: String
    private var data: Binding<[FLDataSet]>
    private var categories: Binding<[String]>
    private var isFilled: Bool
    private var formatter: FLFormatter
    private var config: FLRadarGridConfig
    
    private var showLabels: Bool = true
    private var showXAxisLabels: Bool = true
    private var showYAxisLabels: Bool = true
    
    public init(title: String, data: [FLDataSet], categories: [String], isFilled: Bool = true, formatter: FLFormatter = .decimal(2), config: FLRadarGridConfig = FLRadarGridConfig()) {
        self.init(title: title, data: .constant(data), categories: .constant(categories), isFilled: isFilled, formatter: formatter, config: config)
    }
    
    public init(title: String, data: Binding<[FLDataSet]>, categories: Binding<[String]>, isFilled: Bool = true, formatter: FLFormatter = .decimal(2), config: FLRadarGridConfig = FLRadarGridConfig()) {
        self.title = title
        self.data = data
        self.categories = categories
        self.isFilled = isFilled
        self.formatter = formatter
        self.config = config
    }
    
    public func makeUIView(context: Context) -> FLRadarChart {
        return FLRadarChart(title: title, categories: categories.wrappedValue, data: data.wrappedValue, isFilled: isFilled, formatter: formatter, config: config)
    }
    
    public func updateUIView(_ uiView: FLRadarChart, context: Context) {
        uiView.updateData(data.wrappedValue, newCategories: categories.wrappedValue)
    }
}

@available(iOS 13.0.0, *)
extension FLRadarChartView {

    /// Whether to show the Y axis and X axis labels.
    /// - Note: This property can override ``showYAxisLabels`` and ``showXAxisLabels``.
    public func showLabels(_ flag: Bool) -> Self {
        var view = self
        view.showLabels = flag
        return view
    }

    /// Whether to show the X axis labels.
    public func showXAxisLabels(_ flag: Bool) -> Self {
        var view = self
        view.showXAxisLabels = flag
        return view
    }

    /// Whether to show the Y axis labels.
    public func showYAxisLabels(_ flag: Bool) -> Self {
        var view = self
        view.showYAxisLabels = flag
        return view
    }
}

@available(iOS 13.0.0, *)
public struct FLPieChartView: UIViewRepresentable {
    
    private var title: String
    private var data: Binding<[FLPiePlotable]>
    private var border: FLPieBorder
    private var formatter: FLFormatter
    private var animated: Bool
    
    public init(title: String, data: [FLPiePlotable], border: FLPieBorder = .full, formatter: FLFormatter = .decimal(2), animated: Bool = true) {
        self.init(title: title, data: .constant(data), border: border, formatter: formatter, animated: animated)
    }

    public init(title: String, data: Binding<[FLPiePlotable]>, border: FLPieBorder = .full, formatter: FLFormatter = .decimal(2), animated: Bool = true) {
        self.title = title
        self.data = data
        self.border = border
        self.formatter = formatter
        self.animated = animated
    }

    public func makeUIView(context: Context) -> FLPieChart {
        return FLPieChart(title: title, data: data.wrappedValue, border: border, formatter: formatter, animated: animated)
    }
    
    public func updateUIView(_ uiView: FLPieChart, context: Context) {
        uiView.updateData(data.wrappedValue, animated: animated)
    }
}

@available(iOS 13.0, *)
public struct FLCardView: UIViewRepresentable {
    
    public var style: FLCardStyle
    public var chart: FLCardableView
    
    private var showLegend: Bool = true
    private var showAverage: Bool = true
    
    public init(style: FLCardStyle, @ViewBuilder chart: () -> FLCardableView) {
        self.style = style
        self.chart = chart()
    }
    
    public func makeUIView(context: Context) -> FLCard {
        return FLCard(chart: chart.chart, style: self.style)
    }
    
    public func updateUIView(_ uiView: FLCard, context: Context) {
        uiView.showLegend = showLegend
        uiView.showAverage = showAverage
    }
}

@available(iOS 13.0, *)
extension FLCardView {
    
    /// Whether to show the legend. Default is `true`.
    public func showLegend(_ flag: Bool) -> Self {
        var view = self
        view.showLegend = flag
        return view
    }
    
    /// Whether to show the average view. Default is `true`.
    /// - Note: This property can be used only with bar and line charts. Else it will be `false`.
    public func showAverage(_ flag: Bool) -> Self {
        var view = self
        view.showAverage = flag
        return view
    }
}


@available(iOS 13.0.0, *)
public struct FLLegendView: UIViewRepresentable {
    
    var keys: [Key]
    var formatter: FLFormatter
    
    public init(keys: [Key], formatter: FLFormatter = .decimal(2)) {
        self.keys = keys
        self.formatter = formatter
    }
    
    public func makeUIView(context: Context) -> UIStackView {
        let legend = FLLegend(keys: keys, formatter: formatter)
        return UIStackView(arrangedSubviews: [legend])
    }
    
    public func updateUIView(_ uiView: UIStackView, context: Context) {
        
    }
}
