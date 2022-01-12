//
//  FLBarChart.swift
//  FLCharts
//
//  Created by Francesco Leoni on 01/06/21.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

/// A bar chart that displays one or more bars.
/// It takes a ``ChartBarCell`` in the initializer that allows to provide a custom bar cell.
public class FLBarChart: UIView {    
    
    private let collectionView = HighlightingCollectionView()
    private var collectionViewTrailing: NSLayoutConstraint!
    
    /// The left-bottom margins of the chart.
    private var margin: UIOffset { config.margin }
    
    /// The top margin of the chart.
    private let topMargin: CGFloat = 5
    
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
        
    /// Whether the bars are animated.
    public var animated: Bool = true
    
    /// Whether the chart should scroll horizontally.
    public var shouldScroll: Bool = true

    /// Whether to show the average line.
    public var showAverageLine: Bool = false {
        didSet {
            collectionViewTrailing.constant = showAverageLine ? -70 : 0
        }
    }

    /// Whether to show the dash lines.
    public var showDashedLines: Bool = true
    
    /// Whether to show the axes ticks.
    public var showTicks: Bool {
        get { config.showTicks }
        set { config.showTicks = newValue }
    }
    
    /// The height of the ticks.
    public var ticksHeight: CGFloat { config.ticksHeight }
        
    /// The color of the axes.
    public var axesColor: UIColor { config.axesColor }

    /// The line width of the axes.
    public var axesLineWidth: CGFloat { config.axesLineWidth }
        
    /// The width of the bar.
    /// - note: This value will be used only if ``shouldScroll`` is set to `true`. Else the width of the bar will be calculated based on the width of the chart.
    public var barWidth: CGFloat { config.barWidth }

    /// The color of the bars. The first color corrisponds to to bottom portion of the bar.
    public var barColors: [UIColor] { config.barColors }

    private var cellWidth: CGFloat { barWidth + config.barSpacing }
        
    /// The data to show in the chart.
    private var values: [BarData] = []
    
    private var chartData: ChartData

    /// The bar view to use in the chart.
    private var bar: ChartBar.Type = PlainChartBar.self
        
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
        backgroundColor = .white
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
        collectionViewTrailing = collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: topMargin),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin.horizontal + axesLineWidth),
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

        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY + topMargin
        let maxY = rect.maxY
        
        let chartWidth = maxX - margin.horizontal - minX
        let chartHeight = maxY - margin.vertical - minY

        let chartTopLeft = CGPoint(x: margin.horizontal, y: minY - (axesLineWidth / 2))
//        let chartTopRight = CGPoint(x: maxX, y: minY)
        let chartBottomLeft = CGPoint(x: margin.horizontal, y: chartHeight + minY + (axesLineWidth / 2))
        let chartBottomRight = CGPoint(x: maxX, y: chartHeight + minY + (axesLineWidth / 2))
        
        let thickerLines = CGMutablePath()
        let ticksLines = CGMutablePath()
        let dashedLines = CGMutablePath()

        thickerLines.addLines(between: [chartTopLeft,
                                        chartBottomLeft,
                                        chartBottomRight])

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
        
        let dataMinY: CGFloat = 0
        let dataMaxY: CGFloat = values.max(by: { $0.total < $1.total })?.total ?? 0
        
        for y in stride(from: dataMinY, through: dataMaxY, by: deltaY) {
            
            let chartTickY = yPosition(forValue: y)
            
            if y != 0 {
                if showTicks {
                    ticksLines.addLines(between: [CGPoint(x: margin.horizontal - ticksHeight, y: chartTickY),
                                                  CGPoint(x: margin.horizontal, y: chartTickY)])
                }
            }
            
            if y != minY, y != 0 {
                drawLabel(text: "\(Int(y))", yPosition: chartTickY)
            }
            
            if showDashedLines {
                let isNearZero = chartTickY < chartBottomRight.y && chartTickY > chartBottomRight.y - 5
                if !isNearZero {
                    dashedLines.addLines(between: [CGPoint(x: margin.horizontal, y: chartTickY),
                                                   CGPoint(x: maxX, y: chartTickY)])
                }
            }
        }
        
        if showTicks {
            ticksLines.addLines(between: [CGPoint(x: margin.horizontal - ticksHeight, y: minY),
                                          CGPoint(x: margin.horizontal, y: minY)])
        }
        
        if showAverageLine {
            let averageLineY = yPosition(forValue: chartData.average)
            
            /// Add label with value sopra average line
            let averageLabel = UILabel()
            averageLabel.text = String(format: "%.1f", chartData.average)
            averageLabel.textColor = .black
            averageLabel.font = .preferredFont(for: .subheadline, weight: .semibold)
            let textSize = averageLabel.intrinsicContentSize.width
            averageLabel.frame = CGRect(x: maxX - textSize - 5, y: averageLineY - 22, width: textSize, height: 20)
            addSubview(averageLabel)
            
            let unitOfMeasureLabel = UILabel()
            unitOfMeasureLabel.text = "avg. \(chartData.unitOfMeasure)"
            unitOfMeasureLabel.textColor = config.averageViewColor
            unitOfMeasureLabel.font = .preferredFont(for: .footnote, weight: .medium)
            let labelSize = unitOfMeasureLabel.intrinsicContentSize.width
            unitOfMeasureLabel.frame = CGRect(x: maxX - labelSize - 5, y: averageLineY + 2, width: labelSize, height: 20)
            addSubview(unitOfMeasureLabel)

            let line = UIView()
            line.backgroundColor = config.averageViewColor
            line.frame = CGRect(x: margin.horizontal, y: averageLineY, width: chartWidth, height: 2)
            addSubview(line)
        }
        
        drawLabel(text: "\(Int(dataMaxY))", yPosition: minY)
        
        context.setStrokeColor(axesColor.cgColor)
        context.setLineWidth(axesLineWidth)
        context.addPath(thickerLines)
//        context.strokePath()
        
//        context.setStrokeColor(axesColor.cgColor)
//        context.setLineWidth(axesLineWidth)
        context.addPath(ticksLines)
        context.strokePath()

        context.setStrokeColor(axesColor.withAlphaComponent(0.5).cgColor)
//        context.setLineWidth(axesLineWidth)
        context.setLineDash(phase: 0, lengths: [3])
        context.addPath(dashedLines)
        context.strokePath()
        
        /// Whenever you change a graphics context you should save it prior and restore it after
        /// if we were using a context other than `draw(_:)` we would have to also end the graphics context.
        context.restoreGState()
        
        func yPosition(forValue value: CGFloat) -> CGFloat {
            let percentageOfTotal = value / dataMaxY * 100
            let viewHeight = chartHeight * percentageOfTotal / 100
            return chartHeight - viewHeight + minY
        }
    }
    
    private func drawLabel(text: String, yPosition: CGFloat) {
        let centeringConstant: CGFloat = 4 // 2.5
        let label = text as NSString
        let labelSize = text.size(withSystemFontSize: 13)
        let labelDrawPoint = CGPoint(x: margin.horizontal - labelSize.width - ticksHeight - centeringConstant, y: yPosition - (labelSize.height / 2))
        
        label.draw(at: labelDrawPoint,
                   withAttributes: [.font: UIFont.preferredFont(for: .footnote, weight: .medium),
                                    .foregroundColor: axesColor])
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
