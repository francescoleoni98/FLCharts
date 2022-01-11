//
//  BarData.swift
//  FLCharts
//
//  Created by Francesco Leoni on 09/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

public struct BarData: Equatable {
    
    /// The name of the bar.
    public var name: String
    
    /// The values of the bar.
    public var values: [CGFloat]
    
    /// The sum of the bar values.
    public var total: CGFloat { values.reduce(0, +) }
    
    public init(name: String, values: [CGFloat]) {
        self.name = name
        self.values = values
    }
}
