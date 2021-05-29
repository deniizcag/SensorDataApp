//
//  ViewController.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 29.05.2021.
//

import UIKit

class ViewController: UIViewController {

  var devices = ["Device 1","Device 2","Device 3","Device 4","Device 5"]

  @IBOutlet weak var collectionView: UICollectionView!
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.delegate = self
    collectionView.dataSource = self
   
  }


}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return devices.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let device = devices[indexPath.row]
    let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "deviceCell", for: indexPath) as! DeviceCollectionViewCell
    cell.deviceNameLabel.text = device
    return cell
  }


}
extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

         let width = self.view.frame.width - 32.0 * 2
         let height: CGFloat = 150

         return CGSize(width: width, height: height)
     }
}

