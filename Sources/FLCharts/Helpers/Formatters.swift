//
//  Formatters.swift
//  FLCharts
//
//  Created by Francesco Leoni on 10/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import Foundation

public enum FLFormatter {
    
    /// A decimal style format.
    case decimal(Int)
    
    /// A percent style format.
    case percent
    
    /// A currency style format that uses the provided locale. Default is `.current`.
    case currency(Locale = .current)
    
    case suffix(String)
    
    /// Uses the provided custom formatter.
    case custom(Formatter)
    
    var formatter: Formatter {
        let formatter = NumberFormatter()

        switch self {
        case .decimal(let numberOfDecimals):
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = numberOfDecimals

        case .percent:
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 2
            formatter.multiplier = 1

        case .currency(let locale):
            formatter.locale = locale
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            formatter.usesGroupingSeparator = true
            
        case .suffix(let suffix):
            formatter.negativeSuffix = " " + suffix
            formatter.positiveSuffix = " " + suffix

        case .custom(let formatter):
            return formatter
        }
        
        return formatter
    }
    
    func string(from value: NSNumber) -> String {
        return formatter.string(for: value) ?? "N/D"
    }
}
