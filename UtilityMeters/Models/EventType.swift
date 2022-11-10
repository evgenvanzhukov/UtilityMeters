//
//  EventType.swift
//  UtilityMeters
//
//  Created by Evgen on 03/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import Foundation

enum EventType {
    case settingsBtnPressed
    case addMeters(model: DetailViewModel?)
    case editMeters(model: DetailViewModel?)
    case deleteReport(model: Report)
}
