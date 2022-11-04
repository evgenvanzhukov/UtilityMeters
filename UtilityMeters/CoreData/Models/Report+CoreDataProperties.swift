//
//  Report+CoreDataProperties.swift
//  UtilityMeters
//
//  Created by Evgen on 04/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//
//

import Foundation
import CoreData


extension Report {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Report> {
        return NSFetchRequest<Report>(entityName: "Report")
    }

    @NSManaged public var calculating: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var meters: NSSet?

}

// MARK: Generated accessors for meters
extension Report {

    @objc(addMetersObject:)
    @NSManaged public func addToMeters(_ value: Meter)

    @objc(removeMetersObject:)
    @NSManaged public func removeFromMeters(_ value: Meter)

    @objc(addMeters:)
    @NSManaged public func addToMeters(_ values: NSSet)

    @objc(removeMeters:)
    @NSManaged public func removeFromMeters(_ values: NSSet)

}
