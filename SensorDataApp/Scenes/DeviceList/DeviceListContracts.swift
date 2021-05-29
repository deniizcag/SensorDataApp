//
//  DeviceListContracts.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 29.05.2021.
//

import Foundation

protocol DeviceListVMProtocol {
  var delegate: DeviceListVMDelegate? {get set}
  func fetch()
  func selectDevice(at index: Int)
}
enum DeviceListVMOutput {
  case setLoading(Bool)
  case showDeviceList
  case updateTitle(String)
}
protocol DeviceListVMDelegate: class {
  func handleViewModelOutputs(_ output: DeviceListVMOutput)
  func navigateToDetailScreen()
}
