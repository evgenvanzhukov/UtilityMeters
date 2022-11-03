//
//  DetailViewController.swift
//  UtilityMeters
//
//  Created by Evgen on 02/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, CreateAble {

    var coordinator : Coordinator?
    
    
    @IBOutlet weak var waterTextField: UITextField!
    @IBOutlet weak var gasTextField: UITextField!
    @IBOutlet weak var electroTextField: UITextField!
    @IBOutlet weak var comentLabel: UILabel!
    @IBAction func saveBtnPressed() {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
