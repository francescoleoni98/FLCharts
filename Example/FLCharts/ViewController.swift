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
                
        let scatterData = [
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
        
        let scatterChartData = FLChartData(title: "Ages",
                                    data: scatterData,
                                    legendKeys: [Key(key: "Age", color: .dusk)],
                                    unitOfMeasure: "years")
        scatterChartData.xAxisUnitOfMeasure = "days of birth"

        chartView.config = FLChartConfig(granularityY: 5)
        chartView.setup(data: scatterChartData, type: .scatter(dotDiameter: 8))

        
        
        let monthsData = [MultiPlotable(name: "jan", values: [30, 43]),
                      MultiPlotable(name: "feb", values: [55, 43]),
                      MultiPlotable(name: "mar", values: [70, 43]),
                      MultiPlotable(name: "apr", values: [45, 43]),
                      MultiPlotable(name: "may", values: [85, 43]),
                      MultiPlotable(name: "jun", values: [46, 43]),
                      MultiPlotable(name: "jul", values: [75, 43]),
                      MultiPlotable(name: "aug", values: [10, 43]),
                      MultiPlotable(name: "set", values: [60, 43]),
                      MultiPlotable(name: "oct", values: [75, 43]),
                      MultiPlotable(name: "nov", values: [85, 43]),
                      MultiPlotable(name: "dec", values: [55, 0])]

        let barChartData = FLChartData(title: "Consumptions",
                                    data: monthsData,
                                    legendKeys: [Key(key: "F1", color: .purple),
                                                 Key(key: "F2", color: .seaBlue)],
                                    unitOfMeasure: "kWh")
        barChartData.xAxisUnitOfMeasure = "months"
        
        let num = NumberFormatter()
        num.locale = .current
        num.minimumFractionDigits = 1

        barChartData.yAxisFormatter = num

        let chart = FLChart(data: barChartData, type: .bar())
        chart.cartesianPlane.yAxisPosition = .right
        chart.showAverageLine = true
    
        let card = FLCard(chart: chart, style: .rounded)
        card.showAverage = true
        card.showLegend = true
        
        view.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.heightAnchor.constraint(equalToConstant: 220),
            card.widthAnchor.constraint(equalToConstant: 330)
        ])
        
        
        let chart2 = FLChart(data: barChartData, type: .line())
        chart2.cartesianPlane.showUnitsOfMeasure = false
        
        view.addSubview(chart2)
        chart2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chart2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 230),
            chart2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chart2.heightAnchor.constraint(equalToConstant: 180),
            chart2.widthAnchor.constraint(equalToConstant: 330)
        ])
    }
}
