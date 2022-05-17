//
//  PlotableData.swift
//  FLCharts
//
//  Created by Francesco Leoni on 09/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

public protocol PlotableData {
    
    /// The name of the entry.
    var name: String { get set }
    
    /// The values of the entry.
    var values: [CGFloat] { get set }
}

public extension PlotableData {
    
    /// The sum of the entry values.
    var total: CGFloat {
        guard values.count > 1 else {
            return values.first ?? 0
        }
        
        return values.reduce(0, +)
    }
    
    var maxValue: CGFloat {
        guard values.count > 1 else {
            return values.first ?? 0
        }

        return values.max() ?? 0
    }
}

// MARK: - Concretes

public struct SinglePlotable: PlotableData {
    
    public var name: String
    
    public var values: [CGFloat]
    
    public init(name: String, value: CGFloat) {
        self.name = name
        self.values = [value]
    }
}

public struct MultiPlotable: PlotableData {
    
    public var name: String
    
    public var values: [CGFloat]

    public init(name: String, values: [CGFloat]) {
        self.name = name
        self.values = values
    }
}
