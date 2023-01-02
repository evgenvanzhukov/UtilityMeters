//
//  MeterNames.swift
//  UtilityMeters
//
//  Created by Evgen on 29.12.2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import Foundation

enum MeterNames: String, CaseIterable {
    case gas = "Газ"
    case water = "Вода"
    case electro = "Электричество"
    
    func getRateType() -> MeterType {
        switch self {
            case .gas: return .gas
            case .water: return .water
            case .electro: return .electro
        }
    }
}
