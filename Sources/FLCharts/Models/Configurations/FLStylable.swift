//
//  FLStylable.swift
//  FLCharts
//
//  Created by Francesco Leoni on 18/01/22.
//

import UIKit

/// Defines a style for the chart.
public protocol FLStylable: AnyObject {
 
    var config: FLChartConfig { get set }
}
