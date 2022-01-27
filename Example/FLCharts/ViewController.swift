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
        
        let monthsData = [MultiPlotable(name: "jan", values: [30, 0, 0]),
                          MultiPlotable(name: "feb", values: [55, 0, 0]),
                          MultiPlotable(name: "mar", values: [70, 0, 0]),
                          MultiPlotable(name: "apr", values: [45, 30, 0]),
                          MultiPlotable(name: "may", values: [85, 0, 0]),
                          MultiPlotable(name: "jun", values: [46, 40, 0]),
                          MultiPlotable(name: "jul", values: [75, 0, 0]),
                          MultiPlotable(name: "aug", values: [10, 0, 0]),
                          MultiPlotable(name: "set", values: [60, 0, 0]),
                          MultiPlotable(name: "oct", values: [75, 0, 0]),
                          MultiPlotable(name: "nov", values: [85, 0, 0]),
                          MultiPlotable(name: "dec", values: [55, 50, 20])]
        
        let data = FLChartData(title: "Consumptions",
                               data: monthsData,
                               legendKeys: [Key(key: "F1", color: .Gradient.purpleCyan),
                                            Key(key: "F2", color: .green),
                                            Key(key: "F3", color: .Gradient.sunset)],
                               unitOfMeasure: "kWh")
        
        chartView.setup(data: data, type: .bar(highlightView: BarHighlightedView()))
        chartView.showAverageLine = true

        let chart = FLChart(data: data, type: .bar())
        chart.config = FLChartConfig(granularityY: 20)
        chart.cartesianPlane.yAxisPosition = .right
        chart.showAverageLine = true
                
        let card = FLCard(chart: chart, style: .rounded)
        card.showAverage = true
        card.showLegend = true
        
        view.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.heightAnchor.constraint(equalToConstant: 300),
            card.widthAnchor.constraint(equalToConstant: 330)
        ])
    }
}
