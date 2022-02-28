//
//  ScatterXAxis.swift
//  FLCharts
//
//  Created by Francesco Leoni on 04/02/22.
//

import UIKit

class ScatterXAxis: XAxisProvider {
    
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
        
        configureLines()
    }
            
    private func configureLines() {
        guard let data = chartData.dataEntries as? [ScatterPlotable],
              let maxXValue = data.maxFor(\.xValue) else { return }
        
        let maxX = maxXValue + (maxXValue * 0.1)
        
        let numberOfTicks = maxX / CGFloat(config.granularityX)
        
        for (index, value) in stride(from: 0, through: chartWidth, by: (chartWidth / numberOfTicks)).enumerated() {
            // Removes first x axes label when y axes if on the right.
            if value == 0, case .right = yAxisPosition {
                continue
            }

            let xPosition = value + chartLeft
            
            let text = chartData.xAxisFormatter?.string(from: NSNumber(value: config.granularityX * index)) ?? String(config.granularityX * index)
            let labelSize = text.size(withSystemFontSize: config.axesLabels.font.pointSize)
            
            let labelDrawPoint = CGPoint(x: xPosition - (labelSize.width.half),
                                         y: chartBottom + 10)
            
            labels.append(Label(text: text, point: labelDrawPoint, type: .xLabel))
                        
            if xPosition != 0 {
                xPositions.append(xPosition)
            }
        }
    }
}
