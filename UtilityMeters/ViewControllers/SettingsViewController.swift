//
//  SettingsViewController.swift
//  UtilityMeters
//
//  Created by Evgen on 07.12.2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, CreateAble, UITableViewDelegate, UITableViewDataSource {
    weak var coordinator : Coordinator?
//    var viewModel: [Setting] = {
//        return self.settingManager
//    }()
    var settingManager = SettingsManager()
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        print("SettingsViewController viewDidLoad")
    }
    

    

}

extension SettingsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing:  SettingsCell.self), for: indexPath
        ) as! SettingsCell
        
        cell.settings = settingManager.getSettings(nil)
        
        return cell
    }
}
