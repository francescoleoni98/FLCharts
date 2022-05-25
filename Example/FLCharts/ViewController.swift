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
                                       data: scatterData,
                                       legendKeys: [
                                        Key(key: "1", color: .red),
                                        Key(key: "2", color: .blue),
                                        Key(key: "3", color: .green)


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
        
        let radar = [FLDataSet(data: [5, 4.5, 4, 3.5], key: Key(key: "Graham", color: FLColor(.systemPink))),
                     FLDataSet(data: [3, 4, 5, 5], key: Key(key: "Barbara", color: .seaBlue)),
                     FLDataSet(data: [2, 3.5, 2, 5], key: Key(key: "Keith", color: FLColor(.systemGreen)))]
        
//        let lineChart = FLChart(data: barChartData, type: .scatter())
        let lineChart = FLPieChart(title: "Platforms",
                                   data: [FLPiePlotable(value: 51.7, key: Key(key: "Desktop", color: FLColor(hex: "138CFD"))),
                                          FLPiePlotable(value: 25.2, key: Key(key: "Mobile", color: FLColor(hex: "4DA8FF"))),
                                          FLPiePlotable(value: 14.7, key: Key(key: "Table", color: FLColor(hex: "A7CBF6"))),
                                          FLPiePlotable(value: 10.8, key: Key(key: "Other", color: FLColor(hex: "F0F4FA")))],
                                   border: .width(60),
                                   formatter: .percent)
//        lineChart.showAverageLine = true
//        lineChart.shouldScroll = false
//        lineChart.showTicks = false
////        lineChart.cartesianPlane.showUnitsOfMeasure = false
//        lineChart.config = FLChartConfig(granularityX: 1, granularityY: 15, axesLabels: FLAxesLabelConfig(color: .lightGray), axesLines: FLAxesLineConfig(color: .lightGray), dashedLines: FLDashedLineConfig(dashWidth: 2))

        let card = FLCard(chart: lineChart, style: .rounded)
        card.showAverage = false
        card.showLegend = false
        
        view.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.heightAnchor.constraint(equalToConstant: 290),
            card.widthAnchor.constraint(equalToConstant: 300)
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
    
    var monthsData: [SinglePlotable] {
        [SinglePlotable(name: "jan", value: 15),
         SinglePlotable(name: "feb", value: 45 - 20),
         SinglePlotable(name: "mar", value: 67 - 20),
         SinglePlotable(name: "apr", value: 55 - 20),
         SinglePlotable(name: "may", value: 34 - 20),
         SinglePlotable(name: "jun", value: 24 - 20)]
    }
    
    var scatterData: [ScatterPlotable] {
        var data: [ScatterPlotable] = []
        
        for _ in 0...300 {
            data.append(ScatterPlotable(x: CGFloat.random(in: 0...8), y: CGFloat.random(in: 0...50)))
        }

        return data
    }
}


// FLChartData(title: "Consumptions", data: [SinglePlotable], legendKeys: [Key], unitOfMeasure: "kWh")
// FLChart(data: barChartData, type: .bar(bar: FLPlainChartBar.self))

// FLChartData(title: "Consumptions", data: [MultiPlotable], legendKeys: [Key], unitOfMeasure: "kWh")
// FLChart(data: barChartData, type: .bar(bar: FLMultipleValuesChartBar.self))

// FLChartData(title: "Consumptions", data: [MultiPlotable], legendKeys: [Key], unitOfMeasure: "kWh")
// FLChart(data: barChartData, type: .bar(bar: FLHorizontalMultipleValuesChartBar.self))

// FLChartData(title: "Consumptions", data: [SinglePlotable], legendKeys: [Key], unitOfMeasure: "kWh")
// FLChart(data: barChartData, type: .line())

// FLChartData(title: "Consumptions", data: [MultiPlotable], legendKeys: [Key], unitOfMeasure: "kWh")
// FLChart(data: barChartData, type: .line())

// FLChartData(title: "Consumptions", data: [ScatterPlotable], legendKeys: [Key], unitOfMeasure: "kWh")
// FLChart(data: barChartData, type: .scatter())

// FLRadarChart(title: "Skills", categories: ["Knowledge", ...], data: [FLDataSet], isFilled: true)

// FLPieChart(title: "Platforms", data: [FLPiePlotable], border: .width(60), formatter: .percent)
