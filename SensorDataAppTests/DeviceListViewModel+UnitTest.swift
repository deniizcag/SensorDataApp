//
//  DeviceListViewModel+UnitTest.swift
//  SensorDataAppTests
//
//  Created by DenizCagilligecit on 31.05.2021.
//

import XCTest
import CoreData
@testable import SensorDataApp
class DeviceListViewModel_UnitTest: XCTestCase {


  var mockApiService: MockApiService!
  var sut: DeviceListViewModel!

  override func setUp() {
    super.setUp()
    mockApiService = MockApiService()
    sut = DeviceListViewModel(service: mockApiService, coreDataStack: CoreDataStack(modelName: "SensorDataApp"))
    sut.deleteAllData("Device")
  }
  override func tearDown() {
    super.tearDown()
    mockApiService = nil
    sut.deleteAllData("Device")
    sut = nil
  }

  func testFetchSuccess() {
    /// Given:

    let deviceEntity = NSEntityDescription.entity(forEntityName: "Device", in: sut.coreDataStack.managedContext)!
    let device = Device(entity: deviceEntity, insertInto: sut.coreDataStack.managedContext)
    device.name = "test"
    device.id = 1
    sut.saveLocally(devices: [device])
    /// When:
    sut?.fetch()
    mockApiService.fetchSuccess()


    // : Then
    XCTAssertEqual(sut?.devices?.count, 1)
  }
  func testFetchError() {
    /// Given:
    sut.deleteAllData("Device")
    
    /// When:
    sut?.fetch()
    mockApiService.fetchFail(error: .networkError)

    // : Then
    XCTAssertTrue(sut.devices?.count == 0)

  }

}

class MockApiService: FetchDeviceListServiceProtocol {


  var completeClosure: ((Result<[AnyObject], SDError>) -> Void)!
  var devices = [Device]()

  func fetchDeviceList(url: String, completed: @escaping (Result<[AnyObject], SDError>) -> Void) {
    completeClosure = completed
  }

  func fetchDeviceReadings(url: String, completed: @escaping (Result<[AnyObject], SDError>) -> Void) {
    completeClosure = completed

  }

  func fetchSuccess() {
    completeClosure(.success(devices))
  }

  func fetchFail(error: SDError) {
    completeClosure(.failure(error))

  }

  func fetchSuccessReadings() {
    completeClosure(.success(devices))
  }
  func fetchFailReadingfs(error: SDError) {
    completeClosure(.failure(error))

  }


}



