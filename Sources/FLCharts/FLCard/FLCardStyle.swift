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
    
    public init(backgroundColor: UIColor? = FLColor.white,
                textColor: UIColor? = FLColor.black,
                cornerRadius: CGFloat = 15,
                shadow: FLShadow? = .basic) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }
}

public extension FLCardStyle {
    
    static let plain = FLCardStyle(backgroundColor: FLColor.white,
                                   textColor: FLColor.black,
                                   shadow: .basic)
    
    static let rounded = FLCardStyle(backgroundColor: FLColor.white,
                                     textColor: FLColor.black,
                                     cornerRadius: 12,
                                     shadow: .basic)
}
