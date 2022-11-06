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
        navigationController.setNavigationBarHidden(true, animated: false)
        
        //Todo: NavigationButtons remove from storuboard and set in code
    }
    
    
    func eventOccured(with event: EventType) {
        
        switch event {
            
        case .settingsBtnPressed:
            let settingsController = SettingsViewController.createObject()
            settingsController.coordinator = self
            navigationControoler.pushViewController(settingsController, animated: false)
            break
            
        case .addMeters:
            let detailsController = DetailViewController.createObject()
            detailsController.coordinator = MetersCoordinator(navigationControoler)
            navigationControoler.pushViewController(detailsController, animated: true)
            break
            
        case .deleteReport(let report):
            coreData.deleteReport(report)
            break
            
            
        default:
            return
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
        navigationControoler.viewControllers.popLast()
        showMetersController()
    }
}
