//
//  ApiService.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 29.05.2021.
//

import Foundation
import Alamofire
protocol FetchDeviceListServiceProtocol {
  func fetchDeviceList(url: String, completed: @escaping (Result<[Device],SDError>) -> Void)
  func fetchDeviceReadings(url: String, completed: @escaping (Result<[Reading],SDError>) -> Void)
}


final class DeviceInfoService: FetchDeviceListServiceProtocol {
  func fetchDeviceList(url: String, completed: @escaping (Result<[Device], SDError>) -> Void) {
    AF.request(url, method: .get, parameters: nil).responseJSON { (response) in
      switch response.result {
      case .success:
        do {

          let jsonDict = try! JSONSerialization.jsonObject(with: response.data!, options: [.allowFragments]) as! [String: AnyObject]
          print(jsonDict)
        }
        catch {
          completed(.failure(.AFError))
        }

      case .failure(let error):
        break
      }
    }
    
  }

  func fetchDeviceReadings(url: String, completed: @escaping (Result<[Reading], SDError>) -> Void) {

  }






}


enum SDError: Error {
  case emptyData
  case parsingError
  case AFError
  case networkError
}

