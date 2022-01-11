//
//  BaseChartBar.swift
//  FLCharts
//
//  Created by Francesco Leoni on 09/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

/// The base chart bar cell.
/// If you need a different bar style, create a custom class that inherits from ``BaseChartBar`` and override ``configureViews()``.
open class BaseChartBar: UICollectionViewCell {
    
    static var identifier = "ChartBarCell"
            
    public var barData: BarData?
    public var config: ChartConfig!
    
    internal var barView = UIView()
    private let xAxisLine = UIView()
    let xAxisLabel = UILabel()
    
    internal var heightConstraint: NSLayoutConstraint!
    
    // MARK: - Configurations
        
    open override func prepareForReuse() {
        super.prepareForReuse()
        heightConstraint.isActive = false
    }
    
    public func configure(with config: ChartConfig) {
        self.config = config
        
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
        
        if config.showTicks {
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
        barView.clipsToBounds = true
        barView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            barView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: config.barSpacing / 2),
            barView.bottomAnchor.constraint(equalTo: xAxisLine.topAnchor, constant: 0),
            barView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(config.barSpacing / 2))
        ])
        
        heightConstraint = barView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = true
        
        configureViews()
    }
    
    /// Override this method in a subclass to customize additional views.
    open func configureViews() { }
    
    /// Override this method in a subclass to configure custom views based on the bar height.
    /// - note: This method is called one the bar has set its height.
    open func configureBar(for barHeight: CGFloat, barData: BarData) { }

    public func setBarHeight(_ constant: CGFloat, barData: BarData, animated: Bool = false) {
        self.xAxisLabel.text = barData.name
        self.barData = barData
        
        let barHeight = (self.frame.height - config.margin.vertical) * constant
                        
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
        
        barView.backgroundColor = config.barColors.first
        
        if animated {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.heightConstraint.constant = barHeight
                UIView.animateContraints(for: self, damping: 0.6, response: 0.7)
                self.configureBar(for: barHeight, barData: barData)
            }
        } else {
            self.heightConstraint.constant = barHeight
            self.configureBar(for: barHeight, barData: barData)
        }
    }
}
