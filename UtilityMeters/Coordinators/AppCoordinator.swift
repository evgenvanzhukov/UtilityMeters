//
//  AppCoordinator.swift
//  UtilityMeters
//
//  Created by Evgen on 02/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator, Sharing {
    
    var parentCoordinator: Coordinator?
    
    
    
    func share(_ calculator: Calculator, _ parentViewConreoller: UIViewController) {
        
        let resultText = "Газ: \(calculator.gasValue) - \(calculator.lastGasValue) = \(calculator.gasValue - calculator.lastGasValue) куб, \(calculator.calculateValue(for: .gas)) руб.\n" +
            "Вода: \(calculator.waterValue) - \(calculator.lastWaterValue) = \(calculator.waterValue - calculator.lastWaterValue) куб, \(calculator.calculateValue(for: .water)) руб.\n" +
            "Электр.: \(calculator.electroValue) - \(calculator.lastElectroValue) = \(calculator.electroValue - calculator.lastElectroValue) кВтч, \(calculator.calculateValue(for: .electro)) руб.\n" +
            "Всего: \(calculator.calculateTotal()) руб"
        
        let activityVC = UIActivityViewController(activityItems: [resultText], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = parentViewConreoller.view
        
        parentViewConreoller.present(activityVC, animated: true, completion: nil)
        
        
        print(resultText)
    }
    
    
    var navigationControoler: UINavigationController
    
    let coreData = CoreDataManager()

    var settings: [MeterRate]? // ViewMidel ?
    
    init(_ navigationController: UINavigationController) {
        self.navigationControoler = navigationController
        
        //configureNavigationController()
    }
    
    
    func eventOccured(with event: EventType) {
        
        switch event {
            
        case .settingsBtnPressed:
            //let settingsController = MeterRatesViewController.createObject()
            //settingsController.coordinator = self
            //navigationControoler.pushViewController(settingsController, animated: false)
            break
            
        case .addMeters:
            let coordinator = MetersCoordinator(navigationControoler)
            coordinator.start()
            
            break
            
        case .deleteReport(let report):
            coreData.deleteReport(report)
            break
        
        case .editMeters(let model):
            MetersCoordinator(navigationControoler).edit(model!)
            break
            
        }
    }
    

    
    

    
    func start() {
        
        if settings != nil {
            showMeters()
        }
        else {
            showMeterRates()
            
        }
    }
    
    func showMeterRates() {
        var ratesCoordinator = MeterRatesCoordinator(navigationControoler, parentCoordinator: self)
        ratesCoordinator.start()
    }
    
    
    func showMeters() {
        configureNavigationController()
        let viewController = MetersViewController.createObject()
        viewController.coordinator = self
        let fetchController = CoreDataManager().fetchResultController
        fetchController.delegate = viewController
        viewController.fetchResultController = fetchController

        navigationControoler.pushViewController(viewController, animated: true)
    }
    
    func closeSettings() {
        navigationControoler.viewControllers.removeAll()
        showMeters()
    }
    
    func configureNavigationController() {
        let bounds = navigationControoler.view.bounds
        let safearea = navigationControoler.view.safeAreaInsets
        print(safearea)
        let bar = UINavigationBar(frame: CGRect(x: bounds.minX, y: 44/2, width: bounds.width, height: 44))
        
        let naviGationItem = UINavigationItem(title: "Показания счетчиков")
        let MeterRatesBtn = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(meterRatesBtn))
        
        let addMeterBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
        
        naviGationItem.leftBarButtonItem = MeterRatesBtn
        naviGationItem.rightBarButtonItem = addMeterBtn
        
        bar.setItems([naviGationItem], animated: false)
        self.navigationControoler.view.addSubview(bar)
    }
    
    @objc
    func meterRatesBtn() {
        showMeterRates()
    }
    
    @objc
    func addBtnPressed() {
        eventOccured(with: .addMeters(model: nil))
    }

}
