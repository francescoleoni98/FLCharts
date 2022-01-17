//
//  PlainChartBar.swift
//  FLCharts
//
//  Created by Francesco Leoni on 12/01/22.
//

import UIKit

/// A plain chart bar.
public final class PlainChartBar: UIView, ChartBar {
    
    public var config: ChartConfig?

    public func configureViews() { }
    
    public func configureBar(for barHeight: CGFloat, barData: BarData, legendKeys: [Key]) { }

}
