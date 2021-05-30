//
//  FilterViewController.swift
//  SensorDataApp
//
//  Created by DenizCagilligecit on 31.05.2021.
//

import UIKit
import CoreData


protocol FilterViewControllerDelegate: class {
    func filterViewController(filter: FilterViewController,
                              didSelectPredicate predicate: NSPredicate?,
                              sortDescriptor: NSSortDescriptor?)
}

class FilterViewController: UITableViewController {

  var coreDataStack: CoreDataStack!

  weak var delegate: FilterViewControllerDelegate?
  var selectedSortDescriptor: NSSortDescriptor? = nil
  var selectedPredicate: NSPredicate? = nil

  @IBAction func dismissButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }


  @IBAction func searchButtonPressed(_ sender: Any) {
    delegate?.filterViewController(filter: self, didSelectPredicate: selectedPredicate, sortDescriptor: selectedSortDescriptor)
    dismiss(animated: true, completion: nil)
  }


  func selectType(type: String) -> NSPredicate {
    return NSPredicate(format: "%K == %@", #keyPath(Reading.type), type)
  }

  func selectValueSorting(isAscending: Bool) -> NSSortDescriptor {
    let compareSelector = #selector(NSString.localizedStandardCompare(_:))
    return NSSortDescriptor(key: #keyPath(Reading.value),
                            ascending: isAscending,
                            selector: compareSelector)
  }
  func selectTimeSorting(isAscending: Bool) -> NSSortDescriptor {
    let compareSelector = #selector(NSString.localizedStandardCompare(_:))
    return NSSortDescriptor(key: #keyPath(Reading.value),
                            ascending: isAscending,
                            selector: compareSelector)
  }



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
extension FilterViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else {return}

    switch cell.textLabel?.text {
    case "Temperature":
     selectedPredicate = selectType(type: "temperature")
    case "Humidity":
      selectedPredicate = selectType(type: "humidity")
    case "Air Quality":
      selectedPredicate = selectType(type: "air_quality")
    case "Value (Ascending - Desending)":
      selectedSortDescriptor = selectValueSorting(isAscending: true)
    case "Value (Descending -Ascending)":
      selectedSortDescriptor = selectValueSorting(isAscending: false)
    case "Time (Newest - Oldest)":
      selectedSortDescriptor = selectTimeSorting(isAscending: true)
    case "Time (Oldest - Newest)":
      selectedSortDescriptor = selectTimeSorting(isAscending: false)
     default:
      break
    }
    cell.accessoryType = .checkmark

  }
}
