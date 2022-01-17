//
//  FLCard.swift
//  FLCharts
//
//  Created by Francesco Leoni on 13/01/22.
//

import UIKit

/// A card with an embedded chart, a title label and an average label if needed.
/// If the chart supports highlighting, the title and average labels will disappear while highlighting.
final public class FLCard: UIView {
    
    private let titleLabel = UILabel()
    private var averageLabel: UILabel?
    private var legend: FLLegend?
    private let stackView = UIStackView()
    private let contentGuide = UILayoutGuide()
    private let chartView: FLBarChart
    private let style: FLCardStyle
    
    /// Whether to show the legend. Default is `true`.
    public var showLegend: Bool = true {
        didSet {
            configureLegend()
        }
    }
    
    /// Whether to show the average view. Default is `true`.
    public var showAverage = true {
        didSet {
            configureAverageView()
        }
    }
    
    // MARK: - Inits
    
    public init(chart: FLBarChart, style: FLCardStyle = .plain) {
        self.chartView = chart
        self.style = style
        super.init(frame: .zero)
        
        addLayoutGuide(contentGuide)
        NSLayoutConstraint.activate([
            contentGuide.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            contentGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contentGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            contentGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])

        configureViews()
        configureLegend()
        configureAverageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configurations
        
    private func configureViews() {
        style.shadow?.apply(to: self)
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        
        addSubview(titleLabel)
        titleLabel.text = chartView.chartData.title
        titleLabel.textColor = style.textColor
        titleLabel.font = .preferredFont(for: .headline, weight: .bold)
        titleLabel.constraints(equalTo: contentGuide, directions: [.top, .horizontal])

        addSubview(stackView)
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.constraints(equalTo: contentGuide, directions: [.bottom, .horizontal])
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15)
        ])
        
        stackView.addArrangedSubview(chartView)
        chartView.highlightingDelegate = self
    }
    
    private func configureLegend() {
        if showLegend {
            guard legend == nil else { return }
            legend = FLLegend(config: chartView.config, chartData: chartView.chartData)
            guard let legend = legend else { return }
            stackView.addArrangedSubview(legend)
        } else {
            guard let legend = legend else { return }
            stackView.removeArrangedSubview(legend)
            self.legend = nil
        }
    }
    
    private func configureAverageView() {
        if showAverage {
            guard averageLabel == nil else { return }
            
            averageLabel = UILabel()
            
            guard let averageLabel = averageLabel else { return }
            
            let attributedText = NSMutableAttributedString(string: "avg. ",
                                                           attributes: [.font : UIFont.preferredFont(for: .footnote, weight: .bold), .foregroundColor : FLColors.darkGray])
            attributedText.append(NSAttributedString(string: chartView.chartData.formattedAverage,
                                                     attributes: [.font : UIFont.preferredFont(for: .body, weight: .bold), .foregroundColor : FLColors.black]))
            addSubview(averageLabel)
            averageLabel.attributedText = attributedText
            averageLabel.constraints(equalTo: contentGuide, directions: [.top, .trailing])
        } else {
            averageLabel?.removeFromSuperview()
        }
    }
}

extension FLCard: ChartHighlightingDelegate {
    
    public func didBeginHighlighting() {
        UIView.animate(withDuration: 0.25) {
            self.titleLabel.alpha = 0
            self.averageLabel?.alpha = 0
        }
    }
    
    public func didEndHighlighting() {
        UIView.animate(withDuration: 0.25) {
            self.titleLabel.alpha = 1
            self.averageLabel?.alpha = 1
        }
    }
}
