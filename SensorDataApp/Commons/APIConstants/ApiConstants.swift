//
//  ApiConstants.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 29.05.2021.
//

import Foundation

final class ApiConstants {
  static let getAllDevicesURL = baseURL() + "/devices/"

  static func getDeviceDetail(deviceID: String) -> String {
    return getAllDevicesURL + deviceID
  }

  static func getDeviceReadings(deviceID: String) -> String {
    return getDeviceDetail(deviceID: deviceID) + "/readings"
  }

}

extension ApiConstants {
  static func baseURL() -> String {
    return "https://canary-homework-test.herokuapp.com"
  }
}
