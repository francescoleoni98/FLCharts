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
    private let headerStackView = UIStackView()
    private let stackView = UIStackView()
    private let contentGuide = UILayoutGuide()
    private var chartView: CardableChart!
    private var style: FLCardStyle
    
    /// Whether to show the legend. Default is `true`.
    public var showLegend: Bool = true {
        didSet {
            configureLegend()
        }
    }
    
    /// Whether to show the average view. Default is `true`.
    /// - Note: This property can be used only with bar and line charts. Else it will be `false`.
    public var showAverage = true {
        didSet {
            if let chartView = chartView as? FLChart {
                if !FLChart.canShowAverage(chartType: chartView.cartesianPlane.chartType, data: chartView.chartData) {
                    showAverage = false
                }
            } else {
                showAverage = false
            }
            
            configureAverageView()
        }
    }
    
    // MARK: - Inits
    
    /// Creates a card with a chart, title, average and legend.
    /// - Parameters:
    ///   - chart: The chart to display.
    ///   - style: The style of the card.
    public init(chart: CardableChart, style: FLCardStyle = .rounded) {
        self.chartView = chart
        self.style = style
        super.init(frame: .zero)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        self.style = .rounded
        super.init(coder: coder)
    }
    
    /// Sets up the card from the storyboard.
    /// Creates a card with a chart, title, average and legend.
    /// - Parameters:
    ///   - chart: The chart to display.
    ///   - style: The style of the card.
    public func setup(chart: CardableChart, style: FLCardStyle = .rounded) {
        self.chartView = chart
        self.style = style
        self.commonInit()
    }

    private func commonInit() {
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

    // MARK: - Configurations
        
    private func configureViews() {
        style.shadow?.apply(to: self)
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        
        addSubview(headerStackView)
        headerStackView.spacing = 10
        headerStackView.axis = .horizontal
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.constraints(equalTo: contentGuide, directions: [.top, .horizontal])

        titleLabel.text = chartView.title
        titleLabel.minimumScaleFactor = 0.7
        titleLabel.textColor = style.textColor
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = .preferredFont(for: .headline, weight: .bold)

        addSubview(stackView)
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.addArrangedSubview(chartView)
        stackView.constraints(equalTo: contentGuide, directions: [.bottom, .horizontal])
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15)
        ])
        
        if let chartView = chartView as? FLChart {
            chartView.highlightingDelegate = self
        }
    }

    private func configureLegend() {
        if showLegend {
            guard legend == nil else { return }
            legend = FLLegend(keys: chartView.legendKeys, formatter: chartView.formatter)
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
                                                           attributes: [.font: UIFont.preferredFont(for: .footnote, weight: .bold), .foregroundColor: FLColor.darkGray])
            attributedText.append(NSAttributedString(string: (chartView as? FLChart)?.chartData.formattedAverage ?? "",
                                                     attributes: [.font: UIFont.preferredFont(for: .body, weight: .bold), .foregroundColor: FLColor.black]))

            headerStackView.addArrangedSubview(averageLabel)
            averageLabel.minimumScaleFactor = 0.7
            averageLabel.adjustsFontSizeToFitWidth = true
            averageLabel.attributedText = attributedText
        } else {
            guard let averageLabel = averageLabel else { return }
            headerStackView.removeArrangedSubview(averageLabel)
            self.averageLabel?.removeFromSuperview()
        }
    }
}

extension FLCard: ChartHighlightingDelegate {
    
    public func didBeginHighlighting() {
        UIView.quickAnimation {
            self.titleLabel.alpha = 0
            self.averageLabel?.alpha = 0
        }
    }
    
    public func didEndHighlighting() {
        UIView.quickAnimation {
            self.titleLabel.alpha = 1
            self.averageLabel?.alpha = 1
        }
    }
}
