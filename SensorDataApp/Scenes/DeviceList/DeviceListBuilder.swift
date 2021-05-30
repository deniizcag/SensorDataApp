//
//  DeviceListBuilder.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 29.05.2021.
//

import UIKit

final class DeviceListBuilder {

    static func make() -> DeviceListViewController {
      let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DeviceListViewController") as DeviceListViewController
      viewController.viewModel = DeviceListViewModel(service: app.service, coreDataStack: CoreDataStack(modelName: "SensorDataApp"))
        return viewController
    }
}
