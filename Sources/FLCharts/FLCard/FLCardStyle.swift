//
//  FLCardStyle.swift
//  FLCharts
//
//  Created by Francesco Leoni on 13/01/22.
//

import UIKit

public struct FLCardStyle {
    
    public var backgroundColor: UIColor?
    public var textColor: UIColor?
    public var cornerRadius: CGFloat = 0
    public var shadow: FLShadow?
}

public extension FLCardStyle {
    
    static let plain = FLCardStyle(backgroundColor: FLColors.white,
                                   textColor: FLColors.black,
                                   shadow: FLShadow(color: .black, radius: 10, opacity: 0.1))
    
    static let rounded = FLCardStyle(backgroundColor: FLColors.white,
                                     textColor: FLColors.black,
                                     cornerRadius: 12,
                                     shadow: FLShadow(color: .black, radius: 10, opacity: 0.1))
}
