//
//  PieBorder.swift
//  FLCharts
//
//  Created by Francesco Leoni on 25/02/22.
//

import UIKit

public enum FLPieBorder {
    
    /// The pie chart is fully filled.
    case full
    
    /// The pie chart has a hole in the center. The width represents the thickness of the actual pie chart.
    case width(CGFloat)
}
