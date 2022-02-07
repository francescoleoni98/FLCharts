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
        
        var monthsData: [PlotableData] = []
        
        monthsData = [
            ScatterPlotable(x: 3, y: 38.587106591224336),
            ScatterPlotable(x: 3, y: 38.552766707227285),
            ScatterPlotable(x: 3, y: 36.49894052036733),
            ScatterPlotable(x: 6, y: 31.31575103102955),
            ScatterPlotable(x: 7, y: 51.90156317943829),
            ScatterPlotable(x: 8, y: 61.83913503693172),
            ScatterPlotable(x: 2, y: 26.178808708388736),
            ScatterPlotable(x: 4, y: 42.251336976025385),
            ScatterPlotable(x: 6, y: 16.426826517619887),
            ScatterPlotable(x: 7, y: 80.04758483526805),
            ScatterPlotable(x: 9, y: 87),
            ScatterPlotable(x: 4, y: 46.52775961525811),
            ScatterPlotable(x: 5, y: 22.358078282814976),
            ScatterPlotable(x: 7, y: 98.02773021009796),
            ScatterPlotable(x: 8, y: 85.68037835676299),
            ScatterPlotable(x: 2, y: 85.75449649249009),
            
            ScatterPlotable(x: 9, y: 90),
            ScatterPlotable(x: 4, y: 46.52775961525811),
            ScatterPlotable(x: 5, y: 22.358078282814976),
            ScatterPlotable(x: 7, y: 98.02773021009796),
            ScatterPlotable(x: 8, y: 85.68037835676299),

            ScatterPlotable(x: 4, y: 62.508555646363185),
            ScatterPlotable(x: 6, y: 61.78378326561926),
            ScatterPlotable(x: 6, y: 96.53751839181793),
            ScatterPlotable(x: 7, y: 92.89349217706958),
            ScatterPlotable(x: 8, y: 79.22327631312078),
            ScatterPlotable(x: 2, y: 17.049959556070704),
            ScatterPlotable(x: 4, y: 78.14597672470192)
        ]
                
//        monthsData = [MultiPlotable(name: "jan", values: [30, 43]),
//                      MultiPlotable(name: "feb", values: [55, 43]),
//                      MultiPlotable(name: "mar", values: [70, 43]),
//                      MultiPlotable(name: "apr", values: [45, 43]),
//                      MultiPlotable(name: "may", values: [85, 43]),
//                      MultiPlotable(name: "jun", values: [46, 43]),
//                      MultiPlotable(name: "jul", values: [75, 43]),
//                      MultiPlotable(name: "aug", values: [10, 43]),
//                      MultiPlotable(name: "set", values: [60, 43]),
//                      MultiPlotable(name: "oct", values: [75, 43]),
//                      MultiPlotable(name: "nov", values: [85, 43]),
//                      MultiPlotable(name: "dec", values: [55, 0])]

//        let series1 = FLScatterEntries([])
//        series1.color = .red
//        series1.dotDiameter = 8
        
        let chartData = FLChartData(title: "Consumptions",
                                    data: monthsData,
                                    legendKeys: [Key(key: "F1", color: .Gradient.purpleCyan),
                                                 Key(key: "F2", color: .green),
                                                 Key(key: "F3", color: .Gradient.sunset)],
                                    unitOfMeasure: "kWh")
        chartData.xAxisUnitOfMeasure = "days"
        
        let num = NumberFormatter()
        num.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        num.numberStyle = .currency

        chartData.yAxisFormatter = num
        chartData.xAxisFormatter = num

        chartView.backgroundColor = .red
        chartView.config = FLChartConfig(granularityY: 5)
        chartView.setup(data: chartData, type: .scatter(dotDiameter: 8))

        let chart = FLChart(data: chartData, type: .bar())
//        chart.config = FLChartConfig(granularityX: 3, granularityY: 20)
//        chart.cartesianPlane.yAxisPosition = .right
//        chart.cartesianPlane.showTicks = false
//        chart.showAverageLine = true

        let card = FLCard(chart: chart, style: .rounded)
        card.showAverage = true
        card.showLegend = false
        
        view.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.heightAnchor.constraint(equalToConstant: 180),
            card.widthAnchor.constraint(equalToConstant: 330)
        ])
        
        let chart2 = FLChart(data: chartData, type: .line())
        chart2.cartesianPlane.showUnitsOfMeasure = false
        
        view.addSubview(chart2)
        chart2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chart2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
            chart2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chart2.heightAnchor.constraint(equalToConstant: 180),
            chart2.widthAnchor.constraint(equalToConstant: 330)
        ])

    }
}
