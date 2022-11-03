//
//  SettingsManager.swift
//  UtilityMeters
//
//  Created by Evgen on 02/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import Foundation

/// Сервис работы с настройками
class SettingsManager {
    let userDefaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    ///Возвращает настройки счетчиков
    func getSettings() -> [Setting]? {
        guard let json = userDefaults.object(forKey: String(describing: Setting.self)) as? Data?, let data = json else {
            return nil
        }
        return try? decoder.decode([Setting].self, from: data)
    }
    
    /// Сохарняет настройки счетчиков
    func setSettings(value: [Setting]) {
        guard let json = try? encoder.encode(value) else {
            return
        }
        userDefaults.set(json, forKey: String(describing: Setting.self))
    }
}
