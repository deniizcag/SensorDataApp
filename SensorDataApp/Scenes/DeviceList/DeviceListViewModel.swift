//
//  DeviceListViewModel.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 29.05.2021.
//

import Foundation

final class DeviceListViewModel: DeviceListVMProtocol {
  var delegate: DeviceListVMDelegate?
  var service: FetchDeviceListServiceProtocol
  init(service: FetchDeviceListServiceProtocol) {
    self.service = service
  }

  func fetch() {
    service.fetchDeviceList(url: ApiConstants.getAllDevicesURL) { (result) in
      switch result {
      case .success(let devices):
        print(devices)
      case .failure(let error):
        print(error)
      }
    }

  }

  func selectDevice(at index: Int) {

  }


}
