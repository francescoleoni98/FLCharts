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

    override func viewDidLoad() {
        super.viewDidLoad()
        let monthsData = [BarData(name: "jan", values: [33]),
                          BarData(name: "feb", values: [56]),
                          BarData(name: "mar", values: [72]),
                          BarData(name: "apr", values: [42, 33]),
                          BarData(name: "may", values: [86]),
                          BarData(name: "jun", values: [45, 43]),
                          BarData(name: "jul", values: [76]),
                          BarData(name: "aug", values: [12]),
                          BarData(name: "set", values: [66]),
                          BarData(name: "oct", values: [74]),
                          BarData(name: "nov", values: [25, 65]),
                          BarData(name: "dec", values: [54, 43, 23])]
        
        let data = ChartData(title: "",
                             barData: monthsData,
                             unitOfMeasure: "scm")
        
        let chart = FLBarChart(data: data,
                               bar: MultipleValuesChartBar.self,
                               highlightView: BarHighlightedView())
        
        chart.showTicks = false
        chart.showAverageLine = true
        chart.config = ChartConfig(deltaY: 25, barSpacing: 8)
        
        view.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chart.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            chart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -10),
            chart.heightAnchor.constraint(equalToConstant: 170),
            chart.widthAnchor.constraint(equalToConstant: 320)
        ])
    }
}
