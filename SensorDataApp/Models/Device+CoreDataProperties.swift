//
//  Device+CoreDataProperties.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 29.05.2021.
//
//

import Foundation
import CoreData


extension Device {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Device> {
        return NSFetchRequest<Device>(entityName: "Device")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?

}

extension Device : Identifiable {

}
