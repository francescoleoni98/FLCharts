//
//  File.swift
//  FLCharts
//
//  Created by Francesco Leoni on 12/01/22.
//

import UIKit

public class FLColors {

    public static let white = UIColor(named: "white", in: bundle, compatibleWith: nil) ?? .white
    public static let lightGray = UIColor(named: "light gray", in: bundle, compatibleWith: nil) ?? backupLightGray
    public static let darkGray = UIColor(named: "dark gray", in: bundle, compatibleWith: nil) ?? backupDarkGray
    public static let black = UIColor(named: "black", in: bundle, compatibleWith: nil) ?? .black
}

public extension FLColors {
    
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
