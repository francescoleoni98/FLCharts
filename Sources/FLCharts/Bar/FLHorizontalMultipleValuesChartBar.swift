//
//  FLHorizontalMultipleValuesChartBar.swift
//  FLCharts
//
//  Created by Francesco Leoni on 16/05/22.
//

import UIKit

/// A bar cell which allows to display multiple values in multiple horizontal bars.
public final class FLHorizontalMultipleValuesChartBar: UIView, ChartBar {
    
    public var config: FLChartConfig?
    public var barConfig: FLBarConfig?
    
    public var horizontalRepresentedValues: Bool = true

    private let barsStackView = UIStackView()

    public func prepareForReuse() {
        for subview in barsStackView.arrangedSubviews {
            barsStackView.removeArrangedSubview(subview)
        }
    }
    
    public func configureViews() {
        addSubview(barsStackView)
        barsStackView.spacing = 2
        barsStackView.axis = .horizontal
        barsStackView.distribution = .fillEqually
        barsStackView.constraints(equalTo: self)
    }
    
    public func configureBar(for barHeight: CGFloat, chartData: FLChartData, barData: PlotableData, legendKeys: [Key]) {
        let maxChartValue = chartData.maxIndividualValue() ?? 0
        let maxBarValue = barData.maxValue

        for (index, value) in barData.values.enumerated() {
            precondition(legendKeys.count - 1 >= index, "Not enough keys in legendKeys. The number of legendKeys must be equal or greater then the max number of values in one single bar.")

            let barContainerView = UIView()

            let bar = UIView()
            bar.backgroundColor = legendKeys[index].color.mainColor
            
            let keysCount = CGFloat(legendKeys.count)
            self.layoutIfNeeded()

            barConfig?.radius.apply(to: bar, shorterEdge: (frame.width - ((keysCount - 1) * barsStackView.spacing)) / keysCount)
            
            let percentageOfTotal = maxBarValue == 0 ? 0 : value / maxChartValue
            let barHeight = barHeight * percentageOfTotal

            barContainerView.addSubview(bar)
            
            barsStackView.addArrangedSubview(barContainerView)
            bar.heightAnchor.constraint(equalToConstant: barHeight).isActive = true
            bar.constraints(equalTo: barContainerView, directions: [.horizontal, .bottom])
        }
    }
}
