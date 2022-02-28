//
//  FLPiePlotable.swift
//  FLCharts
//
//  Created by Francesco Leoni on 25/02/22.
//

import UIKit

public class FLPiePlotable {
    
    public var value: CGFloat
    public var key: Key
    
    public init(value: CGFloat, key: Key) {
        self.value = value
        self.key = key
        self.key.value = value
    }
}

extension FLPiePlotable: Equatable {
    
    public static func == (lhs: FLPiePlotable, rhs: FLPiePlotable) -> Bool {
        lhs.key.key == rhs.key.key
    }
}
