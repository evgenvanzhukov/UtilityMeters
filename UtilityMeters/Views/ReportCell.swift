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
    
    var calculator: Calculator?

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var gasSummaryLabel: UILabel!
    @IBOutlet weak var waterSummaryLabel: UILabel!
    @IBOutlet weak var electroSummaryLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with report: Report, last: Report?) {
        
        calculator = Calculator(report: report, last: last)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateLabel.text = dateFormatter.string(from: report.date!)
        
        

        gasSummaryLabel.text = formatValueString(value: calculator!.gas!.value, lastValue: calculator!.lastGas?.value)
        waterSummaryLabel.text = formatValueString(value: calculator!.water!.value, lastValue: calculator!.lastWater?.value)
        electroSummaryLabel.text = formatValueString(value: calculator!.electro!.value, lastValue: calculator!.lastElectro?.value)
        
        let total = calculator!.calculateTotal()
        
        totalPriceLabel.text = total > 0 ? "\(total) руб" : ""
    }
    
    func formatValueString(value: NSDecimalNumber?, lastValue: NSDecimalNumber?) -> String {
        if lastValue == nil {
            return "\(value!)"
        }
        return "\(value!) - \(lastValue ?? 0) = \(value!.subtracting(lastValue!))"
    }
    
}
