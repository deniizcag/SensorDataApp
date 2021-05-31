//
//  ReadingTableViewCell.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 30.05.2021.
//

import UIKit

class ReadingTableViewCell: UITableViewCell {


  @IBOutlet weak var sensorTypeLabel: UILabel!
  @IBOutlet weak var sensorValueLabel: UILabel!
  @IBOutlet weak var sensorLastActiveLabel: UILabel!
  @IBOutlet weak var sensorIdLabel: UILabel!

  

  func set(reading: Reading) {
    self.sensorIdLabel.text = String(reading.id)
    self.sensorTypeLabel.text = reading.type?.cellFormat()
    self.sensorValueLabel.text = reading.value
    self.sensorLastActiveLabel.text = reading.created?.formatDate()
  }

}
