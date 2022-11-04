//
//  DetailViewController.swift
//  UtilityMeters
//
//  Created by Evgen on 02/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, CreateAble, UITextFieldDelegate {

    var coordinator : Coordinator?
    var viewModel: DetailViewModel?
    
    @IBOutlet weak var waterTextField: UITextField!
    @IBOutlet weak var gasTextField: UITextField!
    @IBOutlet weak var electroTextField: UITextField!
    @IBOutlet weak var comentLabel: UILabel!
    
    
    @IBAction func saveBtnPressed() {
        // todo: check add or edit ??
        guard var model = viewModel,
            gasTextField.text != nil,
            waterTextField.text != nil,
            electroTextField.text != nil,
            let gasValue = Decimal(string: gasTextField.text!),
            let waterValue = Decimal(string: waterTextField.text!),
            let electroValue = Decimal(string: electroTextField.text!)
            else {
                return
        }
        model.gasValue = gasValue
        model.waterValue = waterValue
        model.electroValue = electroValue
        self.coordinator?.eventOccured(with: .addMeters(model: model))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    func configure() {
        if let model = viewModel {
            gasTextField.text = "\(model.gasValue ?? 0)"
            waterTextField.text = "\(model.waterValue ?? 0)"
            electroTextField.text = "\(model.electroValue ?? 0)"
        }
        else {
            viewModel = DetailViewModel(gasValue: 0, waterValue: 0, electroValue: 0)
            //todo: set from last meters
        }
        
        gasTextField.delegate = self
        waterTextField.delegate = self
        electroTextField.delegate = self
    }

}
