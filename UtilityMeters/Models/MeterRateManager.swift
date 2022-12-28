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
    func addRate(_ value: MeterRate) {
        
        guard let json = try? encoder.encode(value) else {
            return
        }
        
        var settings = getAll()
        
        if settings[value.meterType] != nil && settings[value.meterType]!.count > 0 {
            var sorted = settings[value.meterType]!.sorted { (s1, s2) -> Bool in
                return s2.dateFrom > s1.dateFrom
            }
            
            let index = sorted.firstIndex { (s) -> Bool in
                value.dateFrom > s.dateFrom && (s.dateTo ?? maxDate) > value.dateFrom
            }!
            
            sorted[index].dateTo = value.dateFrom
            sorted.append(value)
            settings[value.meterType] = sorted
        }
        else {
            
            settings[value.meterType]?.append(value)
        }
        setSettings(dict: settings)
    }
    
    // MARK: - private
    
    ///возвращает значение тарифа на дату
    private func filterSetting(_ array:[MeterRate], _ date: Date?) -> MeterRate {

        let searchDate = date ?? today


        return array.first { (setting) -> Bool in
            return searchDate > setting.dateFrom && searchDate < (setting.dateTo ?? maxDate)
        }!
    }
    
    
    /// Сохарняет счетчики в UserDefaults
    private func setSettings(dict: [MeterType : [MeterRate]]) {
        guard let json = try? encoder.encode(dict) else {
            return
        }
        userDefaults.set(json, forKey: String(describing: MeterRate.self))
    }
}
