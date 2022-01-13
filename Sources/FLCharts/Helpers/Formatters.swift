//
//  Formatters.swift
//  FLCharts
//
//  Created by Francesco Leoni on 10/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import Foundation

enum Formatters {
    
    static func toDecimals(value: NSNumber) -> String? {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        return formatter.string(from: value)
    }
}
