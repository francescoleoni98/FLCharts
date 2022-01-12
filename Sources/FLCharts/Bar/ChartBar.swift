//
//  ChartBar.swift
//  FLCharts
//
//  Created by Francesco Leoni on 12/01/22.
//

import UIKit

public protocol ChartBar: UIView {
    
    var config: ChartConfig? { get set }
    
    func prepareForReuse()

    /// Use this method in a subclass to customize additional views.
    func configureViews()

    /// Use this method in a subclass to configure custom views based on the bar height.
    /// - note: This method is called once the bar has set its height.
    func configureBar(for barHeight: CGFloat, barData: BarData)
}

public extension ChartBar {
    
    func prepareForReuse() { }
    
    func configureBar(for barHeight: CGFloat, barData: BarData) { }
}
