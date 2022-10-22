//
//  ViewController.swift
//  FLCharts
//
//  Created by francescoleoni98 on 01/11/2022.
//  Copyright (c) 2022 francescoleoni98. All rights reserved.
//

import UIKit
import FLCharts

class ViewController: UIViewController {
    
  @IBOutlet weak var chartView: FLChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let scatterChartData = FLChartData(title: "Ages",
                                           data: scatterData,
                                           legendKeys: [Key(key: "Age", color: .dusk)],
                                           unitOfMeasure: "years")
        scatterChartData.xAxisUnitOfMeasure = "days of birth"
        
        chartView.setup(data: FLChartData(title: "Line", data: monthsData, legendKeys: [Key(key: "1", color: .green), Key(key: "2", color: .blue), Key(key: "3", color: .red)], unitOfMeasure: "kWh"), type: .line())
        chartView.cartesianPlane.yAxisPosition = .right
        chartView.config.dashedLines.color = .red
        
        let barChartData = FLChartData(title: "Consumptions",
                                       data: monthsData,
                                       legendKeys: [
                                        Key(key: "1", color: .white(0.9)),
                                        Key(key: "2", color: .white(0.9)),
                                        Key(key: "3", color: .white(0.9))


//                                        Key(key: "F1", yThresholds: [40 : .red,
//                                                                     56 : .blue,
//                                                                     84 : .green,
//                                                                     100 : .orange],
//                                            data: monthsData),
//                                        Key(key: "F2", xColors: [.red,
//                                                                 .blue,
//                                                                 .green,
//                                                                 .orange]),
//                                        Key(key: "F3", xColors: [.red,
//                                                                 .blue,
//                                                                 .green,
//                                                                 .orange])
                                       ],
                                       unitOfMeasure: "kWh")
        barChartData.xAxisUnitOfMeasure = "months"
        barChartData.yAxisFormatter = .decimal(2)
        
        let pieChart = FLPieChart(title: "Platforms",
                                  data: [FLPiePlotable(value: 51.7, key: Key(key: "Desktop", color: FLColor(hex: "138CFD"))),
                                         FLPiePlotable(value: 25.2, key: Key(key: "Mobile", color: FLColor(hex: "4DA8FF"))),
                                         FLPiePlotable(value: 14.7, key: Key(key: "Table", color: FLColor(hex: "A7CBF6"))),
                                         FLPiePlotable(value: 10.8, key: Key(key: "Other", color: FLColor(hex: "F0F4FA")))],
                                  border: .full,
                                  formatter: .percent,
                                  animated: true)
        
        runOnMain(after: 2) {
            pieChart.updateData([FLPiePlotable(value: 52, key: Key(key: "Desktop", color: FLColor(hex: "138CFD"))),
                                 FLPiePlotable(value: 34, key: Key(key: "Mobile", color: FLColor(hex: "4DA8FF"))),
                                 FLPiePlotable(value: 66, key: Key(key: "Table", color: FLColor(hex: "A7CBF6"))),
                                 FLPiePlotable(value: 10.8, key: Key(key: "Other", color: FLColor(hex: "F0F4FA")))], animated: true)
        }
        
        let radarChart = FLRadarChart(title: "Radar",
                                      categories: ["Knowledge", "Delivery", "Effectiveness", "Helpful", "Punctual"],
                                      data: [FLDataSet(data: [5, 4.7, 4, 3, 5], key: Key(key: "Graham", color: FLColor(.systemPink))),
                                             FLDataSet(data: [3, 4, 5, 4.7, 3], key: Key(key: "Barbara", color: .seaBlue)),
                                             FLDataSet(data: [2, 3.5, 2, 4, 3], key: Key(key: "Keith", color: FLColor(.systemGreen)))],
                                      formatter: .decimal(2),
                                      config: FLRadarGridConfig(divisions: 4))
        radarChart.showLabels = true
        radarChart.showXAxisLabels = true
        radarChart.showYAxisLabels = true
        
        let lineChart = FLChart(data: barChartData, type: .bar(highlightView: BarHighlightedView(), config: FLBarConfig(radius: .corners(corners: [.layerMaxXMinYCorner, .layerMinXMaxYCorner], 3), width: 30)))
//      lineChart.showXAxis = false
//      lineChart.showYAxis = false
        lineChart.averageLineOverlapsChart = true
        lineChart.showAverageLine = true
        lineChart.showDashedLines = false
        lineChart.config = FLChartConfig(granularityY: 40, averageView: FLAverageViewConfig(lineWidth: 5, primaryFont: .systemFont(ofSize: 14, weight: .heavy), secondaryFont: .systemFont(ofSize: 13, weight: .bold), primaryColor: .orange, secondaryColor: .orange, lineColor: .orange.withAlphaComponent(0.9)))
        lineChart.cartesianPlane.yAxisPosition = .none
        lineChart.shouldScroll = false
      
        let card = FLCard(chart: lineChart, style: .rounded)
        card.showAverage = false
        card.showLegend = false
        
        view.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.heightAnchor.constraint(equalToConstant: 200),
            card.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            card.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
//            card.widthAnchor.constraint(equalToConstant: 300)
        ])
        
//        view.addSubview(radarChart)
//        radarChart.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            radarChart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            radarChart.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            radarChart.heightAnchor.constraint(equalToConstant: 270),
//            radarChart.widthAnchor.constraint(equalToConstant: 270)
//        ])
    }
}

extension ViewController {
    
    var monthsData: [MultiPlotable] {
        [MultiPlotable(name: "jan", values: [30, 24, 53]),
         MultiPlotable(name: "feb", values: [55, 44, 24]),
         MultiPlotable(name: "mar", values: [70, 15, 44]),
         MultiPlotable(name: "apr", values: [45, 68, 34]),
         MultiPlotable(name: "may", values: [85, 46, 12]),
         MultiPlotable(name: "jun", values: [46, 73, 32]),
         MultiPlotable(name: "jul", values: [75, 46, 53]),
         MultiPlotable(name: "aug", values: [10, 24, 24]),
         MultiPlotable(name: "set", values: [60, 74, 44]),
         MultiPlotable(name: "oct", values: [75, 72, 34]),
         MultiPlotable(name: "nov", values: [85, 10, 15]),
         MultiPlotable(name: "dec", values: [55, 66, 32]),
         MultiPlotable(name: "jan", values: [30, 24, 53]),
         MultiPlotable(name: "feb", values: [55, 44, 24]),
         MultiPlotable(name: "mar", values: [70, 15, 44]),
         MultiPlotable(name: "apr", values: [45, 68, 34]),
         MultiPlotable(name: "may", values: [85, 46, 12]),
         MultiPlotable(name: "jun", values: [46, 73, 32]),
         MultiPlotable(name: "jul", values: [75, 46, 53]),
         MultiPlotable(name: "aug", values: [10, 24, 24]),
         MultiPlotable(name: "set", values: [60, 74, 44]),
         MultiPlotable(name: "oct", values: [75, 72, 34]),
         MultiPlotable(name: "nov", values: [85, 10, 15]),
         MultiPlotable(name: "dec", values: [55, 66, 32])]
    }
    
    var scatterData: [ScatterPlotable] {
        [ScatterPlotable(x: 3, y: 38.587106591224336),
         ScatterPlotable(x: 3, y: 38.552766707227285),
         ScatterPlotable(x: 3, y: 36.49894052036733),
         ScatterPlotable(x: 6, y: 31.31575103102955),
         ScatterPlotable(x: 4, y: 46.52775961525811),
         ScatterPlotable(x: 6, y: 61.78378326561926),
         ScatterPlotable(x: 6, y: 96.53751839181793),
         ScatterPlotable(x: 7, y: 92.89349217706958),
         ScatterPlotable(x: 8, y: 79.22327631312078),
         ScatterPlotable(x: 2, y: 17.049959556070704),
         ScatterPlotable(x: 4, y: 78.14597672470192)]
    }
}
