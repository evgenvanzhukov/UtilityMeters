//
//  ViewController.swift
//  UtilityMeters
//
//  Created by Evgen on 02/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import UIKit
import CoreData

class MetersViewController: UIViewController, CreateAble, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    var coordinator : Coordinator?
    var fetchResultController: NSFetchedResultsController<Report>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        fetchResultController?.delegate = self
    }
    

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.coordinator?.eventOccured(with: .settingsBtnPressed)
        })
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        self.coordinator?.eventOccured(with: .addMeters(model: nil))

    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchResultController?.sections?[section].objects?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchResultController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "repotCellId", for: indexPath)
            
            let report = fetchResultController?.object(at: indexPath)
            
            cell.textLabel?.text = "\(String(describing: report?.date))"
            let meters = report?.meters as! Set<Meter>
            let text = meters.map{"\($0.value ?? 0)"}.joined(separator: ", ")
        
            cell.detailTextLabel?.text = text
            return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            break

        default:
            return
        }

    }
}

