//
//  LineXAxis.swift
//  FLCharts
//
//  Created by Francesco Leoni on 04/02/22.
//

import UIKit

class LineXAxis: XAxisProvider {

    var xPositions: [CGFloat] = []
    var labels: [Label] = []
    
    let yAxisPosition: YPosition
    let chartData: FLChartData
    let config: FLChartConfig
    let chartRect: CGRect

    required init(data: FLChartData, config: FLChartConfig, chartRect: CGRect, yAxisPosition: YPosition) {
        self.chartData = data
        self.config = config
        self.chartRect = chartRect
        self.yAxisPosition = yAxisPosition
    }

    func configureLines(startXPosition: CGFloat, usefulChartWidth: CGFloat) {
        let entriesCount = chartData.dataEntries.count - 1

        let step = usefulChartWidth / CGFloat(entriesCount)

        for (index, x) in stride(from: startXPosition, through: chartWidth, by: step).enumerated() {
            // Removes last x axes label when y axes if on the left.
            if index >= entriesCount, case .left = yAxisPosition {
                continue
            }

            // Removes first x axes label when y axes if on the right.
            if x == 0, case .right = yAxisPosition {
                continue
            }

            guard index.isMultiple(of: config.granularityX) else { continue }

            let percentageOfTotal = x / chartWidth
            let viewWidth = chartWidth * percentageOfTotal
            let XPosition = chartLeft + viewWidth

            let text = chartData.dataEntries[index].name
            let labelSize = text.size(withSystemFontSize: config.axesLabels.font.pointSize)

            let labelDrawPoint = CGPoint(x: XPosition - (labelSize.width.half),
                                         y: chartBottom + 10)

            labels.append(Label(text: text, point: labelDrawPoint, type: .xLabel))

            if x != 0 {
                xPositions.append(XPosition)
            }
        }
    }
}
