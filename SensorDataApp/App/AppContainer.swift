//
//  AppContainer.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 29.05.2021.
//

import Foundation

let app = AppContainer()

final class AppContainer {
  let router = AppRouter()
  let service = DeviceListService()
}
