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
    var viewModel: [Setting]?
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        saveAndClose()
    }
    
    @IBOutlet weak var gasUnitField: UITextField!
    @IBOutlet weak var gasRateField: UITextField!
    
    @IBOutlet weak var waterRateField: UITextField!
    @IBOutlet weak var waterUnitField: UITextField!
    
    @IBOutlet weak var electroRateField: UITextField!
    @IBOutlet weak var electroUnitField: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let settings = settingsManager.getSettings(),
            let gasSetting = settings.first(where: {$0.meterType == .gas}),
            let waterSetting = settings.first(where: {$0.meterType == .water}),
            let electroSetting = settings.first(where: {$0.meterType == .electro})  {
            
            self.viewModel = settings
            
            gasRateField.text = "\(gasSetting.rate)"
            gasUnitField.text = gasSetting.meterUnits
            
            waterRateField.text = "\(waterSetting.rate)"
            waterUnitField.text = waterSetting.meterUnits
            
            electroRateField.text = "\(electroSetting.rate)"
            electroUnitField.text = electroSetting.meterUnits
        }
        else {
            viewModel = [Setting]()
        }

        
        gasUnitField.delegate = self
        gasRateField.delegate = self
        
        waterRateField.delegate = self
        waterUnitField.delegate = self
        
        electroRateField.delegate = self
        electroUnitField.delegate = self
    }
    
    func saveAndClose() {
        
        viewModel = [Setting]()
        viewModel!.append(
            Setting(meterName: "Газ", meterType: .gas, meterUnits: gasUnitField!.text!, rate: Decimal(string: gasRateField!.text!) ?? 0))
        viewModel!.append(
            Setting(meterName: "Вода", meterType: .water, meterUnits: waterUnitField!.text!, rate: Decimal(string:waterRateField!.text!) ?? 0))
        viewModel!.append(
            Setting(meterName: "Электр.", meterType: .electro, meterUnits: electroUnitField!.text!, rate: Decimal(string: electroRateField!.text!) ?? 0))
        
        settingsManager.setSettings(value: viewModel!)
        
        //self.dismiss(animated: false, completion: nil)
        
        coordinator?.navigationControoler.popViewController(animated: true)
    }
}
