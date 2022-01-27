//
//  FLMultipleValuesChartBar.swift
//  FLCharts
//
//  Created by Francesco Leoni on 09/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

/// A bar cell which allows to display multiple values in one bar.
public final class FLMultipleValuesChartBar: UIView, ChartBar {
    
    public var config: FLChartConfig?
    public var barConfig: FLBarConfig?
    
    private let barStackView = UIStackView()
    
    public func prepareForReuse() {
        for subview in barStackView.arrangedSubviews {
            barStackView.removeArrangedSubview(subview)
        }
    }
    
    public func configureViews() {
        addSubview(barStackView)
        barStackView.spacing = 0
        barStackView.axis = .vertical
        barStackView.constraints(equalTo: self)
    }
    
    public func configureBar(for barHeight: CGFloat, barData: PlotableData, legendKeys: [Key]) {
        let totalValue = barData.total

        for (index, value) in barData.values.enumerated() {
            precondition(legendKeys.count - 1 >= index, "Not enough keys in legendKeys. The number of legendKeys must be equal or greater then the max number of values in one single bar.")

            let percentageOfTotal = totalValue == 0 ? 0 : value / totalValue
            let viewHeight = barHeight * percentageOfTotal

            let view = UIView()
            view.backgroundColor = legendKeys[index].color.mainColor
            
            barStackView.insertArrangedSubview(view, at: 0)
            view.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        }
    }
}
