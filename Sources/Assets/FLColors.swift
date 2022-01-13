//
//  File.swift
//  FLCharts
//
//  Created by Francesco Leoni on 12/01/22.
//

import UIKit

public class FLColors {

    public static let white = UIColor(named: "white", in: bundle, compatibleWith: nil)
    public static let lightGray = UIColor(named: "light gray", in: bundle, compatibleWith: nil) ?? backupLightGray
    public static let darkGray = UIColor(named: "dark gray", in: bundle, compatibleWith: nil)!// ?? backupDarkGray
    public static let black = UIColor(named: "black", in: bundle, compatibleWith: nil)
    
}

public extension FLColors {
    
    private static var bundle: Bundle {
      Bundle(for: self)
    }
    
    static let backupLightGray = UIColor(red: 242/255, green: 242/255, blue: 246/255, alpha: 1)
    static let backupDarkGray = UIColor(red: 209/255, green: 209/255, blue: 213/255, alpha: 1)

}
