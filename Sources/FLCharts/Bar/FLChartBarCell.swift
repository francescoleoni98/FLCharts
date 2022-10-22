//
//  FLChartBarCell.swift
//  FLCharts
//
//  Created by Francesco Leoni on 09/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

/// The base chart bar cell.
/// If you need a different bar style, create a custom class that inherits from ``FLChartBarCell`` and override ``configureViews()``.
final public class FLChartBarCell: UICollectionViewCell {
    
    static var identifier = "FLChartBarCell"
            
    public var barData: PlotableData?
    public var config: FLChartConfig!
    public var barConfig: FLBarConfig!
    public var shouldShowTicks: Bool = true
    
    internal var barView: ChartBar!
    internal var showXAxis: Bool = true
    private let xAxisLine = UIView()
    private let spaceXLineFromBottom: CGFloat = 25
    let xAxisLabel = UILabel()
    
    internal var heightConstraint: NSLayoutConstraint!
    
    // MARK: - Configurations
        
    public override func prepareForReuse() {
        super.prepareForReuse()
        heightConstraint.isActive = false
        xAxisLabel.isHidden = false
        barView.prepareForReuse()
    }
    
    public func configure(withBar bar: ChartBar) {
        self.barView = bar

        addSubview(xAxisLine)
        xAxisLine.backgroundColor = showXAxis ? config.axesLines.color : .clear
        xAxisLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            xAxisLine.heightAnchor.constraint(equalToConstant: config.axesLines.lineWidth),
            xAxisLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            xAxisLine.topAnchor.constraint(equalTo: bottomAnchor, constant: -spaceXLineFromBottom),
            xAxisLine.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(xAxisLabel)
        xAxisLabel.textAlignment = .center
        xAxisLabel.font = config.axesLabels.font
      xAxisLabel.textColor = showXAxis ? config.axesLabels.color : .clear
        xAxisLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            xAxisLabel.topAnchor.constraint(equalTo: xAxisLine.bottomAnchor, constant: 5),
            xAxisLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        if shouldShowTicks {
            let xAxisTick = UIView()
            addSubview(xAxisTick)
            xAxisTick.backgroundColor = showXAxis ? config.tick.color : .clear
            xAxisTick.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                xAxisTick.widthAnchor.constraint(equalToConstant: config.tick.lineWidth),
                xAxisTick.heightAnchor.constraint(equalToConstant: config.tick.lineLength),
                xAxisTick.topAnchor.constraint(equalTo: xAxisLine.bottomAnchor),
                xAxisTick.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }

        addSubview(barView)
        barView.config = config
        barView.barConfig = barConfig
        barView.configureViews()
        barView.clipsToBounds = true
        barView.translatesAutoresizingMaskIntoConstraints = false

        let halfSpacing = barConfig.spacing.half
        
        NSLayoutConstraint.activate([
            barView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: halfSpacing),
            barView.bottomAnchor.constraint(equalTo: xAxisLine.topAnchor, constant: 0),
            barView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -halfSpacing)
        ])
                
        heightConstraint = barView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = true
    }
    
    public func setBarHeight(_ constant: CGFloat, chartData: FLChartData, barData: PlotableData, legendKeys: [Key], animated: Bool = false, horizontalRepresentedValues: Bool) {
        self.barData = barData
        self.xAxisLabel.text = barData.name

        let barHeight = (frame.height - spaceXLineFromBottom) * constant
        
        let minVal = min(barHeight, frame.width - barConfig.spacing)
        
        if !horizontalRepresentedValues, minVal > 0 {
            barConfig.radius.apply(to: barView, shorterEdge: minVal)
            barView.backgroundColor = legendKeys.first?.color.mainColor
        }
                
        if animated {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.heightConstraint.constant = barHeight
                UIView.animateContraints(for: self, damping: 0.6, response: 0.7)
                self.barView.configureBar(for: barHeight, chartData: chartData, barData: barData, legendKeys: legendKeys)
            }
        } else {
            heightConstraint.constant = barHeight
            barView.configureBar(for: barHeight, chartData: chartData, barData: barData, legendKeys: legendKeys)
        }
    }
}
