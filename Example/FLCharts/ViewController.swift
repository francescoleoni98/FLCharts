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
        view.backgroundColor = FLColors.white
        
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
        
        let data = ChartData(title: "Consumptions",
                             barData: monthsData,
                             unitOfMeasure: "scm")
        
        let chart = FLBarChart(data: data,
                               bar: MultipleValuesChartBar.self,
                               highlightView: BarHighlightedView())
        chart.showTicks = false
        chart.config = ChartConfig(deltaY: 25, barSpacing: 8)

        let card = FLCard(chart: chart,
                          style: .rounded)
        card.showAverage = true
        
        view.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.heightAnchor.constraint(equalToConstant: 200),
            card.widthAnchor.constraint(equalToConstant: 330)
        ])
    }
}
