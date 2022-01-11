//
//  MultipleValuesChartBar.swift
//  FLCharts
//
//  Created by Francesco Leoni on 09/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

/// A bar cell which allows to display multiple values in one bar.
public class MultipleValuesChartBar: BaseChartBar {
    
    private let barStackView = UIStackView()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        for subview in barStackView.arrangedSubviews {
            barStackView.removeArrangedSubview(subview)
        }
    }
    
    public override func configureViews() {
        barView.addSubview(barStackView)
        barStackView.spacing = 0
        barStackView.axis = .vertical
        barStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            barStackView.topAnchor.constraint(equalTo: barView.topAnchor),
            barStackView.leadingAnchor.constraint(equalTo: barView.leadingAnchor),
            barStackView.bottomAnchor.constraint(equalTo: barView.bottomAnchor),
            barStackView.trailingAnchor.constraint(equalTo: barView.trailingAnchor)
        ])
    }
    
    public override func configureBar(for barHeight: CGFloat, barData: BarData) {
        let totalValue = barData.total

        for (index, value) in barData.values.reversed().enumerated() {
            let view = UIView()
            view.backgroundColor = config.barColors[index]

            let percentageOfTotal = value / totalValue
            let viewHeight = self.heightConstraint.constant * percentageOfTotal

            barStackView.addArrangedSubview(view)
            view.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        }
    }
}
