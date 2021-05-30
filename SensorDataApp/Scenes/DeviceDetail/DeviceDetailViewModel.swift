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
  var fetchRequestForDevice: NSFetchRequest<Device>!
  var readings: [Reading] = []
  var currentDevice: Device!
  init(service: FetchDeviceListServiceProtocol,coreDataStack: CoreDataStack) {
    self.service = service
    self.coreDataStack = coreDataStack
  }
  func fetchReadings() {
    self.notify(.setLoading(true))
    service.fetchDeviceReadings(url: ApiConstants.getDeviceReadings(deviceID: String(device.id))) { (result) in
      switch result {
      case .success(let readings):
        //print(readings)
        self.saveLocally(readings: readings)
        //self.save(readings: readings)
      case .failure(let error):
        print(error)
        self.fetchFromCoreData()
      }
    }
    self.notify(.updateTitle(device.name ?? "No name"))

  }
  func fetchFor(predicate: NSPredicate?, sort: NSSortDescriptor?) {
    let fetchRequest = NSFetchRequest<Reading>(entityName: "Reading")
    fetchRequest.predicate = NSPredicate(format: "deviceid == \(device.id)")
    fetchRequest.sortDescriptors = nil
    
    if let predicate = predicate {
      let predicateIsEnabled = NSPredicate(format: "deviceid == \(device.id)")
      let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicate, predicateIsEnabled])
      fetchRequest.predicate =  andPredicate
    }






    if let sort = sort {
      fetchRequest.sortDescriptors = [sort]

    }

    do {
        readings = try coreDataStack.managedContext.fetch(fetchRequest)
      self.notify(.showReadingList(readings))
    } catch let error as NSError {
        print("Could not fetch \(error), \(error.userInfo)")
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
//  func save(readings:  [AnyObject]) {
//
//    fetchRequestForDevice = Device.fetchRequest()
//    fetchRequestForDevice.predicate = NSPredicate(format: "id == \(device.id)")
//    do {
//      let results = try coreDataStack.managedContext.fetch(fetchRequestForDevice)
//        if results.count > 0 {
//            //Fido found, use fido
//            currentDevice = results.first
//        } else {
//
//        }
//    } catch let error as NSError {
//        print("Fetch error: \(error) description: \(error.userInfo)")
//    }
//    let readingEntity = NSEntityDescription.entity(forEntityName: "Reading", in: coreDataStack.managedContext)!
//    for reading in readings {
//      if let id = reading["id"] as? Int16,
//         let value = reading["value"] as? String,
//         let type = reading["type"] as? String,
//         let created = reading["created"] as? String,
//         let deviceId = reading["deviceid"] as? Int16,
//         someEntityExists(id: deviceId)
//         {
//        let readingObject = Reading(entity: readingEntity, insertInto: coreDataStack.managedContext)
//        readingObject.id = id
//        readingObject.value = value
//        readingObject.created = created
//        readingObject.type = type
//        readingObject.deviceid = deviceId
//
//        if let device = currentDevice,
//           let readings = device.readings?.mutableCopy() as? NSMutableOrderedSet {
//          readings.add(readingObject)
//          device.readings = readings
//        }
//      }
//
//      coreDataStack.saveContext()
//
//    }
//
//    fetchFromCoreData2()
//    calculateValues()
//
//
//  }


  func saveLocally(readings: [AnyObject]) {

    for reading in readings {
      if let id = reading["id"] as? Int16,
         let value = reading["value"] as? String,
         let type = reading["type"] as? String,
         let created = reading["created"] as? String,
         let deviceId = reading["deviceid"] as? Int16
         {
          someEntityExists(id: id,type: type,value: value,created: created, deviceId: deviceId)
      }

    }
    fetchFromCoreData()
    calculateValues()

  }
  func someEntityExists(id: Int16,type: String, value: String, created: String,deviceId: Int16)  {

    let predicateIsNumber = NSPredicate(format: "id == \(id)")
    let predicateIsEnabled = NSPredicate(format: "deviceid == \(device.id)")
    let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateIsNumber, predicateIsEnabled])


      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reading")
      fetchRequest.predicate = andPredicate
      var results: [NSManagedObject] = []
    let readingEntity = NSEntityDescription.entity(forEntityName: "Reading", in: coreDataStack.managedContext)!

    let readingObject = Reading(entity: readingEntity, insertInto: coreDataStack.managedContext)

      do {
        results = try coreDataStack.managedContext.fetch(fetchRequest)
        if results.count == 0 {
          readingObject.id = id
          readingObject.deviceid = deviceId
          readingObject.value = value
          readingObject.created = created
          readingObject.type = type
        }
        else {
          let reading = results[0] as! Reading
          reading.id = id
          reading.deviceid = deviceId
          reading.value = value
          reading.created = created
          reading.type = type
        }
        coreDataStack.saveContext()
      }
      catch {
          print("error executing fetch request: \(error)")
      }


  }
  func fetchFromCoreData() {
    let fetchRequest = NSFetchRequest<Reading>(entityName: "Reading")
    let predicateIsEnabled = NSPredicate(format: "deviceid == \(device.id)")


      fetchRequest.predicate = predicateIsEnabled

    do {
      readings = try coreDataStack.managedContext.fetch(fetchRequest)
      self.notify(.showReadingList(readings))
    }
    catch {
      self.notify(.showReadingList([]))
    }
    calculateValues()
    self.notify(.setLoading(false))

  }
  func fetchFromCoreData2() {
    fetchRequestForDevice = Device.fetchRequest()
    fetchRequestForDevice.predicate = NSPredicate(format: "id == \(device.id)")
    do {
      let results = try coreDataStack.managedContext.fetch(fetchRequestForDevice)
        if results.count > 0 {
            //Fido found, use fido

        } else {

        }
    } catch let error as NSError {
        print("Fetch error: \(error) description: \(error.userInfo)")
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
