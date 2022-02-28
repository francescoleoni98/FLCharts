//
//  FLChartData.swift
//  FLCharts
//
//  Created by Francesco Leoni on 11/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

public class FLChartData {
    
    /// The title of the chart.
    public var title: String
    
    /// The entries of the chart.
    public var dataEntries: [PlotableData]
    
    /// The keys of the legend. On multi-value bars the first key corresponds to the lower part of the bar.
    public var legendKeys: [Key]
    
    /// The unit of measure to apply to the x axis values.
    public var xAxisUnitOfMeasure: String?

    /// The unit of measure to apply to the y axis values.
    public var yAxisUnitOfMeasure: String

    /// The formatter to use for the x axis values.
    ///
    /// - note: Works only for scatter chart. For bar and line charts provide the ``PlotableData/name`` already formatted.
    public var xAxisFormatter: FLFormatter?

    /// The formatter to use for the y axis values. If not defined, the values will be formatted with two decimals.
    public var yAxisFormatter: FLFormatter = .decimal(2)
    
    /// The average value of the chart.
    public var average: CGFloat {
        guard dataEntries.count > 0 else { return 0 }
        
        let total = dataEntries.reduce(0) { $0 + $1.total }

        return total / dataEntries.count.cgFloat
    }
    
    public var formattedAverage: String {
        yAxisFormatter.string(from: NSNumber(value: average))
    }
        
    internal var numberOfValues: Int {
        guard let firstEntries = dataEntries.first else { return 0 }
        return firstEntries.values.count
    }

    // MARK: - Init
    
    /// Creates the data for the chart.
    /// - Parameters:
    ///   - title: The title of the chart.
    ///   - data: The entries of the chart. It can be ``SinglePlotable`` or ``MultiPlotable``.
    ///   - legendKeys: The keys of the legend. This keys define also the colors of the bar or line.
    ///   - unitOfMeasure: The unit of measure of the chart.
    public init(title: String, data: [PlotableData], legendKeys: [Key], unitOfMeasure: String) {
        self.title = title
        self.dataEntries = data
        self.legendKeys = legendKeys
        self.yAxisUnitOfMeasure = unitOfMeasure
    }
    
    public convenience init(title: String, data: [CGFloat], legendKeys: [Key], unitOfMeasure: String) {
        let dataEntries = data.enumerated().map { SinglePlotable(name: String($0 + 1), value: $1) }
        self.init(title: title, data: dataEntries, legendKeys: legendKeys, unitOfMeasure: unitOfMeasure)
    }
    
    public convenience init(title: String, data: [String : CGFloat], legendKeys: [Key], unitOfMeasure: String) {
        let dataEntries = data.map { SinglePlotable(name: $0, value: $1) }
        self.init(title: title, data: dataEntries, legendKeys: legendKeys, unitOfMeasure: unitOfMeasure)
    }

    public convenience init(title: String, data: [[CGFloat]], legendKeys: [Key], unitOfMeasure: String) {
        let dataEntries = data.enumerated().map { MultiPlotable(name: String($0 + 1), values: $1) }
        self.init(title: title, data: dataEntries, legendKeys: legendKeys, unitOfMeasure: unitOfMeasure)
    }

    public convenience init(title: String, data: [String : [CGFloat]], legendKeys: [Key], unitOfMeasure: String) {
        let dataEntries = data.map { MultiPlotable(name: $0, values: $1) }
        self.init(title: title, data: dataEntries, legendKeys: legendKeys, unitOfMeasure: unitOfMeasure)
    }
    
    // MARK: - Methods
    
    /// The max value of the Y axis.
    internal func maxYValue(forType type: FLChart.PlotType) -> CGFloat? {
        switch type {
        case .bar:
            guard dataEntries.count >= 2 else {
                return dataEntries.first?.total
            }
            return dataEntries.max(by: { $0.total < $1.total })?.total
            
        case .line:
            guard dataEntries.count > 1 else {
                return dataEntries.first?.total
            }
            
            var maxValue: CGFloat?

            dataEntries.forEach { data in
                guard let currentMax = data.values.max() else { return }

                if let oldMax = maxValue {
                  if currentMax > oldMax {
                    maxValue = currentMax
                  }
                } else {
                    maxValue = currentMax
                }
            }
            return maxValue
            
        case .scatter:
            if let dataEntries = dataEntries as? [ScatterPlotable],
               let maxYValue = dataEntries.maxFor(\.yValue) {
                return maxYValue + (maxYValue * 0.1)
            }
            return nil
        }
    }
    
    /// The y granularity that specifies the y axis granulation if the user doesn't provide one.
    internal func defaultYGranularity(forType type: FLChart.PlotType) -> CGFloat {
        floor((maxYValue(forType: type) ?? 100) / 3)
    }
}
