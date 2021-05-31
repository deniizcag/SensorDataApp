//
//  String+Extensions.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 31.05.2021.
//

import Foundation

extension String {

  func formatDate() -> String {
    let stringData = self
    let dateFormatter = DateFormatter()
    let tempLocale = dateFormatter.locale // save locale temporarily
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date = dateFormatter.date(from: stringData)!
    dateFormatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
    dateFormatter.locale = tempLocale // reset the locale
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let dateString = dateFormatter.string(from: date)
    return dateString
  }

  func cellFormat() -> String {
    return self.split(separator: "_").joined(separator: " ").capitalized
  }

}
