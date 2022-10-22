//
//  FLColor.swift
//  FLCharts
//
//  Created by Francesco Leoni on 20/01/22.
//

import UIKit
import Foundation

public class FLColor {
    
    public let colors: [UIColor]

    public let startColor: UIColor
    public let endColor: UIColor

    public var locations: [CGFloat]?

    public var mainColor: UIColor { startColor }
    
    public var cgColors: [CGColor] {
        colors.map { $0.cgColor }
    }
    
    // MARK: - Init
    
    /// Creates a color from an hex string.
    /// - Parameter hex: The hex string that describes a color.
    public convenience init(hex: String) {
        self.init(UIColor(hex: hex))
    }
    
    /// Creates an FLColor from an UIColor.
    /// - Parameter color: The UIColor to convert to FLColor.
    public init(_ color: UIColor) {
        self.startColor = color
        self.endColor = color
        self.colors = [startColor, endColor]
    }
    
    /// Creates a color the can handle a gradient.
    /// - Parameters:
    ///   - colors: The colors of the gradients.
    ///   - segmentedGradient: Whether the transition between colors is smooth or sharp.
    public init(colors: [UIColor], locations: [CGFloat]? = nil, segmentedGradient: Bool) {
        self.startColor = colors.first ?? .white
        self.endColor = colors.last ?? .black
        
        if segmentedGradient {
            if let locations = locations {
                self.locations = []
                
                for location in locations {
                    self.locations?.append(location)
                    self.locations?.append(location)
                }

                self.locations?.removeFirst(2)
                self.locations?.insert(0, at: 0)
            } else {
                self.locations = []
                
                let step = 1 / CGFloat(colors.count)
                
                for i in stride(from: 0, through: 1, by: step) {
                    self.locations?.append(i)
                    
                    if i != 0 && i != 1 {
                        self.locations?.append(i)
                    }
                }
            }

            var tempColors: [UIColor] = []
            
            for color in colors {
                tempColors.append(color)
                tempColors.append(color)
            }
            
            self.colors = tempColors
        } else {
            self.colors = colors
        }
    }
    
    /// Creates a color the can handle a gradient.
    /// - Parameters:
    ///   - startColor: The first color of the gradient.
    ///   - endColor: The last color of the gradient.
    public init(startColor: UIColor, endColor: UIColor) {
        self.startColor = startColor
        self.endColor = endColor
        self.colors = [startColor, endColor]
    }
        
    // MARK: - Methods
    
    public func gradientLayer(in rect: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = cgColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        if let locations = locations {
            gradientLayer.locations = locations.map { NSNumber(value: $0) }
        }

        gradientLayer.frame = rect
        return gradientLayer
    }
}

public extension FLColor {
    
    static let clear = FLColor(.clear)
    static let white = UIColor(named: "white", in: bundle, compatibleWith: nil) ?? .white
    static let lightGray = UIColor(named: "light gray", in: bundle, compatibleWith: nil) ?? backupLightGray
    static let mediumGray = FLColor(hex: "A7A6A8")
    static let darkGray = UIColor(named: "dark gray", in: bundle, compatibleWith: nil) ?? backupDarkGray
    static let black = UIColor(named: "black", in: bundle, compatibleWith: nil) ?? .black
    static let mintGreen = FLColor(hex: "E2FAE7")
    static let green = FLColor(hex: "72BF82")
    static let dusk = FLColor(hex: "E1614C")
    static let orange = FLColor(hex: "FF782C")
    static let red = FLColor(hex: "EC2301")
    static let fuchsia = FLColor(hex: "FF57A6")
    static let purple = FLColor(hex: "7B75FF")
    static let cyan = FLColor(hex: "6FEAFF")
    static let lightBlue = FLColor(hex: "C2E8FF")
    static let blue = FLColor(hex: "4EBCFF")
    static let seaBlue = FLColor(hex: "4266E8")
    static let darkBlue = FLColor(hex: "1B205E")

    static func uiColor(_ uicolor: UIColor) -> FLColor {
        FLColor(uicolor)
    }
  
    static func white(_ white: CGFloat, alpha: CGFloat = 1) -> FLColor {
      FLColor(UIColor(white: white, alpha: alpha))
    }

    enum Gradient {
        
        public static let green = FLColor(startColor: UIColor(hex: "0BCDF7"), endColor: UIColor(hex: "A2FEAE"))
        public static let lightBlue = FLColor(startColor: UIColor(hex: "C2E8FF"), endColor: UIColor(hex: "C2E8FF").withAlphaComponent(0))
        public static let darkBlue = FLColor(startColor: FLColor.darkBlue.mainColor, endColor: seaBlue.mainColor)
        public static let blueClear = FLColor(startColor: blue.mainColor.withAlphaComponent(0.5), endColor: seaBlue.mainColor.withAlphaComponent(0))
        public static let purpleLightBlue = FLColor(startColor: UIColor(hex: "8C00FF"), endColor: UIColor(hex: "4ABBFB"))
        public static let darkPurple = FLColor(startColor: UIColor(hex: "741DF4"), endColor: UIColor(hex: "C501B0"))
        public static let darkPink = FLColor(startColor: UIColor(hex: "BC05AF"), endColor: UIColor(hex: "FF1378"))
        public static let neonPink = FLColor(startColor: UIColor(hex: "FE019A"), endColor: UIColor(hex: "FE0BF4"))
        public static let purpleClear = FLColor(startColor: purple.mainColor, endColor: purple.mainColor.withAlphaComponent(0.2))
        public static let purpleCyan = FLColor(startColor: purple.mainColor, endColor: UIColor(hex: "7BD1FC"))
        public static let sunset = FLColor(startColor: UIColor(hex: "FF8E2D"), endColor: UIColor(hex: "FF4E7A"))
    }
}

public extension FLColor {
    
    private static var bundle: Bundle {
      Bundle(for: self)
    }
    
    private static let backupLightGray = UIColor(red: 242/255, green: 242/255, blue: 246/255, alpha: 1)
    private static let backupDarkGray = UIColor(red: 209/255, green: 209/255, blue: 213/255, alpha: 1)

}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
