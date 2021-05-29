//
//  DeviceCollectionViewCell.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 29.05.2021.
//

import UIKit

class DeviceCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var deviceNameLabel: UILabel!

  override func prepareForReuse() {
    super.prepareForReuse()
    backgroundColor = .systemBackground
  }
}
