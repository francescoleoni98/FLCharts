//
//  FLChartData.swift
//  FLCharts
//
//  Created by Francesco Leoni on 11/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

public struct FLChartData {
    
    /// The title of the chart.
    public var title: String
    
    /// The entries of the chart.
    public var dataEntries: [PlotableData]
    
    /// The keys of the legend. On multi-value bars the first key corresponds to the lower part of the bar.
    public var legendKeys: [Key]
    
    /// The unit of measure to apply to the entry value.
    public var unitOfMeasure: String
    
    /// The max value of the Y axis.
    internal func maxYValue(forType type: FLChart.PlotType) -> CGFloat? {
        switch type {
        case .bar:
            guard dataEntries.count >= 2 else {
                return dataEntries.first?.total
            }
            return dataEntries.max(by: { $0.total < $1.total })?.total
        case .line:
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
        }
    }
    
    /// The y granularity that specifies the y axis granulation if the user doesn't provide one.
    internal func defaultYGranularity(forType type: FLChart.PlotType) -> CGFloat {
        floor((maxYValue(forType: type) ?? 100) / 3)
    }
    
    internal var numberOfValues: Int {
        guard let firstEntries = dataEntries.first else { return 0 }
        return firstEntries.values.count
    }
    
    /// The average value of the chart.
    public var average: CGFloat {
        var total: CGFloat = 0
        for value in dataEntries {
            total += value.total
        }

        return total / CGFloat(dataEntries.count)
    }
    
    public var formattedAverage: String {
        Formatters.toDecimals(value: NSNumber(value: average)) ?? "N/D"
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
        self.unitOfMeasure = unitOfMeasure
    }
    
    public init(title: String, data: [CGFloat], legendKeys: [Key], unitOfMeasure: String) {
        let dataEntries = data.enumerated().map { SinglePlotable(name: String($0 + 1), value: $1) }
        self.init(title: title, data: dataEntries, legendKeys: legendKeys, unitOfMeasure: unitOfMeasure)
    }
    
    public init(title: String, data: [String : CGFloat], legendKeys: [Key], unitOfMeasure: String) {
        let dataEntries = data.map { SinglePlotable(name: $0, value: $1) }
        self.init(title: title, data: dataEntries, legendKeys: legendKeys, unitOfMeasure: unitOfMeasure)
    }

    public init(title: String, data: [[CGFloat]], legendKeys: [Key], unitOfMeasure: String) {
        let dataEntries = data.enumerated().map { MultiPlotable(name: String($0 + 1), values: $1) }
        self.init(title: title, data: dataEntries, legendKeys: legendKeys, unitOfMeasure: unitOfMeasure)
    }

    public init(title: String, data: [String : [CGFloat]], legendKeys: [Key], unitOfMeasure: String) {
        let dataEntries = data.map { MultiPlotable(name: $0, values: $1) }
        self.init(title: title, data: dataEntries, legendKeys: legendKeys, unitOfMeasure: unitOfMeasure)
    }
}
