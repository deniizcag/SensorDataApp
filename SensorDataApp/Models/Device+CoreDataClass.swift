//
//  Device+CoreDataClass.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 29.05.2021.
//
//

import Foundation
import CoreData

@objc(Device)
public class Device: NSManagedObject {
  enum CodingKeys: CodingKey {
    case id,name
  }


}
