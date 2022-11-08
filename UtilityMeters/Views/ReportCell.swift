//
//  ReportCell.swift
//  UtilityMeters
//
//  Created by Evgen on 07/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import UIKit
import Foundation

class ReportCell: UITableViewCell {
    
    var settings: [Setting]?

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var gasSummaryLabel: UILabel!
    @IBOutlet weak var waterSummaryLabel: UILabel!
    @IBOutlet weak var electroSummaryLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        settings = SettingsManager().getSettings()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with report: Report, last: Report?) {
        
        guard let date = report.date,
            settings != nil,
            let meters = report.meters?.allObjects as? [Meter],
            let gas = meters.first(MeterType.gas ),
            let water = meters.first(MeterType.water ),
            let electro = meters.first(MeterType.electro )

            else {
            return
        }
        
        var lastGas, lastWater, lastElectro : Meter?
        
        if last != nil {
            let lastMeters = last?.meters?.allObjects as? [Meter]
            
            lastGas = lastMeters?.first(MeterType.gas )
            lastWater = lastMeters?.first(MeterType.water )
            lastElectro = lastMeters?.first(MeterType.electro )
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateLabel.text = dateFormatter.string(from: date)

        gasSummaryLabel.text = formatValueString(value: gas.value, lastValue: lastGas?.value)
        waterSummaryLabel.text = formatValueString(value: water.value, lastValue: lastWater?.value)
        electroSummaryLabel.text = formatValueString(value: electro.value, lastValue: lastElectro?.value)
        
        if let gasRate = settings!.first(where: {$0.meterType == MeterType.gas})?.rate,
            let waterRate = settings!.first(where: {$0.meterType == MeterType.water})?.rate,
            let electroRate = settings!.first(where: {$0.meterType == MeterType.electro})?.rate {
            
            let total = calculateValue(gas.value, lastGas?.value) * gasRate
                + calculateValue(water.value, lastWater?.value) * waterRate
                + calculateValue(electro.value, lastElectro?.value) * electroRate
            
            totalPriceLabel.text = total > 0 ? "\(total) руб" : ""
        }
    }
    
    func formatValueString(value: NSDecimalNumber?, lastValue: NSDecimalNumber?) -> String {
        if lastValue == nil {
            return "\(value!)"
        }
        return "\(value!) - \(lastValue ?? 0) = \(value!.subtracting(lastValue!))"
    }
    
    func calculateValue(_ value: NSDecimalNumber?, _ lastValue: NSDecimalNumber?) -> Decimal {
        if lastValue == nil {
            return 0
        }
        return value!.decimalValue  - lastValue!.decimalValue
    }
    
}
