//
//  Translation.swift
//  FLCharts
//
//  Created by Francesco Leoni on 16/10/22.
//

import Foundation

internal class Translation {
  
  internal static let noDataAvailable = Translation.tr("Localizable", "no_data_available")
  internal static let averageAbbreviated = Translation.tr("Localizable", "average_abbreviated")

}

extension Translation {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = Bundle(for: self).localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
