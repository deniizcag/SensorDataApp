//
//  DeviceDetailContracts.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 30.05.2021.
//

import Foundation

protocol DeviceDetailVMProtocol {
  var delegate: DeviceDetailVMDelegate? {get set}
  func fetchReadings()
  func calculateValues()
  func fetchFor(predicate: NSPredicate?, sort: NSSortDescriptor?)
}
enum DeviceDetailVMOutput {
  case setLoading(Bool)
  case showReadingList([Reading])
  case updateValues(DataType,[Double])
  case updateTitle(String)
}

protocol DeviceDetailVMDelegate: class {
  func handleViewModelOutputs(_ outputs: DeviceDetailVMOutput)
}

enum DataType {
  case Temperature
  case Humidity
  case AirQuality
}

