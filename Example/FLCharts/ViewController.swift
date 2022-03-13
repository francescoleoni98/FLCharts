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
    
    @IBOutlet weak var chartView: FLCard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let nextBtn = UIButton(type: .system)
        nextBtn.setTitleColor(.black, for: .normal)
        nextBtn.setTitle("Go to next", for: .normal)
        nextBtn.addTarget(self, action: #selector(push), for: .touchUpInside)
        nextBtn.frame = CGRect(x: 50, y: 70, width: 100, height: 50)
        view.addSubview(nextBtn)
        
        //        let scatterData = [
        //            ScatterPlotable(x: 3, y: 38.587106591224336),
        //            ScatterPlotable(x: 3, y: 38.552766707227285),
        //            ScatterPlotable(x: 3, y: 36.49894052036733),
        //            ScatterPlotable(x: 6, y: 31.31575103102955),
        //            ScatterPlotable(x: 7, y: 51.90156317943829),
        //            ScatterPlotable(x: 8, y: 61.83913503693172),
        //            ScatterPlotable(x: 2, y: 26.178808708388736),
        //            ScatterPlotable(x: 4, y: 42.251336976025385),
        //            ScatterPlotable(x: 6, y: 16.426826517619887),
        //            ScatterPlotable(x: 7, y: 80.04758483526805),
        //            ScatterPlotable(x: 9, y: 87),
        //            ScatterPlotable(x: 4, y: 46.52775961525811),
        //            ScatterPlotable(x: 5, y: 22.358078282814976),
        //            ScatterPlotable(x: 7, y: 98.02773021009796),
        //            ScatterPlotable(x: 8, y: 85.68037835676299),
        //            ScatterPlotable(x: 2, y: 85.75449649249009),
        //
        //            ScatterPlotable(x: 9, y: 90),
        //            ScatterPlotable(x: 4, y: 46.52775961525811),
        //            ScatterPlotable(x: 5, y: 22.358078282814976),
        //            ScatterPlotable(x: 7, y: 98.02773021009796),
        //            ScatterPlotable(x: 8, y: 85.68037835676299),
        //
        //            ScatterPlotable(x: 4, y: 62.508555646363185),
        //            ScatterPlotable(x: 6, y: 61.78378326561926),
        //            ScatterPlotable(x: 6, y: 96.53751839181793),
        //            ScatterPlotable(x: 7, y: 92.89349217706958),
        //            ScatterPlotable(x: 8, y: 79.22327631312078),
        //            ScatterPlotable(x: 2, y: 17.049959556070704),
        //            ScatterPlotable(x: 4, y: 78.14597672470192)
        //        ]
        
        //        let scatterChartData = FLChartData(title: "Ages",
        //                                           data: scatterData,
        //                                           legendKeys: [Key(key: "Age", color: .dusk)],
        //                                           unitOfMeasure: "years")
        //        scatterChartData.xAxisUnitOfMeasure = "days of birth"
        
        //        chartView.config = FLChartConfig(granularityY: 5)
        //        chartView.setup(data: scatterChartData, type: .scatter(dotDiameter: 8))
        //        chartView.backgroundColor = .white
        
        
        let monthsData = [MultiPlotable(name: "jan", values: [30, 6]),
                          MultiPlotable(name: "feb", values: [55, 43]),
                          MultiPlotable(name: "mar", values: [70, 54]),
                          MultiPlotable(name: "apr", values: [45, 43]),
                          MultiPlotable(name: "may", values: [85, 23]),
                          MultiPlotable(name: "jun", values: [46, 43]),
                          MultiPlotable(name: "jul", values: [75, 12]),
                          MultiPlotable(name: "aug", values: [10, 32]),
                          MultiPlotable(name: "set", values: [60, 43]),
                          MultiPlotable(name: "oct", values: [75, 15]),
                          MultiPlotable(name: "nov", values: [85, 64]),
                          MultiPlotable(name: "dec", values: [55, 32])]
        
        let barChartData = FLChartData(title: "Consumptions",
                                       data: monthsData,
                                       legendKeys: [Key(key: "F1", color: .purple),
                                                    Key(key: "F2", color: .seaBlue)],
                                       unitOfMeasure: "kWh")
        barChartData.xAxisUnitOfMeasure = "months"
        barChartData.yAxisFormatter = .decimal(2)
        
        //        let chart = FLChart(data: scatterChartData, type: .scatter())
        //        chart.cartesianPlane.yAxisPosition = .right
        //        chart.showAverageLine = true
        
        let pieChart = FLPieChart(title: "Platforms",
                                  data: [FLPiePlotable(value: 51.7, key: Key(key: "Desktop", color: FLColor(hex: "138CFD"))),
                                         FLPiePlotable(value: 25.2, key: Key(key: "Mobile", color: FLColor(hex: "4DA8FF"))),
                                         FLPiePlotable(value: 14.7, key: Key(key: "Table", color: FLColor(hex: "A7CBF6"))),
                                         FLPiePlotable(value: 10.8, key: Key(key: "Other", color: FLColor(hex: "F0F4FA")))],
                                  border: .full,
                                  formatter: .percent,
                                  animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            pieChart.updateData([FLPiePlotable(value: 52, key: Key(key: "Desktop", color: FLColor(hex: "138CFD"))),
                                 FLPiePlotable(value: 34, key: Key(key: "Mobile", color: FLColor(hex: "4DA8FF"))),
                                 FLPiePlotable(value: 66, key: Key(key: "Table", color: FLColor(hex: "A7CBF6"))),
                                 FLPiePlotable(value: 10.8, key: Key(key: "Other", color: FLColor(hex: "F0F4FA")))], animated: true)
            
        }
        
        let radarChart = FLRadarChart(title: "Radar",
                                      categories: ["Knowledge", "Delivery", "Effectiveness", "Helpful", "Punctual"],
                                      data: [FLDataSet(data: [5, 4.7, 4, 3, 5], key: Key(key: "Graham", color: .red)),
                                             FLDataSet(data: [3, 4, 5, 4.7, 3], key: Key(key: "Barbara", color: .seaBlue))],
                                      formatter: .decimal(2),
                                      config: FLRadarGridConfig(divisions: 4))
        radarChart.showLabels = true
        radarChart.showXAxisLabels = true
        radarChart.showYAxisLabels = true
        
        let lineChart = FLChart(data: barChartData, type: .line())
        lineChart.cartesianPlane.showUnitsOfMeasure = false
        
        let card = FLCard(chart: radarChart, style: .rounded)
        card.showAverage = true
        card.showLegend = true
        
        view.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.heightAnchor.constraint(equalToConstant: 290),
            card.widthAnchor.constraint(equalToConstant: 300)
        ])        
    }
    
    @objc private func push() {
        navigationController?.pushViewController(PushViewController(), animated: true)
    }
}

class PushViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
