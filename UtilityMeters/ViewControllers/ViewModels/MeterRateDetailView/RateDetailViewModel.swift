//
//  RateDetailViewModel.swift
//  UtilityMeters
//
//  Created by Evgen on 29.12.2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import Foundation

struct RateDetailViewModel {
    var meterName: MeterNames
    var date: Date?
    var price: Decimal?
    var unit: String
}
