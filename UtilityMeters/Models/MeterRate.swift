//
//  Settings.swift
//  UtilityMeters
//
//  Created by Evgen on 02/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import Foundation

///Тариф счетчика
struct MeterRate : Codable {
    
    ///Название счетчика
    var meterName : String
    
    ///Тип счетчика
    var meterType : MeterType
    
    /// Единицы измерения
    var meterUnits : String
    
    ///Тариф
    var rate: Decimal
    
    ///Дата начала действия тарифа
    var dateFrom : Date
    
    ///Дата окончания действия тарифа
    var dateTo: Date?
}
