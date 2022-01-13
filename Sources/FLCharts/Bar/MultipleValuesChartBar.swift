//
//  MultipleValuesChartBar.swift
//  FLCharts
//
//  Created by Francesco Leoni on 09/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

/// A bar cell which allows to display multiple values in one bar.
public final class MultipleValuesChartBar: UIView, ChartBar {
    
    public var config: ChartConfig?

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
        barStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            barStackView.topAnchor.constraint(equalTo: topAnchor),
            barStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            barStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            barStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    public func configureBar(for barHeight: CGFloat, barData: BarData) {
        guard let config = config else {
            print("No chart configuration is present.")
            return
        }

        let totalValue = barData.total

        for (index, value) in barData.values.reversed().enumerated() {
            precondition(config.bar.colors.count - 1 >= index, "Not enough colors in ChartConfig.barColors.")

            let view = UIView()
            view.backgroundColor = config.bar.colors[index]

            let percentageOfTotal = value / totalValue
            let viewHeight = barHeight * percentageOfTotal

            barStackView.addArrangedSubview(view)
            view.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        }
    }
}
