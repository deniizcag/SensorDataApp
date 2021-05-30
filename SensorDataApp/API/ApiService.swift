//
//  ApiService.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 29.05.2021.
//

import Foundation
import Alamofire
protocol FetchDeviceListServiceProtocol {
  func fetchDeviceList(url: String, completed: @escaping (Result<[AnyObject],SDError>) -> Void)
  func fetchDeviceReadings(url: String, completed: @escaping (Result<[AnyObject],SDError>) -> Void)
}


final class DeviceListService: FetchDeviceListServiceProtocol {


  func fetchDeviceList(url: String, completed: @escaping (Result<[AnyObject], SDError>) -> Void) {
    AF.request(url, method: .get, parameters: nil).responseJSON { (response) in
      switch response.result {
      case .success:
        do {
          print(response.data!)
          let devices = try! JSONSerialization.jsonObject(with: response.data!, options: []) as! [AnyObject]
          completed(.success(devices))

        }
        catch {
          completed(.failure(.AFError))
        }

      case .failure(let error):
        completed(.failure(.networkError))
        
      }
    }
    
  }

  func fetchDeviceReadings(url: String, completed: @escaping (Result<[AnyObject], SDError>) -> Void) {
    AF.request(url, method: .get, parameters: nil).responseJSON { (response) in
      switch response.result {
      case .success:
        do {
          print(response.data!)
          let readings = try! JSONSerialization.jsonObject(with: response.data!, options: []) as! [AnyObject]
          completed(.success(readings))
        }
        catch {
          completed(.failure(.AFError))
        }

      case .failure(let error):
        completed(.failure(.networkError))
      }


    }
  }






}



enum SDError: Error {
  case emptyData
  case parsingError
  case AFError
  case networkError
}

