//
//  SettingsManager.swift
//  UtilityMeters
//
//  Created by Evgen on 02/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import Foundation


protocol SettingProtocol {
    
    ///Возвращает значение одного тарифа на определенную дату
    func getSetting(for type: MeterType, on date: Date?) -> Setting?
    
    ///возвращает актуальные тарифы на определенную дату
    func getSettings(_ date: Date?) -> [Setting]?
    
    //////добавляет новое значение тарифа
    func addSetting(_ value: Setting)
    
    ///Возвращает все значения тарифов
    func getAll() -> [MeterType : [Setting]]
}

/// Сервис работы с настройками
class SettingsManager : SettingProtocol {
    
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
    
    func getAll() -> [MeterType : [Setting]] {
        guard let json = userDefaults.object(forKey: String(describing: Setting.self)) as? Data?, let data = json else {
            return [:]
        }
        if let dict = try? decoder.decode((Dictionary<MeterType, [Setting]>).self, from: data) {
            return dict
        }
        return [:]
    }
    
    func getSetting(for type: MeterType, on date: Date?) -> Setting? {
        let all = getAll()
        guard let settings = all[type], settings.count > 0 else {
            return nil
        }
        let searchDate = date ?? today
        return settings.first { (s) -> Bool in
            s.dateFrom < searchDate && (s.dateTo ?? maxDate) > searchDate
        }
    }
    
    func getSettings(_ date: Date?) -> [Setting]? {
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
    
    /// Сохарняет счетчики в USerDefaults
    private func setSettings(dict: [MeterType : [Setting]]) {
        guard let json = try? encoder.encode(dict) else {
            return
        }
        userDefaults.set(json, forKey: String(describing: Setting.self))
    }
    
    
    
    
    
    ///добавляет значение
    func addSetting(_ value: Setting) {
        
        guard let json = try? encoder.encode(value) else {
            return
        }
        
        var settings = getAll()
        
        if settings[value.meterType] != nil && settings[value.meterType]!.count > 0 {
            var sorted = settings[value.meterType]!.sorted { (s1, s2) -> Bool in
                return s2.dateFrom > s1.dateFrom
            }
            
            var index = sorted.firstIndex { (s) -> Bool in
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
    
    
    ///возвращает значение тарифа на дату
    private func filterSetting(_ array:[Setting], _ date: Date?) -> Setting {

        let searchDate = date ?? today


        return array.first { (setting) -> Bool in
            return searchDate > setting.dateFrom && searchDate < (setting.dateTo ?? maxDate)
        }!
    }
}
