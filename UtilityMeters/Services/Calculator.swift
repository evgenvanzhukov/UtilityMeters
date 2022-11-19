//
//  Calculator.swift
//  UtilityMeters
//
//  Created by Evgen on 19.11.2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import Foundation

class Calculator {
    
    var settings: [Setting]?
    
    var lastGas, lastWater, lastElectro, gas, water, electro : Meter?

    
    init(report: Report, last: Report?)
    {
        settings = SettingsManager().getSettings()
        
        guard let meters = report.meters?.allObjects as? [Meter],
              let gas = meters.first(MeterType.gas ),
              let water = meters.first(MeterType.water ),
              let electro = meters.first(MeterType.electro )

            else {
            return
        }
        
        self.gas = gas
        self.water = water
        self.electro = electro
        
        if last != nil {
            let lastMeters = last?.meters?.allObjects as? [Meter]
            
            lastGas = lastMeters?.first(MeterType.gas )
            lastWater = lastMeters?.first(MeterType.water )
            lastElectro = lastMeters?.first(MeterType.electro )
        }
    }
    
    
    
    
    
    func calculateValue(_ value: NSDecimalNumber?, _ lastValue: NSDecimalNumber?) -> Decimal {
        if lastValue == nil {
            return 0
        }
        return value!.decimalValue  - lastValue!.decimalValue
    }
    
    func calculateTotal() -> Decimal {
        
        if let gasRate = settings!.first(where: {$0.meterType == MeterType.gas})?.rate,
            let waterRate = settings!.first(where: {$0.meterType == MeterType.water})?.rate,
            let electroRate = settings!.first(where: {$0.meterType == MeterType.electro})?.rate {
            
            return calculateValue(gas!.value, lastGas?.value) * gasRate
                + calculateValue(water!.value, lastWater?.value) * waterRate
                + calculateValue(electro!.value, lastElectro?.value) * electroRate
            
            
        }
        
        return 0
    }
}
