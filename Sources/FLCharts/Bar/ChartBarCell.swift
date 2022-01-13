//
//  ChartBarCell.swift
//  FLCharts
//
//  Created by Francesco Leoni on 09/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

/// The base chart bar cell.
/// If you need a different bar style, create a custom class that inherits from ``ChartBarCell`` and override ``configureViews()``.
final public class ChartBarCell: UICollectionViewCell {
    
    static var identifier = "ChartBarCell"
            
    public var barData: BarData?
    public var config: ChartConfig!
    public var shouldShowTicks: Bool = true
    
    internal var barView: ChartBar!
    private let xAxisLine = UIView()
    let xAxisLabel = UILabel()
    
    internal var heightConstraint: NSLayoutConstraint!
    
    // MARK: - Configurations
        
    public override func prepareForReuse() {
        super.prepareForReuse()
        heightConstraint.isActive = false
        barView.prepareForReuse()
    }
    
    public func configure(withBar bar: ChartBar) {
        self.barView = bar

        addSubview(xAxisLine)
        xAxisLine.backgroundColor = config.axesColor
        xAxisLine.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            xAxisLine.heightAnchor.constraint(equalToConstant: config.axesLineWidth),
            xAxisLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            xAxisLine.topAnchor.constraint(equalTo: bottomAnchor, constant: -config.margin.vertical),
            xAxisLine.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(xAxisLabel)
        xAxisLabel.textAlignment = .center
        xAxisLabel.textColor = config.axesColor
        xAxisLabel.font = .preferredFont(for: .footnote, weight: .medium)
        xAxisLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            xAxisLabel.topAnchor.constraint(equalTo: xAxisLine.bottomAnchor, constant: 5),
            xAxisLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        if shouldShowTicks {
            let xAxisTick = UIView()
            addSubview(xAxisTick)
            xAxisTick.backgroundColor = config.axesColor
            xAxisTick.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                xAxisTick.widthAnchor.constraint(equalToConstant: config.axesLineWidth),
                xAxisTick.heightAnchor.constraint(equalToConstant: config.ticksHeight),
                xAxisTick.topAnchor.constraint(equalTo: xAxisLine.bottomAnchor),
                xAxisTick.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }

        addSubview(barView)
        barView.config = config
        barView.clipsToBounds = true
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.configureViews()
        
        let halfSpacing = config.barSpacing / 2
        
        NSLayoutConstraint.activate([
            barView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: halfSpacing),
            barView.bottomAnchor.constraint(equalTo: xAxisLine.topAnchor, constant: 0),
            barView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -halfSpacing)
        ])
                
        heightConstraint = barView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = true
    }
    
    public func setBarHeight(_ constant: CGFloat, barData: BarData, animated: Bool = false) {
        self.xAxisLabel.text = barData.name
        self.barData = barData
        
        let barHeight = (frame.height - config.margin.vertical) * constant
                        
        let minVal = min(barHeight, frame.width - config.barSpacing)
        
        if minVal > 0 {
            switch config.barRadius {
            case .none:
                break
                
            case .capsule:
                barView.layer.cornerRadius = minVal / 2

            case .custom(let radius):
                barView.layer.cornerRadius = radius

            case .corners(let corners, let radius):
                barView.layer.cornerRadius = radius
                barView.layer.maskedCorners = corners
            }
        }
        
        let barColors = config.barColors
        let lastIndex = barData.values.count - 1
        let lastColor = barColors.count - 1 >= lastIndex ? barColors[lastIndex] : barColors.first
        barView.backgroundColor = lastColor
        
        if animated {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.heightConstraint.constant = barHeight
                UIView.animateContraints(for: self, damping: 0.6, response: 0.7)
                self.barView.configureBar(for: barHeight, barData: barData)
            }
        } else {
            heightConstraint.constant = barHeight
            barView.configureBar(for: barHeight, barData: barData)
        }
    }
}
