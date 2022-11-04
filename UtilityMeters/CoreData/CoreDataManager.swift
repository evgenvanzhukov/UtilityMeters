//
//  CoreDataManager.swift
//  UtilityMeters
//
//  Created by Evgen on 03/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    // MARK: - Core Data stack
    var fetchResultController: NSFetchedResultsController<Report>
    
    init() {
        fetchResultController = NSFetchedResultsController<Report>()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "UtilityMeters")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addReport(_ details: DetailViewModel) {
        let report = Report(context: persistentContainer.viewContext)
        
        let gasMeter = Meter(context: persistentContainer.viewContext)
        gasMeter.type = Int16(MeterType.gas.rawValue)
        gasMeter.date = details.date
        gasMeter.value = details.gasValue as NSDecimalNumber?
        report.addToMeters(gasMeter)
        
        let waterMeter = Meter(context: persistentContainer.viewContext)
        waterMeter.type = Int16(MeterType.water.rawValue)
        waterMeter.date = details.date
        waterMeter.value = details.waterValue as NSDecimalNumber?
        report.addToMeters(waterMeter)
        
        let electroMeter = Meter(context: persistentContainer.viewContext)
        electroMeter.type = Int16(MeterType.water.rawValue)
        electroMeter.date = details.date
        electroMeter.value = details.electroValue as NSDecimalNumber?
        report.addToMeters(electroMeter)
        
        report.date = details.date
        report.calculating = details.calculating
        
        
        saveContext()
    }
    
}
