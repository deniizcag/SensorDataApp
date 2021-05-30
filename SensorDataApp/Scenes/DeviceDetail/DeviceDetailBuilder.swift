//
//  DeviceDetailBuilder.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 30.05.2021.
//

import UIKit

final class DeviceDetailBuilder {

  static func make(device: Device) -> DeviceDetailViewController {
    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DeviceDetailViewController") as DeviceDetailViewController
    let viewModel = DeviceDetailViewModel(service: app.service,coreDataStack: CoreDataStack(modelName: "SensorDataApp"))
    viewModel.device = device
    viewController.viewModel = viewModel
    return viewController
  }
}
