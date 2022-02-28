//
//  Label.swift
//  FLCharts
//
//  Created by Francesco Leoni on 06/02/22.
//

import UIKit

class Label: Equatable {
    
    var text: String
    var size: CGSize = .zero
    var point: CGPoint
    var type: Role
    
    init(text: String, size: CGSize = .zero, point: CGPoint, type: Role) {
        self.text = text
        self.size = size
        self.point = point
        self.type = type
    }
    
    enum Role {
        case xLabel
        case yLabel
        case topYLabel
        case xUnitOfMeasure
        case yUnitOfMeasure
    }
    
    static func == (lhs: Label, rhs: Label) -> Bool {
        lhs.text == rhs.text &&
        lhs.point == rhs.point
    }
}
