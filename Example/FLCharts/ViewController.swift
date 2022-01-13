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
        
        let monthsData = [BarData(name: "jan", values: [21, 33, 54]),
                          BarData(name: "feb", values: [56, 23, 17]),
                          BarData(name: "mar", values: [72, 13.4, 24]),
                          BarData(name: "apr", values: [42, 33.8, 33]),
                          BarData(name: "may", values: [86, 15, 42]),
                          BarData(name: "jun", values: [45, 43, 55]),
                          BarData(name: "jul", values: [76, 25.5, 11]),
                          BarData(name: "aug", values: [12.6, 45, 42]),
                          BarData(name: "set", values: [66, 23, 24]),
                          BarData(name: "oct", values: [74, 11, 43]),
                          BarData(name: "nov", values: [25, 65, 35]),
                          BarData(name: "dec", values: [54, 43, 23])]
        
        let data = ChartData(title: "Consumptions",
                             barData: monthsData,
                             unitOfMeasure: "kWh")
        
        let chart = FLBarChart(data: data,
                               bar: MultipleValuesChartBar.self,
                               highlightView: BarHighlightedView())
        chart.showAverageLine = true
                
        chart.config = ChartConfig(deltaX: 2,
                                   deltaY: 25,
                                   bar: FLBarConfig(colors: [
                                    UIColor(red: 80/255, green: 214/255, blue: 182/255, alpha: 1),
                                    UIColor(red: 255/255, green: 238/255, blue: 0/255, alpha: 1),
                                    UIColor(red: 123/255, green: 72/255, blue: 217/255, alpha: 1)],
                                            spacing: 12))
        chart.config.dashedLines.color = .darkGray
        
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
