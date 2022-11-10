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
    
    weak var coordinator : Coordinator?
    var fetchResultController: NSFetchedResultsController<Report>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTable()
        fetchResultController?.delegate = self
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            break
        case .update:
            tableView.reloadData()
            
        default:
            print(indexPath, newIndexPath, anObject)
            return
        }
    }
    
    
    func configureTable() {
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: String(describing: ReportCell.self), bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: String(describing: ReportCell.self))
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchResultController?.sections?[section].objects?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchResultController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReportCell.self), for: indexPath)
            var last: Report? = nil
            
            if indexPath.row < tableView.numberOfRows(inSection: indexPath.section) - 1 {
                last = fetchResultController?.object(at: IndexPath(row: indexPath.row+1, section: indexPath.section)) ?? CoreDataManager().getInitial()
            }
            
            guard let reportCell = cell as? ReportCell,
                let report = fetchResultController?.object(at: indexPath)
                else {
                return cell
            }
            
            
            reportCell.configure(with: report, last: last )

            return reportCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let report = fetchResultController?.object(at: indexPath)
            coordinator?.eventOccured(with: .deleteReport(model: report!))
            tableView.reloadData()
            return
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let report = fetchResultController?.object(at: indexPath),
            let meters = report.meters?.allObjects as? [Meter],
            let gas = meters.first(.gas),
            let water = meters.first(.water),
            let electro = meters.first(.electro)
            else {
            return
        }
        
        let model = DetailViewModel(gasValue: gas.value?.decimalValue, waterValue: water.value?.decimalValue, electroValue: electro.value?.decimalValue, date: report.date, calculating: nil)
        
        coordinator?.eventOccured(with: .editMeters(model: model))
    }
}

