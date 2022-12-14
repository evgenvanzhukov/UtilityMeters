//
//  SettingsManager.swift
//  UtilityMeters
//
//  Created by Evgen on 02/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import Foundation


protocol MeterRateProtocol {
    
    ///Возвращает значение одного тарифа на определенную дату
    func getRate(for type: MeterType, on date: Date?) -> MeterRate?
    
    ///возвращает актуальные тарифы на определенную дату
    func getRates(_ date: Date?) -> [MeterRate]?
    
    //////добавляет новое значение тарифа
    func addRate(_ value: MeterRate)
    
    ///Возвращает все значения тарифов
    func getAll() -> [MeterType : [MeterRate]]
}

/// Сервис работы с настройками
class MeterRateManager : MeterRateProtocol {
    
    
    let userDefaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    var formatter = DateFormatter()
    
    var maxDate: Date {
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2999-12-31")!
    }
    
    var minDate: Date {
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2000-01-01")!
    }
    
    var today : Date {
        return Date()
    }
    
    // MARK: - proocol
    
    func getAll() -> [MeterType : [MeterRate]] {
        guard let json = userDefaults.object(forKey: String(describing: MeterRate.self)) as? Data?, let data = json else {
            return [:]
        }
        if let dict = try? decoder.decode((Dictionary<MeterType, [MeterRate]>).self, from: data) {
            return dict
        }
        return [:]
    }
    
    func getRate(for type: MeterType, on date: Date?) -> MeterRate? {
        let all = getAll()
        guard let settings = all[type], settings.count > 0 else {
            return nil
        }
        let searchDate = date ?? today
        return settings.first { (s) -> Bool in
            s.dateFrom < searchDate && (s.dateTo ?? maxDate) > searchDate
        }
    }
    
    func getRates(_ date: Date?) -> [MeterRate]? {
        let all = getAll()
        
        guard all.count > 0,
              let gas = all[MeterType.gas], gas.count > 0,
              let water = all[MeterType.water], water.count > 0,
              let electro = all[MeterType.electro], electro.count > 0
              else {
            return nil
        }
        
        let gasSetting = filterSetting(gas, date)
        let waterSetting = filterSetting(water, date)
        let electroSetting = filterSetting(electro, date)
        
        return [gasSetting, waterSetting, electroSetting]
    }
    
    ///добавляет значение
    func addRate(_ newValue: MeterRate) {
        
        var newMeterRate = newValue
        
        guard let json = try? encoder.encode(newMeterRate) else {
            return
        }
        
        var allRates = getAll()
        
        
            if allRates[newMeterRate.meterType] != nil && allRates[newMeterRate.meterType]!.count > 0 {
                var sorted = allRates[newMeterRate.meterType]!.sorted { (s1, s2) -> Bool in
                    return s2.dateFrom > s1.dateFrom
                }
                
                for rate in sorted {
                    print(rate.dateFrom, rate.dateTo)
                }
                
                let indexBefore = sorted.firstIndex { (rate) -> Bool in
                    newMeterRate.dateFrom > rate.dateFrom && (rate.dateTo ?? maxDate) > newMeterRate.dateFrom
                }!
                
                let indexAfter = sorted.firstIndex { (rate) -> Bool in
                    rate.dateFrom > newMeterRate.dateFrom
                }
                
                if let nextIndex = indexAfter  {
                    newMeterRate.dateTo = sorted[nextIndex].dateFrom
                }
                
                print("d from-to 1: ", sorted[indexBefore].dateFrom, sorted[indexBefore].dateTo)
                sorted[indexBefore].dateTo = newMeterRate.dateFrom
                print("d to 2:", sorted[indexBefore].dateTo)
                sorted.append(newMeterRate)
                allRates[newMeterRate.meterType] = sorted
            }
            else {
//                if !allRates.keys.contains(newMeterRate.meterType) {
//                    allRates.keys
//                }
                
                allRates[newMeterRate.meterType] = [newMeterRate]
            }
        
        
        
        saveMeterRates(dict: allRates)
    }
    
    func deleteRate(type: MeterType, row: Int) {
        var allRates = getAll()
        //let index = Array(allRates.keys)[indexPath.section]

        if allRates[type] == nil || allRates[type]!.count == 0 {
            return
        }
        //let row = indexPath.row
        var rates = allRates[type]!
        
        let deletedRate = rates[row]
        
        if row == 0 { // удаляем первый или единственный
            rates.removeFirst()
        }
        else if rates.count == row+1 { // удаляем последний
            rates.removeLast()
            rates[row-1].dateTo = nil
        }
        else { // удаляем из середины точно не первый и не последний
            
            let nextDateFrom = rates[row+1].dateFrom
            rates[row-1].dateTo = nextDateFrom
            rates.remove(at: row)
        }
        
        allRates[type] = rates
        saveMeterRates(dict: allRates)
    }
    
    // MARK: - private
    
    ///возвращает значение тарифа на дату
    private func filterSetting(_ array:[MeterRate], _ date: Date?) -> MeterRate {

        let searchDate = date ?? today


        return array.first { (setting) -> Bool in
            return searchDate > setting.dateFrom && searchDate < (setting.dateTo ?? maxDate)
        } ?? array.sorted(by: { (rate1, rate2) -> Bool in
            rate1.dateFrom < rate2.dateFrom
        }).first!
    }
    
    
    /// Сохарняет счетчики в UserDefaults
    private func saveMeterRates(dict: [MeterType : [MeterRate]]) {
        guard let json = try? encoder.encode(dict) else {
            return
        }
        userDefaults.set(json, forKey: String(describing: MeterRate.self))
    }
}
