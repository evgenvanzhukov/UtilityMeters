//
//  SettingsCell.swift
//  UtilityMeters
//
//  Created by Evgen on 07.12.2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet weak var dateFromPicker: UIDatePicker!
    
    @IBOutlet weak var dateToPicker: UIDatePicker!
    
    @IBOutlet weak var gasField: UITextField!
    @IBOutlet weak var waterField: UITextField!
    @IBOutlet weak var electroField: UITextField!
    var settings: [MeterRate]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configure(settings)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ settings: [MeterRate]?) {
        guard settings != nil, settings!.count > 0 else {
            gasField.text = "gas"
            waterField.text = "water"
            electroField.text = "electro"
            return
        }
        let gasRate = settings!.first(where: { (s) -> Bool in
            s.meterType == MeterType.gas
        })?.rate
        gasField.text = "\(gasRate)"
        //waterField.text = settings
    }
}
