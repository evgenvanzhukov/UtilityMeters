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
    lazy var fetchResultController: NSFetchedResultsController<Report> = {
        
        var fetchRequest = NSFetchRequest<Report>(entityName: "Report")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var controller = NSFetchedResultsController<Report>(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
         
        try? controller.performFetch()

        
        return controller
    }()
    
    private static var persistentContainer: NSPersistentContainer = {

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
        let context = CoreDataManager.persistentContainer.viewContext
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
        let report = Report(context: CoreDataManager.persistentContainer.viewContext)
        
        let gasMeter = Meter(context: CoreDataManager.persistentContainer.viewContext)
        gasMeter.date = details.date
        gasMeter.type = Int16(MeterType.gas.rawValue)
        gasMeter.date = details.date
        gasMeter.value = details.gasValue as NSDecimalNumber?
        report.addToMeters(gasMeter)
        
        let waterMeter = Meter(context: CoreDataManager.persistentContainer.viewContext)
        waterMeter.date = details.date
        waterMeter.type = Int16(MeterType.water.rawValue)
        waterMeter.date = details.date
        waterMeter.value = details.waterValue as NSDecimalNumber?
        report.addToMeters(waterMeter)
        
        let electroMeter = Meter(context: CoreDataManager.persistentContainer.viewContext)
        electroMeter.date = details.date
        electroMeter.type = Int16(MeterType.water.rawValue)
        electroMeter.date = details.date
        electroMeter.value = details.electroValue as NSDecimalNumber?
        report.addToMeters(electroMeter)
        
        report.date = details.date
        //print("details.date \(details.date!)")
        report.calculating = details.calculating
        
        
        saveContext()
    }
    
}
