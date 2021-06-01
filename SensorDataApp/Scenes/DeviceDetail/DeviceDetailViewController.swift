//
//  DeviceDetailViewController.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 30.05.2021.
//

import UIKit

class DeviceDetailViewController: BaseViewController {

  var readings = [Reading]()
  private let filterViewControllerSegueIdentifier = "toFilterViewController"

  @IBOutlet weak var tempMaxLabel: UILabel!
  @IBOutlet weak var tempMinLabel: UILabel!
  @IBOutlet weak var tempAvgLabel: UILabel!
  @IBOutlet weak var humMaxLabel: UILabel!
  @IBOutlet weak var humMinLabel: UILabel!
  @IBOutlet weak var humAvgLabel: UILabel!
  @IBOutlet weak var airMaxLabel: UILabel!
  @IBOutlet weak var airMinLabel: UILabel!
  @IBOutlet weak var airAvgLabel: UILabel!
  


  var viewModel: DeviceDetailVMProtocol? {
    didSet {
      viewModel?.delegate = self
    }
  }
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel?.fetchReadings()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = 130

  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      guard segue.identifier == filterViewControllerSegueIdentifier, let navController = segue.destination as? UINavigationController, let filterVC = navController.topViewController as? FilterViewController else { return }
      filterVC.coreDataStack = CoreDataStack(modelName: "SensorDataApp")
      filterVC.delegate = self
  }

}
extension DeviceDetailViewController: FilterViewControllerDelegate {
  func filterViewController(filter: FilterViewController, didSelectPredicate predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?) {
    viewModel?.fetchFor(predicate: predicate, sort: sortDescriptor)
    
  }


}
extension DeviceDetailViewController: UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return readings.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reading = readings[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "readingCell", for: indexPath) as! ReadingTableViewCell
    cell.set(reading: reading)
    return cell
  }
}
extension DeviceDetailViewController: DeviceDetailVMDelegate {
  func handleViewModelOutputs(_ outputs: DeviceDetailVMOutput) {
    switch outputs {
    case .showReadingList(let readings):
      self.readings = readings
      tableView.reloadData()
      if readings.isEmpty {
        self.showAlert(message: "There is no available data for this device!")
      }
    case .updateValues(let dataType, let values):
      switch dataType {
      case .Temperature:
        self.tempMaxLabel.text = values.max()?.toString()
        self.tempMinLabel.text = values.min()?.toString()
        self.tempAvgLabel.text = values[2].toString()
      case .Humidity:
        self.humMaxLabel.text = values.max()?.toString()
        self.humMinLabel.text = values.min()?.toString()
        self.humAvgLabel.text = values[2].toString()
      case .AirQuality:
        self.airMaxLabel.text = values.max()?.toString()
        self.airMinLabel.text = values.min()?.toString()
        self.airAvgLabel.text = values[2].toString()
      }
    case .setLoading(let isLoading):
      if isLoading {
        showSpinner()
      }
      else {
        removeSpinner()
      }

    case .updateTitle(let title):
      self.title = title
    }
  }


}


