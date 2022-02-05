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
    
    var yAxisPosition: YPosition = .left
    
    let chartData: FLChartData
    let config: FLChartConfig
    let chartRect: CGRect

    required init(data: FLChartData, config: FLChartConfig, chartRect: CGRect) {
        self.chartData = data
        self.config = config
        self.chartRect = chartRect
    }

    func configureLines(startXPosition: CGFloat, usefulChartWidth: CGFloat) {
        let entriesCount = chartData.dataEntries.count - 1

        let step = usefulChartWidth / CGFloat(entriesCount)

        for (index, x) in stride(from: startXPosition, through: chartWidth, by: step).enumerated() {
            guard index.isMultiple(of: config.granularityX) else { continue }

            let percentageOfTotal = x / chartWidth
            let viewWidth = chartWidth * percentageOfTotal
            let XPosition = chartLeft + viewWidth

            // Removes last x axes label when y axes if on the left.
            if index >= entriesCount, case .left = yAxisPosition {
                continue
            }

            // Removes first x axes label when y axes if on the right.
            if x == 0, case .right = yAxisPosition {
                continue
            }

            let text = chartData.dataEntries[index].name
            let labelSize = text.size(withSystemFontSize: config.axesLabels.font.pointSize)

            let labelDrawPoint = CGPoint(x: XPosition - (labelSize.width / 2),
                                         y: chartBottom + 10)

            labels.append(Label(text: text, point: labelDrawPoint))

            if x != 0 {
                xPositions.append(XPosition)
            }
        }
    }
}
