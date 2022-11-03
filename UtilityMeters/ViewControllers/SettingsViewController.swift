//
//  SettingsViewController.swift
//  UtilityMeters
//
//  Created by Evgen on 02/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, CreateAble, UITextFieldDelegate {

    var coordinator : Coordinator?
    var settingsManager = SettingsManager()
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        saveAndClose()
    }
    
    @IBOutlet weak var gasUnitField: UITextField!
    @IBOutlet weak var gasRateField: UITextField!
    
    @IBOutlet weak var waterRateField: UITextField!
    @IBOutlet weak var waterUnitField: UITextField!
    
    @IBOutlet weak var electoRateField: UITextField!
    @IBOutlet weak var electroUnitField: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gasUnitField.delegate = self
        gasRateField.delegate = self
        
        waterRateField.delegate = self
        waterUnitField.delegate = self
        
        electoRateField.delegate = self
        electroUnitField.delegate = self
    }
    
    func saveAndClose() {
        
        var settings = [Setting]()
        settings.append(
            Setting(meterName: "Газ", meterType: .gas, meterUnits: gasUnitField!.text!, rate: Decimal(string: gasRateField!.text!) ?? 0))
        settings.append(
            Setting(meterName: "Вода", meterType: .water, meterUnits: waterUnitField!.text!, rate: Decimal(string:waterRateField!.text!) ?? 0))
        settings.append(
            Setting(meterName: "Электр.", meterType: .electro, meterUnits: electroUnitField!.text!, rate: Decimal(string: electoRateField!.text!) ?? 0))
        
        settingsManager.setSettings(value: settings)
        
        self.dismiss(animated: false, completion: nil)
        
        coordinator?.navigationControoler.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
