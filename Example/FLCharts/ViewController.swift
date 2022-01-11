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
                                              barData: [BarData(name: "1", values: [3,5]),
                                                        BarData(name: "2", values: [5,5]),
                                                        BarData(name: "3", values: [3,2]),
                                                        BarData(name: "4", values: [4,7]),
                                                        BarData(name: "2", values: [5,5]),
                                                        BarData(name: "3", values: [3,2]),
                                                        BarData(name: "4", values: [4,7]),
                                                        BarData(name: "2", values: [5,5]),
                                                        BarData(name: "3", values: [3,2]),
                                                        BarData(name: "4", values: [4,7]),
                                                        BarData(name: "5", values: [7,7])], unitOfMeasure: "nan"))
//        data.showAverageLine = true
        data.highlighView = BarHighlightedView()
        data.shouldScroll = false
//        data.config = ChartConfig(
        view.addSubview(data)
        data.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            data.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            data.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            data.heightAnchor.constraint(equalToConstant: 150),
            data.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

