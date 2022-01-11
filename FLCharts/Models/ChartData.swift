//
//  ChartData.swift
//  FLCharts
//
//  Created by Francesco Leoni on 11/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import Foundation

public struct ChartData: Equatable {
    
    /// The title of the chart.
    public var title: String
    
    /// The data of a specific bar.
    public var barData: [BarData]
    
    /// The unit of measure to apply to the value of the bar.
    public var unitOfMeasure: String
    
    /// The bar with the higher compound value.
    public var maxBarData: BarData? {
        barData.max(by: { $0.total < $1.total })
    }
    
    /// The average value of the chart.
    public var average: CGFloat {
        let sumArray = barData.reduce(0) { sum, newValue -> CGFloat in
            var sum = sum
            sum += newValue.total
            return sum
        }

        return sumArray / CGFloat(barData.count)
    }
    
    public init(title: String, barData: [BarData], unitOfMeasure: String) {
        self.title = title
        self.barData = barData
        self.unitOfMeasure = unitOfMeasure
    }
}
