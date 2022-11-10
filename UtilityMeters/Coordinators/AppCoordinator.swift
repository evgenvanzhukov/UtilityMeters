//
//  AppCoordinator.swift
//  UtilityMeters
//
//  Created by Evgen on 02/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var navigationControoler: UINavigationController
    
    let coreData = CoreDataManager()

    var settings: [Setting]? // ViewMidel ?
    
    init(_ navigationController: UINavigationController) {
        self.navigationControoler = navigationController
        
        configureNavigationController()
    }
    
    
    func eventOccured(with event: EventType) {
        
        switch event {
            
        case .settingsBtnPressed:
            let settingsController = SettingsViewController.createObject()
            settingsController.coordinator = self
            navigationControoler.pushViewController(settingsController, animated: false)
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
            showMetersController()
        }
        else {
            showSettingsController()
        }
    }
    
    func showSettingsController() {
        let viewController = SettingsViewController.createObject()
        viewController.coordinator = self
        navigationControoler.pushViewController(viewController, animated: true)
    }
    
    
    func showMetersController() {
        let viewController = MetersViewController.createObject()
        viewController.coordinator = self
        let fetchController = CoreDataManager().fetchResultController
        fetchController.delegate = viewController
        viewController.fetchResultController = fetchController

        navigationControoler.pushViewController(viewController, animated: true)
    }
    
    func closeSettings() {
        navigationControoler.viewControllers.removeAll()
        showMetersController()
    }
    
    func configureNavigationController() {
        let bounds = navigationControoler.view.bounds
        let safearea = navigationControoler.view.safeAreaInsets
        print(safearea)
        let bar = UINavigationBar(frame: CGRect(x: bounds.minX, y: 44/2, width: bounds.width, height: 44))
        
        let naviGationItem = UINavigationItem(title: "Показания счетчиков")
        let settingsBtn = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(settingsBtnPressed))
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
        
        naviGationItem.leftBarButtonItem = settingsBtn
        naviGationItem.rightBarButtonItem = addBtn
        
        bar.setItems([naviGationItem], animated: false)
        self.navigationControoler.view.addSubview(bar)
    }
    
    @objc
    func settingsBtnPressed() {
        eventOccured(with: .settingsBtnPressed)
    }
    
    @objc
    func addBtnPressed() {
        eventOccured(with: .addMeters(model: nil))
    }

}
