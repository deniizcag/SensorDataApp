//
//  AppDelegate.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 29.05.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    app.router.start()
    return true
  }



}
