//
//  FLDataSet.swift
//  FLCharts
//
//  Created by Francesco Leoni on 13/03/22.
//

import UIKit

public struct FLDataSet {
    
    var data: [CGFloat]
    var key: Key
    
    public init(data: [CGFloat], key: Key) {
        self.data = data
        self.key = key
    }
}

extension Array where Element == FLDataSet {
    
    var max: CGFloat? {
        var max: CGFloat?
        
        self.forEach { dataSet in
            let currentMax = dataSet.data.max()
            
            if let currentMax = currentMax, let internalMax = max {
                if internalMax < currentMax {
                    max = currentMax
                }
            } else {
                max = currentMax
            }
        }
        
        return max
    }
    
    var min: CGFloat? {
        var min: CGFloat?

        self.forEach { dataSet in
            let currentMin = dataSet.data.min()
            
            if let currentMin = currentMin, let internalMin = max {
                if internalMin > currentMin {
                    min = currentMin
                }
            } else {
                min = currentMin
            }
        }
        
        return min
    }
}
