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
        let data = FLBarChart(bar: MultipleValuesChartBar.self,
                              data: ChartData(title: "",
                                              barData: [BarData(name: "jan", values: [33]),
                                                        BarData(name: "feb", values: [56]),
                                                        BarData(name: "mar", values: [72]),
                                                        BarData(name: "apr", values: [42]),
                                                        BarData(name: "may", values: [86]),
                                                        BarData(name: "jun", values: [45]),
                                                        BarData(name: "jul", values: [76]),
                                                        BarData(name: "aug", values: [12]),
                                                        BarData(name: "set", values: [66]),
                                                        BarData(name: "oct", values: [74]),
                                                        BarData(name: "nov", values: [25]),
                                                        BarData(name: "dec", values: [54])], unitOfMeasure: "scm"))
//        data.showAverageLine = true
        data.highlighView = BarHighlightedView()
        data.shouldScroll = false
        data.showTicks = false
        data.config = ChartConfig(deltaY: 25, barSpacing: 10)
        
        view.addSubview(data)
        data.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            data.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            data.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            data.heightAnchor.constraint(equalToConstant: 170),
            data.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

