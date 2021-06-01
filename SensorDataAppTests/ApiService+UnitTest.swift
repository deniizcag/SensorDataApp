//
//  ApiService+UnitTest.swift
//  SensorDataAppTests
//
//  Created by DenizCagilligecit on 31.05.2021.
//

import XCTest
@testable import SensorDataApp
class ApiService_UnitTest: XCTestCase {
  var service: DeviceListService!

  override func setUp() {
    super.setUp()
  }

  func testReturnDetails() {
    let e = expectation(description: "Error")

    service = DeviceListService()
    service.fetchDeviceList(url: ApiConstants.getAllDevicesURL) { (result) in
      switch result {
      case .success:
        e.fulfill()
      case .failure:
        break
      }
    }
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  func testReturnReadings() {
    let e = expectation(description: "Error")

    service = DeviceListService()
    service.fetchDeviceReadings(url: ApiConstants.getDeviceReadings(deviceID: "1")) { (result) in
      switch result {
      case .success:
        e.fulfill()
      case .failure:
        break
      }
    }
    waitForExpectations(timeout: 5.0, handler: nil)

  }

}
