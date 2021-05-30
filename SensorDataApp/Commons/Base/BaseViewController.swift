//
//  BaseViewController.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 29.05.2021.
//

import UIKit

class BaseViewController: UIViewController {
  var vSpinner : UIView?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func showAlert(message: String) {
   let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
      self.dismiss(animated: true, completion: nil)
      self.navigationController?.popViewController(animated: true)
        }))
   self.present(alert, animated: true, completion: nil)
 }



  func showSpinner() {

    let spinnerView = UIView.init(frame: view.bounds)
    spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    let ai = UIActivityIndicatorView.init()
    ai.style = .medium


    ai.startAnimating()
    ai.center = spinnerView.center

    DispatchQueue.main.async {
      spinnerView.addSubview(ai)
      self.view.addSubview(spinnerView)
    }

    vSpinner = spinnerView
  }

  func removeSpinner() {
    DispatchQueue.main.async {
      self.vSpinner?.removeFromSuperview()
      self.vSpinner = nil
    }

     func showAlert() {
      let alert = UIAlertController(title: "Alert", message: "Something went wrong!", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        switch action.style {
        case .default:
          self.dismiss(animated: true, completion: nil)
          self.navigationController?.popViewController(animated: true)
        case .cancel:
          NSLog("cancel")

        case .destructive:
          NSLog("destructive")

        }
      }))
      self.present(alert, animated: true, completion: nil)
    }
  }

}
