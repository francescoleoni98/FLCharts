//
//  FLCartesianPlane.swift
//  FLCharts
//
//  Created by Francesco Leoni on 18/01/22.
//

import UIKit

/// Defines a horizontal position.
public enum YPosition {
    case left
    case right
}

/// The cartesian plane on which the chart is plotted.
public class FLCartesianPlane: UIView, FLStylable {
    
    /// The configuration of the chart.
    public var config: FLChartConfig = FLChartConfig() {
        didSet {
            updateConfigGranularityY()
        }
    }
    
    /// The data to show in the chart.
    private var chartData: FLChartData
    
    /// The margins of the chart.
    private var margin: UIEdgeInsets { config.margin }
    
    private var marginForAverageView: CGFloat = 0
    
    private let chartLayoutGuide = UILayoutGuide()
    
    internal var didUpdateChartLayoutGuide: (UILayoutGuide) -> Void = { _ in }
    
    internal let chartType: FLChart.PlotType
    
    /// The position of the y axis.
    public var yAxisPosition: YPosition = .left
    
    /// Whether to show the axes ticks.
    internal var showTicks: Bool = true
    
    /// Whether to show the dash lines.
    public var showDashedLines: Bool = true
    
    /// Whether to show the axes unit of measure.
    public var showUnitsOfMeasure: Bool = true

    /// Whether to show the average line.
    public var showAverageLine: Bool = false {
        didSet {
            if !FLChart.canShowAverage(chartType: chartType, data: chartData) {
                showAverageLine = false
            }
        }
    }
    
    // MARK: - Internal Properties
    
    private var rect: CGRect = .zero
    
    private var chartLeft: CGFloat { rect.minX + margin.left }
    private var chartRight: CGFloat { rect.maxX - margin.right }
    private var chartTop: CGFloat { rect.minY + margin.top - config.axesLines.lineWidth.half }
    private var chartBottom: CGFloat { rect.maxY - margin.bottom + config.axesLines.lineWidth.half }
    
    private var chartTopLeft: CGPoint { CGPoint(x: chartLeft, y: chartTop) }
    private var chartTopRight: CGPoint { CGPoint(x: chartRight, y: chartTop) }
    private var chartBottomLeft: CGPoint { CGPoint(x: chartLeft, y: chartBottom) }
    private var chartBottomRight: CGPoint { CGPoint(x: chartRight, y: chartBottom) }
    
    private var chartWidth: CGFloat { chartRight - chartLeft }
    private var chartHeight: CGFloat { chartBottom - chartTop }
    
    private var axesLines = CGMutablePath()
    private var ticksLines = CGMutablePath()
    private var dashedLines = CGMutablePath()
    
    private let xUnitLabelSpacing: CGFloat = -5
    private let yUnitLabelSpacing: CGFloat = 5
    private let tickLabelSpacing: CGFloat = 4
    private let dataMinValue: CGFloat = 0
    private var dataMaxValue: CGFloat { chartData.maxYValue(forType: chartType) ?? 0 }
    
    private let labels = Labels()
    
    // MARK: - Inits
    
    /// Creates a cartesian plane with the provided chart data.
    internal init(data: FLChartData, type: FLChart.PlotType) {
        self.chartData = data
        self.chartType = type
        super.init(frame: .zero)
        self.config.granularityY = data.defaultYGranularity(forType: type)
        self.backgroundColor = .clear
        
        self.addLayoutGuide(chartLayoutGuide)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Updates the values of the chart with new data.
    internal func updateData(_ data: [PlotableData]) {
        self.chartData.dataEntries = data
        self.updateConfigGranularityY()
        self.setNeedsDisplay()
    }
    
    // MARK: - Overrides
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        self.rect = rect
        
        context.saveGState()
        
        labels.clearLabels()
        axesLines = CGMutablePath()
        ticksLines = CGMutablePath()
        dashedLines = CGMutablePath()
        config.resetDefaultMargins()

        guard dataMaxValue > 0 else {
            drawNoDataLabel()
            return
        }
        
        if showUnitsOfMeasure {
            drawYAxisUnitOfMeasure()
            drawXAxisUnitOfMeasure()
        }
        
        drawYAxisLabels()
        
        labels.editLabels(types: .yLabel, .topYLabel) { label in
            var labelXPosition: CGFloat = 0
            
            if yAxisPosition == .left {
                labelXPosition = chartLeft - config.tick.lineLength - tickLabelSpacing - label.size.width
            } else {
                labelXPosition = chartRight + config.tick.lineLength + tickLabelSpacing
            }
            
            label.point = CGPoint(x: labelXPosition, y: label.point.y - (label.size.height.half))
        }
        
        drawAverageLineIfNeeded()
        drawAxesLines()

        labels.editLabels(types: .xUnitOfMeasure) { label in
            let xPosition = ((chartWidth - marginForAverageView).half) - (label.size.width.half)
            
            if yAxisPosition == .left {
                label.point.x = xPosition + margin.left
            } else {
                label.point.x = xPosition + marginForAverageView
            }
        }
                
        let xAxisProvider: XAxisProvider? = {
            let chartRect = CGRect(x: chartLeft, y: chartTop, width: chartWidth, height: chartHeight)
            
            switch chartType {
            case .bar: return nil
                
            case .line:
                let usefulChartWidth = showAverageLine ? (chartWidth - marginForAverageView) : chartWidth
                let startXPosition = showAverageLine ? (yAxisPosition == .left ? 0 : marginForAverageView) : 0
                
                let lineDraw = LineXAxis(data: chartData, config: config, chartRect: chartRect, yAxisPosition: yAxisPosition)
                lineDraw.configureLines(startXPosition: startXPosition, usefulChartWidth: usefulChartWidth)
                return lineDraw
                
            case .scatter:
                return ScatterXAxis(data: chartData, config: config, chartRect: chartRect, yAxisPosition: yAxisPosition)
            }
        }()
        
        if let xAxisProvider = xAxisProvider {
            xAxisProvider.xPositions.forEach { xPosition in
                drawTick(at: [CGPoint(x: xPosition, y: chartBottom),
                              CGPoint(x: xPosition, y: chartBottom + config.tick.lineLength)])
                
                drawDashedLine(at: [CGPoint(x: xPosition, y: chartTop),
                                    CGPoint(x: xPosition, y: chartBottom)])
            }
            
            labels.add(xAxisProvider.labels)
            
            labels.editLabels(types: .xLabel) { label in
                label.point.y = chartBottom + config.tick.lineLength
            }
        }
        
        for label in labels.labels {
            drawLabel(text: label.text, inPoint: label.point)
            
            if label.type == .yLabel || label.type == .topYLabel {
                drawYTick(at: label.point.y + label.size.height.half)
                drawHorizontalDashedLine(at: label.point.y + label.size.height.half)
            }
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
        
        updateChartLayoutGuide()
    }
    
    // MARK: - Draw methods
    
    private func drawAxesLines() {
        if yAxisPosition == .left {
            axesLines.addLines(between: [chartTopLeft,
                                         chartBottomLeft,
                                         chartBottomRight])
        } else {
            axesLines.addLines(between: [chartTopRight,
                                         chartBottomRight,
                                         chartBottomLeft])
        }
    }
    
    private func drawXAxisUnitOfMeasure() {
        if let xUnitOfMeasure = chartData.xAxisUnitOfMeasure {
            let text = xUnitOfMeasure
            let size = sizeForText(text)
            config.setMarginBottom(to: size.height + xUnitLabelSpacing)
            
            let point = CGPoint(x: ((chartWidth - marginForAverageView).half) - (size.width.half) + margin.left,
                                y: rect.maxY - size.height)
            labels.add(Label(text: text, size: size, point: point, type: .xUnitOfMeasure))
        }
    }
    
    private func drawYAxisUnitOfMeasure() {
        let text = chartData.yAxisUnitOfMeasure
        let size = sizeForText(text)
        config.setMarginTop(to: size.height + yUnitLabelSpacing)
        
        let point = CGPoint(x: yAxisPosition == .left ? 0 : chartRight - size.width,
                            y: rect.minY)
        labels.add(Label(text: text, size: size, point: point, type: .yUnitOfMeasure))
    }
    
    private func drawYAxisLabels() {
        let step = config.granularityY
        var maxYLabelWidth: CGFloat = 0
        
        if step > 0 {
            for value in stride(from: dataMinValue, through: dataMaxValue, by: step) {
                guard value > 0 else { continue }
                
                let chartTickY = yPosition(forValue: value)
                let (text, size) = textSizeFrom(value: value)
                labels.add(Label(text: text, size: size, point: CGPoint(x: 0, y: chartTickY), type: .yLabel))
            }
        }
        
        // This prevents the last label to overlap the max label.
        if let lastLabel = labels.find(type: .yLabel).last, lastLabel.point.y - chartTop > 15 {
            let (text, size) = textSizeFrom(value: dataMaxValue)
            labels.add(Label(text: text, size: size, point: CGPoint(x: 0, y: chartTop), type: .topYLabel))
        }
        
        config.setMargin(for: yAxisPosition, horizontalMargin: maxYLabelWidth + config.tick.lineLength + tickLabelSpacing)
        
        func textSizeFrom(value: CGFloat) -> (text: String, size: CGSize) {
            let text = chartData.yAxisFormatter.string(from: NSNumber(value: value))
            let size = sizeForText(text)
            
            if size.width > maxYLabelWidth {
                maxYLabelWidth = size.width
            }
            
            return (text, size)
        }
    }
    
    private func drawNoDataLabel() {
        let text = "No data available"
        let size = sizeForText(text)
        
        drawLabel(text: text, inPoint: CGPoint(x: rect.width.half - size.width.half, y: rect.height.half))
    }
    
    private func drawAverageLineIfNeeded() {
        if showAverageLine {
            let averageLineY = yPosition(forValue: chartData.average)
            let spacingFromLine: CGFloat = 2
            
            let averageLabel = UILabel()
            averageLabel.text = chartData.formattedAverage
            averageLabel.font = config.averageView.primaryFont
            averageLabel.textColor = config.averageView.primaryColor
            let averageLabelSize = averageLabel.intrinsicContentSize
            averageLabel.frame = CGRect(x: xPositionForAverageLabel(averageLabel),
                                        y: averageLineY - averageLabelSize.height - spacingFromLine,
                                        width: averageLabelSize.width,
                                        height: averageLabelSize.height)
            addSubview(averageLabel)
            
            let unitOfMeasureLabel = UILabel()
            unitOfMeasureLabel.text = "avg. \(chartData.yAxisUnitOfMeasure)"
            unitOfMeasureLabel.font = config.averageView.secondaryFont
            unitOfMeasureLabel.textColor = config.averageView.secondaryColor
            let unitOfMeasureLabelSize = unitOfMeasureLabel.intrinsicContentSize
            unitOfMeasureLabel.frame = CGRect(x: xPositionForAverageLabel(unitOfMeasureLabel),
                                              y: averageLineY + spacingFromLine,
                                              width: unitOfMeasureLabelSize.width,
                                              height: unitOfMeasureLabelSize.height)
            addSubview(unitOfMeasureLabel)
            
            let line = UIView()
            line.backgroundColor = config.averageView.lineColor
            line.frame = CGRect(x: chartLeft, y: averageLineY, width: chartWidth, height: config.averageView.lineWidth)
            addSubview(line)
            
            marginForAverageView = max(averageLabelSize.width, unitOfMeasureLabelSize.width) + 15
        }
    }
        
    private func drawYTick(at position: CGFloat) {
        if yAxisPosition == .left {
            drawTick(at: [CGPoint(x: chartLeft - config.tick.lineLength, y: position),
                          CGPoint(x: chartLeft, y: position)])
        } else {
            drawTick(at: [CGPoint(x: chartRight + config.tick.lineLength, y: position),
                          CGPoint(x: chartRight, y: position)])
        }
    }
    
    private func drawHorizontalDashedLine(at position: CGFloat) {
        drawDashedLine(at: [CGPoint(x: chartLeft, y: position),
                            CGPoint(x: chartRight, y: position)])
    }
    
    private func drawLabel(text: String, inPoint point: CGPoint) {
        (text as NSString).draw(at: point, withAttributes: [.font: config.axesLabels.font,
                                                            .foregroundColor: config.axesLabels.color])
    }
    
    private func updateChartLayoutGuide() {
        var leadingConstant: CGFloat = 0
        var trailingConstant: CGFloat = 0
        
        switch yAxisPosition {
        case .left:
            leadingConstant = margin.left + config.axesLines.lineWidth
            trailingConstant = showAverageLine ? marginForAverageView + margin.right : margin.right
            
        case .right:
            leadingConstant = showAverageLine ? marginForAverageView + margin.left : margin.left
            trailingConstant = margin.right + config.axesLines.lineWidth
        }
        
        var labelHeight: CGFloat = 0
        
        if let xUnitOfMeasure = labels.find(type: .xUnitOfMeasure).first {
            labelHeight = xUnitOfMeasure.size.height + xUnitLabelSpacing
        }
                
        NSLayoutConstraint.activate([
            chartLayoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: margin.top),
            chartLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstant),
            chartLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -labelHeight),
            chartLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingConstant)
        ])
        
        didUpdateChartLayoutGuide(chartLayoutGuide)
    }
    
    private func updateConfigGranularityY() {
        if config.granularityY == 0 {
            config.granularityY = chartData.defaultYGranularity(forType: chartType)
        }
    }
    
    // MARK: - Helpers
    
    private func drawTick(at points: [CGPoint]) {
        if showTicks {
            ticksLines.addLines(between: points)
        }
    }
    
    private func drawDashedLine(at points: [CGPoint]) {
        if showDashedLines {
            dashedLines.addLines(between: points)
        }
    }

    private func sizeForText(_ text: String) -> CGSize {
        text.size(withSystemFontSize: config.axesLabels.font.pointSize)
    }
    
    private func yPosition(forValue value: CGFloat) -> CGFloat {
        let percentageOfTotal = value / dataMaxValue * 100
        let viewHeight = chartHeight * percentageOfTotal / 100
        return chartHeight - viewHeight + chartTop
    }
    
    private func xPositionForAverageLabel(_ label: UILabel) -> CGFloat {
        if yAxisPosition == .left {
            return chartRight - label.intrinsicWidth - 5
        } else {
            return chartLeft + 5
        }
    }
}
