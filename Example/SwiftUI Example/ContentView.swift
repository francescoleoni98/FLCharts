//
//  ContentView.swift
//  SwiftUI Example
//
//  Created by Francesco Leoni on 24/05/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import FLCharts

struct ContentView: View {
    
    @State var barChartData = FLChartData(title: "Consumptions",
                                   data: [MultiPlotable(name: "12 mar ", values: [30, 24, 53]),
                                          MultiPlotable(name: "12 mar ", values: [75, 72, 34]),
                                          MultiPlotable(name: "12 mar ", values: [85, 10, 15]),
                                          MultiPlotable(name: "12 mar ", values: [55, 66, 32])],
                                   legendKeys: [
                                    Key(key: "1", color: .red),
                                    Key(key: "2", color: .blue),
                                    Key(key: "3", color: .green)],
                                   unitOfMeasure: "kWh")
//    barChartData.xAxisUnitOfMeasure = "months"
//    barChartData.yAxisFormatter = .decimal(2)
    
//    @State var data = [FLDataSet(data: [4, 8, 6], key: Key(key: "prima", color: .red)),
//                       FLDataSet(data: [5,6, 2], key: Key(key: "seconda", color: .blue))]
//    @State var categories = ["uno","due", "tre"]
//
//    @State var piedata = [FLPiePlotable(value: 3, key: Key(key: "prima", color: .red)),
//                          FLPiePlotable(value: 6, key: Key(key: "seconda", color: .blue))]
    var body: some View {
//        FLPieChartView(title: "Title", data: $piedata)
//        FLRadarChartView(title: "Title", data: $data, categories: $categories, isFilled: true)
        //            .data(data)

        FLCardView(style: .rounded) {
            FLChartView(data: $barChartData, type: .bar(highlightView: BarHighlightedView()))
                .showTicks(false)
                .shouldScroll(false)
        }
        //                .updateChart(data: )
        //            chart.shouldScroll = false
        //            return chart
//        }
        
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//                    data = [FLDataSet(data: [5, 5, 6,3], key: Key(key: "prima", color: .red)),
//                            FLDataSet(data: [7, 3, 4,7 ], key: Key(key: "seconda", color: .blue))]
//                    categories = ["uno", "due", "tre", "quattro"]
//
//                    piedata = [FLPiePlotable(value: 7, key: Key(key: "prima", color: .red)),
//                               FLPiePlotable(value: 1, key: Key(key: "seconda", color: .blue))]
                    
                    barChartData.dataEntries = [MultiPlotable(name: "12 mar ", values: [44, 24, 53]),
                                                          MultiPlotable(name: "12 mar ", values: [63, 72, 34]),
                                                          MultiPlotable(name: "12 mar ", values: [24, 10, 15]),
                                                          MultiPlotable(name: "12 mar ", values: [53, 66, 32])]
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
