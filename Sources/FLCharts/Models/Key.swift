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
    
    public init(key: String, value: CGFloat? = nil, color: FLColor) {
        self.key = key
        self.value = value
        self.color = color
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
