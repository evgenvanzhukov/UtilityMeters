//
//  MeterType.swift
//  UtilityMeters
//
//  Created by Evgen on 02/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import Foundation

///Тип счетчика
enum MeterType : Int, Codable, Hashable {
    case gas = 1
    case water = 2
    case electro = 3
}
