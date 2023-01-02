//
//  MetersCoordinator.swift
//  UtilityMeters
//
//  Created by Evgen on 03/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import UIKit

class MetersCoordinator : Coordinator {
    
    var parentCoordinator: Coordinator?
    
    let coreData = CoreDataManager()
    
    var navigationControoler: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationControoler = navigationController
    }
    
    
    
    func eventOccured(with event: EventType) {
        switch event {
        case .addMeters(let meters):
            if let model = meters {
                coreData.addReport(model)
                navigationControoler.viewControllers.popLast()
            }
            break
            
        case .editMeters(let meters):
            if let model = meters {
                coreData.updateReport(model)
                navigationControoler.viewControllers.popLast()
            }
            
            break
        default:
            return
        }
    }
    
    
    func start() {
        let detailsController = DetailViewController.createObject()
        detailsController.coordinator = self
        navigationControoler.pushViewController(detailsController, animated: true)
    }
    
    func edit(_ model: DetailViewModel) {
        let detailsController = DetailViewController.createObject()
        detailsController.viewModel = model
        detailsController.isNewReport = false
        detailsController.coordinator = self
        navigationControoler.pushViewController(detailsController, animated: true)
    }
    
}
