//
//  Meter+CoreDataProperties.swift
//  UtilityMeters
//
//  Created by Evgen on 04/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//
//

import Foundation
import CoreData


extension Meter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meter> {
        return NSFetchRequest<Meter>(entityName: "Meter")
    }

    @NSManaged public var date: Date?
    @NSManaged public var isInitial: Bool
    @NSManaged public var type: Int16
    @NSManaged public var value: NSDecimalNumber?

}
