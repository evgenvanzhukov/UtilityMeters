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
        
        addMeters(to: report, with: details)
        
        report.date = details.date
        //print("details.date \(details.date!)")
        report.calculating = details.calculating
        
        
        saveContext()
    }
    
    func addMeters(to report: Report, with details: DetailViewModel) {
        
        guard let date = details.date else {
            return
        }
        
        let gasMeter = Meter(context: CoreDataManager.persistentContainer.viewContext)

        report.addToMeters(gasMeter.setValues(date: date, type: .gas, value: details.gasValue))
        
        let waterMeter = Meter(context: CoreDataManager.persistentContainer.viewContext)

        report.addToMeters(waterMeter.setValues(date: date, type: .water, value: details.waterValue))
        
        let electroMeter = Meter(context: CoreDataManager.persistentContainer.viewContext)

        report.addToMeters(electroMeter.setValues(date: date, type: .electro, value: details.electroValue))
    }
    
    func deleteReport(_ entity: Report) {
        CoreDataManager.persistentContainer.viewContext.delete(entity)
        saveContext()
    }
    
    func getInitial() -> Report? {
        
        let request = NSFetchRequest<Report>(entityName: String(describing: Report.self))
        request.predicate = NSPredicate(format: "ANY meters.isInitial", argumentArray: [true])
        return try? CoreDataManager.persistentContainer.viewContext.fetch(request)[0]
    }
    
    func updateReport(_ details: DetailViewModel) {
        let request = NSFetchRequest<Report>(entityName: String(describing: Report.self))
        
        request.predicate = NSPredicate(format: "date = %@", argumentArray: [details.date!])
        
        
        do {
            let report = try CoreDataManager.persistentContainer.viewContext.fetch(request)[0]
            
            report.meters?.allObjects.forEach {meter in
                try? report.removeFromMeters(meter as! Meter)
            }
            
            addMeters(to: report, with: details)
            saveContext()            
        } catch {
            return
        }
    }
}
