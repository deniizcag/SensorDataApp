//
//  DeviceDetailViewModel.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 30.05.2021.
//

import Foundation
import CoreData
final class DeviceDetailViewModel: DeviceDetailVMProtocol {


  weak var delegate: DeviceDetailVMDelegate?
  var device: Device!
  var service: FetchDeviceListServiceProtocol
  var coreDataStack: CoreDataStack
  var fetchRequest: NSFetchRequest<Reading>!
  var readings: [Reading] = []
  init(service: FetchDeviceListServiceProtocol,coreDataStack: CoreDataStack) {
    self.service = service
    self.coreDataStack = coreDataStack
  }
  func fetchReadings() {

    service.fetchDeviceReadings(url: ApiConstants.getDeviceReadings(deviceID: String(device.id))) { (result) in
      switch result {
      case .success(let readings):
        print(readings)
        self.saveLocally(readings: readings)
      case .failure(let error):
        print(error)
      }
    }

  }

  func deleteAllData(_ entity:String) {
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
      fetchRequest.returnsObjectsAsFaults = false
      do {
          let results = try coreDataStack.managedContext.fetch(fetchRequest)
          for object in results {
              guard let objectData = object as? NSManagedObject else {continue}
            coreDataStack.managedContext.delete(objectData)
          }
        try coreDataStack.managedContext.save()
      } catch let error {
          print("Detele all data in \(entity) error :", error)
      }
  }


  func saveLocally(readings: [AnyObject]) {
    let readingEntity = NSEntityDescription.entity(forEntityName: "Reading", in: coreDataStack.managedContext)!
    for reading in readings {
      if let id = reading["id"] as? Int16,
         let value = reading["value"] as? String,
         let type = reading["type"] as? String,
         let created = reading["created"] as? String,
         let deviceId = reading["deviceid"] as? Int16,
         !someEntityExists(id: deviceId)
         {
        let readingObject = Reading(entity: readingEntity, insertInto: coreDataStack.managedContext)
        readingObject.id = id
        readingObject.value = value
        readingObject.created = created
        readingObject.type = type
      }
      coreDataStack.saveContext()
      fetchFromCoreData()
      calculateValues()
    }

  }
  func someEntityExists(id: Int16) -> Bool {
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reading")
      fetchRequest.predicate = NSPredicate(format: "deviceid = %d", id)

      var results: [NSManagedObject] = []

      do {
        results = try coreDataStack.managedContext.fetch(fetchRequest)
      }
      catch {
          print("error executing fetch request: \(error)")
      }

      return results.count > 0
  }
  func fetchFromCoreData() {
    fetchRequest = Reading.fetchRequest()
    do {
      readings = try coreDataStack.managedContext.fetch(fetchRequest)
      self.notify(.showReadingList(readings))
    }
    catch {
      self.notify(.showReadingList([]))
    }


  }
  func calculateValues() {
    let tempValues = readings.filter {$0.type == "tempurature" || $0.type == "temperature"}.map {($0.value ?? "0") }.doubleArray
    self.notify(.updateValues(.Temperature, [tempValues.min() ?? 0, tempValues.max() ?? 0,tempValues.average ]))
    let humValues = readings.filter {$0.type == "humidity"}.map {($0.value ?? "0") }.doubleArray
    self.notify(.updateValues(.Humidity, [humValues.min() ?? 0, humValues.max() ?? 0,humValues.average ]))
    let airValues = readings.filter {$0.type == "air_quality"}.map {($0.value ?? "0") }.doubleArray
    self.notify(.updateValues(.AirQuality, [airValues.min() ?? 0, airValues.max() ?? 0,airValues.average ]))

  }

  func notify(_ outputs:
  DeviceDetailVMOutput) {
    delegate?.handleViewModelOutputs(outputs)

  }



}
extension Collection where Iterator.Element == String {
    var doubleArray: [Double] {
      return compactMap{ Double($0) }
    }
    var floatArray: [Float] {
      return compactMap{ Float($0) }
    }
}
extension Array where Element: FloatingPoint {

  var sum: Element {
    return reduce(0, +)
  }

  var average: Element {
    guard !isEmpty else {
      return 0
    }
    return sum / Element(count)
  }

}
