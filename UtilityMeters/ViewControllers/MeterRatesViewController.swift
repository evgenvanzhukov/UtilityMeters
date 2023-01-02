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
    

    
    var meterRatesManager = MeterRateManager() //убрать нахуй отсюда. чтобы каждый раз не вызывать GetAll
    var allRates = MeterRateManager().getAll()
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        
        print("SettingsViewController viewDidLoad")
        if let appCoordinator = coordinator as? AppCoordinator {
            print("app")
        }
        if let rateCoordinator = coordinator as? MeterRatesCoordinator {
            print("rate")
        }
        
        let nib = UINib(nibName: String(describing: MeterRateCell.self), bundle: nil)
        
        table.register(nib, forCellReuseIdentifier: String(describing: MeterRateCell.self))
    }
    
    func refresh() {
        print("refresh data")
        allRates = meterRatesManager.getAll()
        table.reloadData()
    }
    

}

extension MeterRatesViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allRates.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print("section:", section)
        var rates = getMeterRates(at: section)
        var first = rates?.first
        print("first at section", first)
        return first?.meterName ?? ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMeterRates(at: section)?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:  MeterRateCell.self), for: indexPath
        )
        
        guard let meterRateCell = cell as? MeterRateCell else {
            return cell
        }
        
        
        
        let meterRates = getMeterRates(at: indexPath.section)
        //print(meterRates)
        if let rates = meterRates {
            //print("index path row", indexPath.row)
            //print("index path section:", indexPath.section)
            let rate = rates[indexPath.row]
            //print("rate", rate)
            meterRateCell.configure(rate)
            return meterRateCell
        }
        return cell
    }
    
    private func getMeterRates( at section: Int) -> [MeterRate]? {
        
        let index = Array(allRates.keys)[section]
        //print("index: ", index)
        //print("all rates count", allRates.count)
        return allRates[index]
    }
}
