//
//  Key.swift
//  FLCharts
//
//  Created by Francesco Leoni on 15/01/22.
//

import UIKit

public struct Key: Equatable {
    
    /// The title of the key.
    var key: String
    
    /// The color of the key and the corresponding part of the bar.
    var color: UIColor
    
    public init(key: String, color: UIColor) {
        self.key = key
        self.color = color
    }
}
