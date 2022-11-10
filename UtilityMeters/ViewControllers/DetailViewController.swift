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
    var isNewReport = true
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var waterTextField: UITextField!
    @IBOutlet weak var gasTextField: UITextField!
    @IBOutlet weak var electroTextField: UITextField!
    @IBOutlet weak var comentLabel: UILabel!
    
    @IBAction func datePickerChanged(_ sender: Any) {
        viewModel?.date = datePicker.date
    }
    
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
        model.date = datePicker.date
        let eventType: EventType = isNewReport ? .addMeters(model: model) : .editMeters(model: model)
        (self.coordinator as? MetersCoordinator)?.eventOccured(with: eventType)
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
            datePicker.date = model.date ?? Date()
        }
        else {
            viewModel = DetailViewModel(gasValue: 0, waterValue: 0, electroValue: 0, date: Date())
            
            //todo: set from last meters
        }
        datePicker.date = viewModel?.date ?? Date()
        gasTextField.delegate = self
        waterTextField.delegate = self
        electroTextField.delegate = self
    }

}
