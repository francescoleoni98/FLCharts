//
//  FLBarChart.swift
//  FLCharts
//
//  Created by Francesco Leoni on 01/06/21.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

/// Defines a horizontal position.
public enum YPosition {
    case left
    case right
}

/// A bar chart that displays one or more bars.
/// It takes a ``ChartBarCell`` in the initializer that allows to provide a custom bar cell.
public class FLBarChart: UIView {    
    
    private let collectionView = HighlightingCollectionView()
    private var collectionViewTop: NSLayoutConstraint!
    private var collectionViewLeading: NSLayoutConstraint!
    private var collectionViewTrailing: NSLayoutConstraint!
    
    /// The left-bottom margins of the chart.
    private var margin: UIEdgeInsets { config.margin }
        
    /// The configuration of the chart
    public var config: ChartConfig {
        get { collectionView.config }
        set { collectionView.config = newValue }
    }
    
    /// The granularity of the X axis.
    public var deltaX: Int { config.deltaX }

    /// The granularity of the Y axis.
    /// Eg. deltaY = 10 means that every number on the Y axes is a multiple of 10.
    public var deltaY: CGFloat { config.deltaY }
    
    /// The position of the y axis.
    public var yAxisPosition: YPosition = .left {
        didSet {
            config.setMargin(for: yAxisPosition)
            updateCollectionConstraints()
        }
    }
    
    /// Whether the bars are animated.
    public var animated: Bool = true
    
    /// Whether to show the axes ticks.
    public var showTicks: Bool = true

    /// Whether the chart should scroll horizontally.
    public var shouldScroll: Bool = true

    /// Whether to show the dash lines.
    public var showDashedLines: Bool = true
    
    /// Whether to show the average line.
    public var showAverageLine: Bool = false {
        didSet {
            updateCollectionConstraints()
        }
    }
            
    /// The data to show in the chart.
    private var values: [BarData] = []
    
    public private(set) var chartData: ChartData

    /// The bar view to use in the chart.
    private var bar: ChartBar.Type = PlainChartBar.self
        
    private var cellWidth: CGFloat { config.bar.width + config.bar.spacing }

    public weak var highlightingDelegate: ChartHighlightingDelegate? {
        didSet {
            collectionView.highlightingDelegate = highlightingDelegate
        }
    }

    // MARK: - Inits
        
    /// Creates a bar chart with the provided chart data.
    ///
    /// If you need a different bar style provide a ``ChartBar``.
    ///
    /// If you need a highlight behaviour provide a ``HighlightedView``.
    public init(data: ChartData, bar: ChartBar.Type = PlainChartBar.self, highlightView: HighlightedView? = nil) {
        self.chartData = data
        super.init(frame: .zero)
        self.bar = bar
        self.collectionView.highlightedView = highlightView
        commonInit(data: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(data: ChartData) {
        backgroundColor = .clear
        configureCollectionView()
        self.collectionView.getChartData = { data }
        self.values = data.barData
        self.config.deltaY = (chartData.maxBarData?.total ?? 100) / 3
        self.setNeedsDisplay()
        self.collectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.animated = false
        }
    }
    
    /// Updates the values of the chart.
    public func updateData(_ data: [BarData]) {
        self.values = data
        self.chartData.barData = data
        self.setNeedsDisplay()
        self.collectionView.reloadData()
    }

    // MARK: - Configurations
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ChartBarCell.self, forCellWithReuseIdentifier: ChartBarCell.identifier)
        
        addSubview(collectionView)
        collectionViewTop = collectionView.topAnchor.constraint(equalTo: topAnchor, constant: margin.top)
        collectionViewLeading = collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin.left + config.axesLines.lineWidth)
        collectionViewTrailing = collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin.right)
        
        NSLayoutConstraint.activate([
            collectionViewTop,
            collectionViewLeading,
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionViewTrailing
        ])
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        drawAxes(in: context, rect: rect)
    }

    private func drawAxes(in context: CGContext, rect: CGRect) {
        context.saveGState()

        let halfAxesWidth = config.axesLines.lineWidth / 2

        let chartLeft = rect.minX + margin.left
        let chartRight = rect.maxX - margin.right
        let chartTop = rect.minY + margin.top - halfAxesWidth
        let chartBottom = rect.maxY - margin.bottom + halfAxesWidth
        
        let chartWidth = chartRight - chartLeft
        let chartHeight = chartBottom - chartTop
        
        let chartTopLeft = CGPoint(x: chartLeft, y: chartTop)
        let chartTopRight = CGPoint(x: chartRight, y: chartTop)
        let chartBottomLeft = CGPoint(x: chartLeft, y: chartBottom)
        let chartBottomRight = CGPoint(x: chartRight, y: chartBottom)
        
        let axesLines = CGMutablePath()
        let ticksLines = CGMutablePath()
        let dashedLines = CGMutablePath()

        if yAxisPosition == .left {
            axesLines.addLines(between: [chartTopLeft,
                                         chartBottomLeft,
                                         chartBottomRight])
        } else {
            axesLines.addLines(between: [chartTopRight,
                                         chartBottomRight,
                                         chartBottomLeft])
        }

        /* Labels */
        
        /* X Axis labels and ticks */
        
        //        for (index, x) in stride(from: 0, through: chartWidth, by: BarWidth.totalWidth).enumerated() {
        //
        //            let percentageOfTotal = x / chartWidth * 100
        //            let viewWidth = chartWidth * percentageOfTotal / 100
        //            let chartTickX = margin + viewWidth + centeringConstant
        //
        //            if x != 0 {
        //                let tickPoints = showTicks
        //                    ? [CGPoint(x: chartTickX, y: chartHeight),
        //                       CGPoint(x: chartTickX, y: chartHeight + ticksHeight)]
        //                    : []
        //
        //                thinnerLines.addLines(between: tickPoints)
        //            }
        //
        //            if x != minX {
        //                var labelText = "-"
        //
        //                if index - 1 <= (values.count - 1) {
        //                    labelText = values[index - 1].name
        //                }
        //
        //                let label = labelText as NSString
        //                let labelSize = labelText.size(withSystemFontSize: 15)
        //                let labelDrawPoint = CGPoint(
        //                    x: chartTickX - labelSize.width - ((BarWidth.totalWidth - labelSize.width) / 2),
        //                    y: chartHeight + 10)
        //
        //                label.draw(at: labelDrawPoint,
        //                           withAttributes: [.font: UIFont.systemFont(ofSize: 15),
        //                                            .foregroundColor: axesColor])
        //            }
        //        }
        
        /* Y Axis labels and ticks */
        
        let dataMinValue: CGFloat = 0
        let dataMaxValue: CGFloat = chartData.maxBarData?.total ?? 0
        
        for y in stride(from: dataMinValue, through: dataMaxValue, by: deltaY) {
            let chartTickY = yPosition(forValue: y)
            
            if y != 0 {
                if showTicks {
                    if yAxisPosition == .left {
                        ticksLines.addLines(between: [CGPoint(x: chartLeft - config.tick.lineLength, y: chartTickY),
                                                      CGPoint(x: chartLeft, y: chartTickY)])
                    } else {
                        ticksLines.addLines(between: [CGPoint(x: chartRight + config.tick.lineLength, y: chartTickY),
                                                      CGPoint(x: chartRight, y: chartTickY)])
                    }
                }
                
                if y != chartTop {
                    drawLabel(text: "\(Int(y))", yPosition: chartTickY)
                }
            }

            if showDashedLines {
                let isNearZero = chartTickY < chartBottomRight.y && chartTickY > chartBottomRight.y - 5
                if !isNearZero {
                    dashedLines.addLines(between: [CGPoint(x: chartLeft, y: chartTickY),
                                                   CGPoint(x: chartRight, y: chartTickY)])
                }
            }
        }
        
        // The max value label.
        drawLabel(text: "\(Int(dataMaxValue))", yPosition: chartTop)

        /* Ticks */
        
        if showTicks {
            if yAxisPosition == .left {
                ticksLines.addLines(between: [CGPoint(x: chartLeft - config.tick.lineLength, y: chartTop),
                                              CGPoint(x: chartLeft, y: chartTop)])
            } else {
                ticksLines.addLines(between: [CGPoint(x: chartRight + config.tick.lineLength, y: chartTop),
                                              CGPoint(x: chartRight, y: chartTop)])
            }
        }
        
        /* Average line */
        
        if showAverageLine {
            let averageLineY = yPosition(forValue: chartData.average)
            let spacingFromLine: CGFloat = 2
            
            let averageLabel = UILabel()
            averageLabel.text = chartData.formattedAverage
            averageLabel.textColor = config.averageView.primaryColor
            averageLabel.font = config.averageView.primaryFont
            let averageLabelSize = averageLabel.intrinsicContentSize
            
            averageLabel.frame = CGRect(x: xPositionForAverageLabel(averageLabel), y: averageLineY - averageLabelSize.height - spacingFromLine,
                                        width: averageLabelSize.width, height: averageLabelSize.height)
            addSubview(averageLabel)
            
            let unitOfMeasureLabel = UILabel()
            unitOfMeasureLabel.text = "avg. \(chartData.unitOfMeasure)"
            unitOfMeasureLabel.textColor = config.averageView.secondaryColor
            unitOfMeasureLabel.font = config.averageView.secondaryFont
            let unitOfMeasureLabelSize = unitOfMeasureLabel.intrinsicContentSize
            
            unitOfMeasureLabel.frame = CGRect(x: xPositionForAverageLabel(unitOfMeasureLabel), y: averageLineY + spacingFromLine,
                                              width: unitOfMeasureLabelSize.width, height: unitOfMeasureLabelSize.height)
            addSubview(unitOfMeasureLabel)

            let line = UIView()
            line.backgroundColor = config.averageView.lineColor
            line.frame = CGRect(x: chartLeft, y: averageLineY, width: chartWidth, height: config.averageView.lineWidth)
            addSubview(line)
            
            marginForAverageView = max(averageLabelSize.width, unitOfMeasureLabelSize.width) + 15
            updateCollectionConstraints()
        }
                
        context.setStrokeColor(config.axesLines.color.cgColor)
        context.setLineWidth(config.axesLines.lineWidth)
        context.addPath(axesLines)
        context.strokePath()
        
        context.setStrokeColor(config.tick.color.cgColor)
        context.setLineWidth(config.tick.lineWidth)
        context.addPath(ticksLines)
        context.strokePath()

        context.setStrokeColor(config.dashedLines.color.cgColor)
        context.setLineWidth(config.dashedLines.lineWidth)
        context.setLineDash(phase: 0, lengths: [config.dashedLines.dashWidth])
        context.addPath(dashedLines)
        context.strokePath()
        
        /// Whenever you change a graphics context you should save it prior and restore it after
        /// if we were using a context other than `draw(_:)` we would have to also end the graphics context.
        context.restoreGState()
        
        func yPosition(forValue value: CGFloat) -> CGFloat {
            let percentageOfTotal = value / dataMaxValue * 100
            let viewHeight = chartHeight * percentageOfTotal / 100
            return chartHeight - viewHeight + chartTop
        }
        
        func drawLabel(text: String, yPosition: CGFloat) {
            let centeringConstant: CGFloat = 4 // 2.5
            let label = text as NSString
            let labelSize = text.size(withSystemFontSize: config.axesLabels.font.pointSize)
            
            var labelXPosition: CGFloat = 0
            
            if yAxisPosition == .left {
                labelXPosition = chartLeft - labelSize.width - config.tick.lineLength - centeringConstant
            } else {
                labelXPosition = chartRight + config.tick.lineLength + centeringConstant
            }
            
            let labelDrawPoint = CGPoint(x: labelXPosition, y: yPosition - (labelSize.height / 2))
            
            label.draw(at: labelDrawPoint,
                       withAttributes: [.font: config.axesLabels.font,
                                        .foregroundColor: config.axesLabels.color])
        }
        
        func xPositionForAverageLabel(_ label: UILabel) -> CGFloat {
            if yAxisPosition == .left {
                return chartRight - label.intrinsicContentSize.width - 5
            } else {
                return chartLeft + 5
            }
        }
    }
    
    // MARK: - Helpers
    
    private var marginForAverageView: CGFloat = 70
    
    private func updateCollectionConstraints() {
        switch yAxisPosition {
        case .left:
            collectionViewLeading.constant = margin.left + config.axesLines.lineWidth
            collectionViewTrailing.constant = showAverageLine ? -marginForAverageView - margin.right : -margin.right
            
        case .right:
            collectionViewTrailing.constant = -margin.right - config.axesLines.lineWidth
            collectionViewLeading.constant = showAverageLine ? marginForAverageView + margin.left : margin.left
        }
    }
}

// MARK: - UICollectionView Data Source

extension FLBarChart: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return values.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartBarCell.identifier, for: indexPath) as! ChartBarCell
        cell.config = config
        cell.shouldShowTicks = showTicks
        cell.configure(withBar: bar.init())

        if let max = chartData.maxBarData {
            let barData = values[indexPath.item]
            let ratio = barData.total / max.total
                        
            cell.setBarHeight(ratio, barData: barData, animated: animated)
        }
        
        if indexPath.item % deltaX != 0 {
            cell.xAxisLabel.isHidden = true
        }
        
        return cell
    }
}

// MARK: - UICollectionView Flow Layout

extension FLBarChart: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if shouldScroll {
            return CGSize(width: cellWidth, height: collectionView.frame.height)
        } else {
            let numberOfBars = CGFloat(values.count)
            let cellWidth = collectionView.frame.width / numberOfBars
            return CGSize(width: cellWidth, height: collectionView.frame.height)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
