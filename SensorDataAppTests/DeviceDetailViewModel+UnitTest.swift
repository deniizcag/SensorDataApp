//
//  DeviceDetailViewModel+UnitTest.swift
//  SensorDataAppTests
//
//  Created by DenizCagilligecit on 31.05.2021.
//

import XCTest
import CoreData
@testable import SensorDataApp
class DeviceDetailViewModel_UnitTest: XCTestCase {

  var mockApiService: MockApiService!
  var sut: DeviceDetailViewModel!


  override func setUp() {
    super.setUp()
    mockApiService = MockApiService()
    sut = DeviceDetailViewModel(service: mockApiService, coreDataStack: CoreDataStack(modelName: "SensorDataApp"))
    sut.deleteAllData("Reading")
  }
  override func tearDown() {
    super.tearDown()
    mockApiService = nil
    sut.deleteAllData("Reading")
    sut = nil
  }

  func testFetchSuccess() {
    /// Given:

    let readingEntity = NSEntityDescription.entity(forEntityName: "Reading", in: sut.coreDataStack.managedContext)!
    let reading = Reading(entity: readingEntity, insertInto: sut.coreDataStack.managedContext)
    let deviceEntity = NSEntityDescription.entity(forEntityName: "Device", in: sut.coreDataStack.managedContext)!
    let device = Device(entity: deviceEntity, insertInto: sut.coreDataStack.managedContext)
    device.name = "test"
    device.id = 1
    sut.device = device
    reading.device = device
    reading.deviceid = 1
    reading.value = "0.0"
    reading.type = "test"
    reading.created = "2021-03-25T14:08:52.825Z"
    reading.id = 12

    //sut.saveLocally(readings: [device])
    /// When:
    sut?.fetchReadings()
    sut.someEntityExists(id: reading.id, type: reading.type!, value: reading.value!, created: reading.created!, deviceId: reading.deviceid)
    sut.saveLocally(readings: [reading])
    mockApiService.fetchSuccess()
    

    // : Then
    XCTAssertTrue(sut.readings.count > 0)

  }
  func testFetchError() {
    /// Given:
    let deviceEntity = NSEntityDescription.entity(forEntityName: "Device", in: sut.coreDataStack.managedContext)!
    let device = Device(entity: deviceEntity, insertInto: sut.coreDataStack.managedContext)
    device.name = "test"
    device.id = 1
    sut.device = device
    
    /// When:
    sut?.fetchReadings()
    mockApiService.fetchFail(error: .networkError)

   /// : Then
    XCTAssertTrue(sut.readings.count == 0)

  }

}



