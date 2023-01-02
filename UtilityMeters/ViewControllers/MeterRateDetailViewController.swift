//
//  SettingsViewController.swift
//  UtilityMeters
//
//  Created by Evgen on 02/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import UIKit





class MeterRateDetailViewController: UIViewController, CreateAble, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    

    var coordinator : Coordinator?
    var settingsManager = MeterRateManager()
    var viewModel: RateDetailViewModel?
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        saveAndClose()
    }
    
    @IBOutlet weak var rateUnitField: UITextField!
    @IBOutlet weak var rateValueField: UITextField!
    
    @IBOutlet weak var datePickeFrom: UIDatePicker!
    
    @IBOutlet weak var rateTypeNameTextField: UITextField!
    
    
    private var rateNamesPickerView: UIPickerView = {
        var picker = UIPickerView()
        return picker
    }()
    
    private var toolbar: UIToolbar = {
       var toolbar = UIToolbar()
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker(_:)))
        toolbar.items = [doneBarButtonItem]
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        return toolbar
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerView()
        setupTextFields()
        initViewModel()
        datePickeFrom.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    func setupPickerView() {
        rateNamesPickerView.delegate = self
        rateNamesPickerView.dataSource = self
    }
    
    func setupTextFields() {
        rateTypeNameTextField.delegate = self
        rateTypeNameTextField.inputView = rateNamesPickerView
        rateTypeNameTextField.inputAccessoryView = toolbar
        
        rateUnitField.delegate = self
        rateValueField.delegate = self
        rateValueField.keyboardType = .numbersAndPunctuation
        rateUnitField.keyboardType = .default
        rateValueField.becomeFirstResponder()
    }
    
    func saveAndClose() {
        guard let model = viewModel else { return  }
        print("view model date", model.date!)
        var rate = MeterRate(meterName: model.meterName.rawValue, meterType: model.meterName.getRateType(), meterUnits: model.unit, rate: model.price ?? 0, dateFrom: model.date!)
        
        (self.coordinator as! MeterRatesCoordinator).addMeterRate(with: rate)

    }
    
    func initViewModel() {
        if viewModel == nil {
            viewModel = RateDetailViewModel(meterName: .gas, date: Date(), price: 0, unit: "")
            rateTypeNameTextField.text = MeterNames.gas.rawValue
        }
    }
    
    @objc
    func donePicker( _ sender: UIBarButtonItem) {
        let row = rateNamesPickerView.selectedRow(inComponent: 0)
        rateTypeNameTextField.text = MeterNames.allCases[row].rawValue
        viewModel?.meterName = MeterNames.allCases[row]
        view.endEditing(true)
    }
    
    @objc
    func dateChanged( _ sender: UIDatePicker) {
        viewModel?.date = sender.date
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return MeterNames.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MeterNames.allCases.count
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.rateTypeNameTextField {
            let row = MeterNames.allCases.firstIndex { (rateTypeName) -> Bool in
                rateTypeName.rawValue == self.rateTypeNameTextField.text
            }

            if let row = row {
                rateNamesPickerView.selectRow(row, inComponent: 0, animated: true)
            }
            return
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if [rateValueField, rateUnitField].contains(textField) {
            
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.rateValueField {
            var allowedCharacters = CharacterSet.decimalDigits
            allowedCharacters.insert(".")
            let characterSet = CharacterSet(charactersIn: string)
            let result = allowedCharacters.isSuperset(of: characterSet)
            return result
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.rateUnitField {
            viewModel?.unit = textField.text ?? ""
        }
        if textField == self.rateValueField {
            viewModel?.price = Decimal(string: textField.text ?? "0")
        }
    }
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
}
