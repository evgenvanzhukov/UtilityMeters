//
//  ViewController.swift
//  UtilityMeters
//
//  Created by Evgen on 02/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import UIKit

class MetersViewController: UIViewController, CreateAble {

    @IBAction func settingsBtnPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.coordinator?.eventOccured(with: .settingsBtnPressed)
        })
    }
    
    var coordinator : Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

