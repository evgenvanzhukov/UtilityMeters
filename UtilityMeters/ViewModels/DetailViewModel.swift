//
//  DetailViewModel.swift
//  UtilityMeters
//
//  Created by Evgen on 04/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import Foundation

struct DetailViewModel {
    var gasValue: Decimal?
    var waterValue: Decimal?
    var electroValue: Decimal?
    
    var date: Date?
    var calculating: String?
}
