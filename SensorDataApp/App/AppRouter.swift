//
//  AppRouter.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 29.05.2021.
//

import UIKit


final class AppRouter {
    let window: UIWindow
    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
    }
    func start() {
      let viewController = DeviceListBuilder.make()
      viewController.viewModel =  DeviceListViewModel(service: app.service, coreDataStack: CoreDataStack(modelName: "SensorDataApp"))
      let rootController = UINavigationController(rootViewController: viewController)
        window.rootViewController = rootController
        window.makeKeyAndVisible()
    }
}
