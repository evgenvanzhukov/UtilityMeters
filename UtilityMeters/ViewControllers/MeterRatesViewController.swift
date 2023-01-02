//
//  SettingsViewController.swift
//  UtilityMeters
//
//  Created by Evgen on 07.12.2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import UIKit

class MeterRatesViewController: UIViewController, CreateAble, UITableViewDelegate, UITableViewDataSource {
    var coordinator : Coordinator?
    

    var meterRatesManager = MeterRateManager()
    var allRates = MeterRateManager().getAll()
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        
        let nib = UINib(nibName: String(describing: MeterRateCell.self), bundle: nil)
        
        table.register(nib, forCellReuseIdentifier: String(describing: MeterRateCell.self))
    }
    
    func refresh() {
        allRates = meterRatesManager.getAll()
        table.reloadData()
    }
    

}

extension MeterRatesViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allRates.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var rates = getMeterRates(at: section)
        var first = rates?.first
        return first?.meterName ?? ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMeterRates(at: section)?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:  MeterRateCell.self), for: indexPath
        )
        
        guard let meterRateCell = cell as? MeterRateCell else {
            return cell
        }
        
        let meterRates = getMeterRates(at: indexPath.section)
        
        if let rates = meterRates {
            let rate = rates[indexPath.row]
            meterRateCell.configure(rate)
            return meterRateCell
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            meterRatesManager.deleteRate(type: Array(allRates.keys)[indexPath.section], row: indexPath.row)
            refresh()
        default:
            print("other")
        }
    }
    
    
    private func getMeterRates( at section: Int) -> [MeterRate]? {
        
        let index = Array(allRates.keys)[section]
        return allRates[index]
    }
    
}
