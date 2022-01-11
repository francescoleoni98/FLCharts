//
//  HighlightedView.swift
//  FLCharts
//
//  Created by Francesco Leoni on 09/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

/// Implements ``HighlightedView`` to create a custom HighlightedView.
public protocol HighlightedView: UIView {
    
    /// The value of the bar currently highlighted.
    var dataValue: String? { get set }
    
    /// Use this method to update the ``dataValue`` string.
    func update(with value: String?)
    
    /// Use this method to update the view with ``BarData``.
    func update(withBarData barData: BarData)

    /// Use this method to update the view with ``ChartData``.
    func update(withChartData chartData: ChartData?)
}

extension HighlightedView {
    
    public func update(withBarData barData: BarData) { }

    public func update(withChartData chartData: ChartData?) { }
}
