//
//  Calculator.swift
//  UtilityMeters
//
//  Created by Evgen on 19.11.2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import Foundation

class Calculator {
    
    var meterRates: [MeterRate]?
    
    var lastGas, lastWater, lastElectro, gas, water, electro : Meter?
    
    var gasValue: Decimal {
        get {
            return gas!.value!.decimalValue
        }
    }
 
    var waterValue: Decimal {
        get {
            return water!.value!.decimalValue
        }
    }
    var electroValue: Decimal {
        get {
            return electro!.value!.decimalValue
        }
    }
    
    var lastGasValue: Decimal {
        get {
            return lastGas?.value?.decimalValue ?? 0
        }
    }
    var lastWaterValue: Decimal {
        get {
            return lastWater?.value?.decimalValue ?? 0
        }
    }
    var lastElectroValue: Decimal {
        get {
            return lastElectro?.value?.decimalValue ?? 0
        }
    }
    
    init(report: Report, last: Report?)
    {
        meterRates = MeterRateManager().getRates(report.date)
        
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
    
    
    
    
    
    func calculateValue(for type:MeterType) -> Decimal {
        
        switch type {
           
        case .gas:
            if lastGas?.value == nil {
                return 0
            }
            return gas!.value!.decimalValue  - lastGas!.value!.decimalValue
        case .water:
            if lastWater?.value == nil {
                return 0
            }
            return water!.value!.decimalValue  - lastWater!.value!.decimalValue
        case .electro:
            if lastElectro?.value == nil {
                return 0
            }
            return electro!.value!.decimalValue  - lastElectro!.value!.decimalValue
        }
    }
    
    
    func calculateTotal() -> Decimal {
        
        if let gasRate = meterRates!.first(where: {$0.meterType == MeterType.gas})?.rate,
            let waterRate = meterRates!.first(where: {$0.meterType == MeterType.water})?.rate,
            let electroRate = meterRates!.first(where: {$0.meterType == MeterType.electro})?.rate {
            
            return calculateValue(for: .gas) * gasRate
                + calculateValue(for: .water) * waterRate
                + calculateValue(for: .electro) * electroRate
        }
        
        return 0
    }
}
