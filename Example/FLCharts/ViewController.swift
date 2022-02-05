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
            ScatterPlotable(x: 10.839988510221971, y: 8.587106591224336),
            ScatterPlotable(x: 15.299129085689668, y: 38.552766707227285),
            ScatterPlotable(x: 15.35078612619641, y: 36.49894052036733),
            ScatterPlotable(x: 2.610617242416038, y: 31.31575103102955),
            ScatterPlotable(x: 12.405358885011637, y: 51.90156317943829),
            ScatterPlotable(x: 3.0511565198462343, y: 61.83913503693172),
            ScatterPlotable(x: 11.724536444721771, y: 26.178808708388736),
            ScatterPlotable(x: 9.827075196452416, y: 42.251336976025385),
            ScatterPlotable(x: 12.317182088116304, y: 3.0921186208962337),
            ScatterPlotable(x: 15.820992489229733, y: 16.426826517619887),
            ScatterPlotable(x: 2.282637000059655, y: 80.04758483526805),
            ScatterPlotable(x: 10.362707563030302, y: 26.832734822388428),
            ScatterPlotable(x: 13.354707157044048, y: 46.52775961525811),
            ScatterPlotable(x: 5.7244020200118335, y: 22.358078282814976),
            ScatterPlotable(x: 2.07964896336037, y: 98.02773021009796),
            ScatterPlotable(x: 14.413761813594125, y: 85.68037835676299),
            ScatterPlotable(x: 9.986518848938694, y: 85.75449649249009),
            ScatterPlotable(x: 17.78796600480713, y: 62.508555646363185),
            ScatterPlotable(x: 10.117735260477584, y: 61.78378326561926),
            ScatterPlotable(x: 0.3640039997010436, y: 96.53751839181793),
            ScatterPlotable(x: 17.147832151436994, y: 92.89349217706958),
            ScatterPlotable(x: 12.745950761706375, y: 79.22327631312078),
            ScatterPlotable(x: 12.92676299380437, y: 17.049959556070704),
            ScatterPlotable(x: 8.827170027380545, y: 78.14597672470192)
        ]
        
        monthsData = [MultiPlotable(name: "jan", values: [30, 43]),
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

        let chartData = FLChartData(title: "Consumptions",
                                    data: monthsData,
                                    legendKeys: [Key(key: "F1", color: .Gradient.purpleCyan),
                                                 Key(key: "F2", color: .green),
                                                 Key(key: "F3", color: .Gradient.sunset)],
                                    unitOfMeasure: "kWh")

        let chart = FLChart(data: chartData, type: .bar())
        chart.config = FLChartConfig(granularityX: 3)
        chart.cartesianPlane.yAxisPosition = .right
        chart.cartesianPlane.showTicks = false
        chart.showAverageLine = true
                
        let card = FLCard(chart: chart, style: .rounded)
        card.showAverage = true
        card.showLegend = false
        
        view.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chart.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            chart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chart.heightAnchor.constraint(equalToConstant: 250),
            chart.widthAnchor.constraint(equalToConstant: 330)
        ])
    }
}
