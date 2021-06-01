//
//  DeviceListViewModel.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 29.05.2021.
//

import Foundation
import CoreData
final class DeviceListViewModel: DeviceListVMProtocol {
  
  weak var delegate: DeviceListVMDelegate?
  var service: FetchDeviceListServiceProtocol
  var coreDataStack: CoreDataStack
  var fetchRequest: NSFetchRequest<Device>!
  var devices: [Device]?

  init(service: FetchDeviceListServiceProtocol,coreDataStack: CoreDataStack) {
    self.service = service
    self.coreDataStack = coreDataStack
  }

  func fetch() {
    self.notify(.setLoading(true))
    service.fetchDeviceList(url: ApiConstants.getAllDevicesURL) { [weak self] (result) in
      guard let self = self else { return }
      switch result {
      case .success(let devices):
        self.saveLocally(devices: devices)

      case .failure(let error):
        self.fetchFromCoreData()
      }
    }

  }

  func saveLocally(devices: [AnyObject]) {
    let deviceEntity = NSEntityDescription.entity(forEntityName: "Device", in: coreDataStack.managedContext)!
    for device in devices {
      if let id = device["id"] as? Int16,
         let name = device["name"] as? String,
         !someEntityExists(id: id)
         {
        let deviceObject = Device(entity: deviceEntity, insertInto: coreDataStack.managedContext)
        deviceObject.id = id
        deviceObject.name = name
      }

    }
    coreDataStack.saveContext()

    fetchFromCoreData()



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
        NSLog("Detele all data in \(entity) error :\(error)")
      }
  }
  func someEntityExists(id: Int16) -> Bool {
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Device")
      fetchRequest.predicate = NSPredicate(format: "id = %d", id)

      var results: [NSManagedObject] = []

      do {
        results = try coreDataStack.managedContext.fetch(fetchRequest)
      }
      catch {
        NSLog("error executing fetch request: \(error)")
      }

      return results.count > 0
  }

  func selectDevice(at index: Int) {
    let device = devices?[index]
    delegate?.navigateToDetailScreen(device: device!)
  }

  func notify(_ outputs: DeviceListVMOutput) {
    delegate?.handleViewModelOutputs(outputs)

  }



  func fetchFromCoreData() {
    fetchRequest = Device.fetchRequest()
    do {
      devices = try coreDataStack.managedContext.fetch(fetchRequest)
      if devices?.count == 0 {
        self.notify(.showDeviceList(nil))
      }
      else {
        self.notify(.showDeviceList(devices!))

      }
      self.notify(.setLoading(false))
    }
    catch {
      self.notify(.showDeviceList(nil))
    }


  }


}
