//
//  Settings.swift
//  UtilityMeters
//
//  Created by Evgen on 02/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import Foundation

///Структура описывающая счетчик
struct Setting : Codable {
    
    ///Название
    var meterName : String
    
    ///Тип
    var meterType : MeterType
    
    /// Единицы измерения
    var meterUnits : String
    
    ///Тариф
    var rate: Decimal
    
    var dateFrom : Date
    
    var dateTo: Date?
}
