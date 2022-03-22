//
//  Key.swift
//  FLCharts
//
//  Created by Francesco Leoni on 15/01/22.
//

import UIKit

public struct Key {
    
    /// The title of the key.
    var key: String
    
    /// The color of the key and the corresponding part of the bar.
    var color: FLColor
    
    /// The value of this key. Currently used for pie chart.
    var value: CGFloat?
    
    internal var isVertical: Bool = false
    
    public init(key: String, value: CGFloat? = nil, color: FLColor) {
        self.key = key
        self.value = value
        self.color = color
    }
    
    /// Defines a Key.
    ///
    /// - Note: This init applies only to line chart.
    ///
    /// - Parameters:
    ///   - key: The name of the key.
    ///   - xThresholds: The color of each x axis segment. The colors are used from left to right.
    public init(key: String, xColors: [UIColor]) {
        self.key = key
        self.color = FLColor(colors: xColors, segmentedGradient: true)
    }
    
    /// Defines a Key.
    ///
    /// - Note: This init applies only to line chart.
    ///
    /// - Parameters:
    ///   - key: The name of the key.
    ///   - yThresholds: A dictionary that defines which color has each threshold.
    ///   - data: The data of the chart.
    public init(key: String, yThresholds: [CGFloat : UIColor], data: [PlotableData]) {
        self.key = key
        self.isVertical = true
        
        guard data.count > 1,
              yThresholds.map({ $0.key }).allSatisfy({ $0 > 0 }) else {
            self.color = FLColor(yThresholds.first?.value ?? .black)
            return
        }
        
        var maxValue: CGFloat?
        
        data.forEach { data in
            guard let currentMax = data.values.max() else { return }
            
            if let oldMax = maxValue {
                if currentMax > oldMax {
                    maxValue = currentMax
                }
            } else {
                maxValue = currentMax
            }
        }
        
        guard let maxValue = maxValue else {
            self.color = FLColor(.black)
            return
        }
        
        let yThresholds = yThresholds.sorted(by: { $0.key > $1.key })
        
        let colors = yThresholds.map { $0.value }
        let locations = yThresholds.map { threshold in
            1 - (threshold.key / maxValue)
        }
        
        self.color = FLColor(colors: colors, locations: locations, segmentedGradient: true)
    }
    
    func textWithValue(formatter: FLFormatter) -> NSMutableAttributedString {
        if let value = value {
            let formattedValue = formatter.string(from: NSNumber(value: value))
            let attributedText = NSMutableAttributedString(string: formattedValue, attributes: [.font : UIFont.boldSystemFont(ofSize: 13)])
            attributedText.append(NSAttributedString(string: " \(key)"))
            return attributedText
        } else {
            return NSMutableAttributedString(string: key)
        }
    }
}
