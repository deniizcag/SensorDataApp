//
//  DeviceListViewController.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 29.05.2021.
//

import UIKit

class DeviceListViewController: BaseViewController {

  var devices = [Device]()

  var viewModel: DeviceListVMProtocol? {
    didSet {
      viewModel?.delegate = self
    }
  }
  @IBOutlet weak var collectionView: UICollectionView!


  override func viewDidLoad() {
    super.viewDidLoad()
    configureCollectionView()
    viewModel?.fetch()
  }
  fileprivate func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
  }


}
extension DeviceListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return devices.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let device = devices[indexPath.row]
    let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "deviceCell", for: indexPath) as! DeviceCollectionViewCell
    cell.deviceNameLabel.text = device.name
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel?.selectDevice(at: indexPath.row)
  }


}
extension DeviceListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

         let width = self.view.frame.width - 360
         let height: CGFloat = 120

         return CGSize(width: width, height: height)
     }
}
extension DeviceListViewController: DeviceListVMDelegate {
  func navigateToDetailScreen(device: Device) {
    let detailViewController = DeviceDetailBuilder.make(device: device)
    navigationController?.pushViewController(detailViewController, animated: true)
  }

  func handleViewModelOutputs(_ output: DeviceListVMOutput) {
    switch output {
    case .showDeviceList(let devices):
      if let devices = devices {
        self.devices = devices
        collectionView.reloadData()
      }
      else {
        showAlert(message: "Oops. Something went wrong!..")

      }
      

    case .setLoading(let isLoading):
      if isLoading {
        showSpinner()
      }
      else {
        removeSpinner()
      }

    default:
      break
    }

  }



}

