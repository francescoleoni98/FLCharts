//
//  FLColor.swift
//  FLCharts
//
//  Created by Francesco Leoni on 20/01/22.
//

import UIKit

public class FLColor {
    
    let startColor: UIColor
    let endColor: UIColor

    public var mainColor: UIColor { startColor }
    
    public var colors: [UIColor] {
        [startColor, endColor]
    }

    public var cgColors: [CGColor] {
        [startColor.cgColor, endColor.cgColor]
    }
    
    // MARK: - Init
    
    public convenience init(hex: String) {
        self.init(UIColor(hex: hex))
    }

    public init(_ color: UIColor) {
        self.startColor = color
        self.endColor = color
    }

    public init(startColor: UIColor, endColor: UIColor) {
        self.startColor = startColor
        self.endColor = endColor
    }
        
    // MARK: - Methods
    
    public func gradientLayer(in rect: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = cgColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = rect
        return gradientLayer
    }
}

public extension FLColor {
    
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
