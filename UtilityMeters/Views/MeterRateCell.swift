//
//  SettingsCell.swift
//  UtilityMeters
//
//  Created by Evgen on 07.12.2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import UIKit

class MeterRateCell: UITableViewCell {

    @IBOutlet weak var dateFromPicker: UIDatePicker!
    
    @IBOutlet weak var dateToPicker: UIDatePicker!
    
    @IBOutlet weak var rateUnitLabel: UILabel!
    
    @IBOutlet weak var rateValueLabel: UILabel!
    
    var cellModel: MeterRate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateFromPicker.isEnabled = false
        dateToPicker.isEnabled = false
        //configure(cellModel!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ rate: MeterRate) {
        
        rateValueLabel.text = "\(rate.rate)"
        rateUnitLabel.text = rate.meterUnits != "" ? rate.meterUnits : "руб/ед.изм"
        dateFromPicker.date = rate.dateFrom
        if let todate = rate.dateTo {
            dateToPicker.date = todate
        }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            dateToPicker.date =  dateFormatter.date(from: "31.12.2099")! //rate.dateFrom.addingTimeInterval(60*60*24*365)
        }
    }
}
