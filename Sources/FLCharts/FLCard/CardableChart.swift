//
//  CardableChart.swift
//  FLCharts
//
//  Created by Francesco Leoni on 13/03/22.
//

import UIKit

public protocol CardableChart: UIView {
    var title: String { get }
    var legendKeys: [Key] { get }
    var formatter: FLFormatter { get }
}

internal protocol MutableCardableChart: CardableChart {
    var title: String { get set }
    var legendKeys: [Key] { get set }
    var formatter: FLFormatter { get set }
}
