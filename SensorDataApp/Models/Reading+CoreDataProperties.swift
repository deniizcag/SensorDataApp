//
//  Reading+CoreDataProperties.swift
//  
//
//  Created by DenizCagilligecit on 30.05.2021.
//
//

import Foundation
import CoreData


extension Reading {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reading> {
        return NSFetchRequest<Reading>(entityName: "Reading")
    }

    @NSManaged public var created: String?
    @NSManaged public var deviceid: Int16
    @NSManaged public var id: Int16
    @NSManaged public var type: String?
    @NSManaged public var value: String?
    @NSManaged public var device: Device?

}
