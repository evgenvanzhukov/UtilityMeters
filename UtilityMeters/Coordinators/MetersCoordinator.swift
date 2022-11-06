//
//  MetersCoordinator.swift
//  UtilityMeters
//
//  Created by Evgen on 03/11/2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import UIKit

class MetersCoordinator : Coordinator {
    
    let coreData = CoreDataManager()
    
    var navigationControoler: UINavigationController
    
    init(_ navContr: UINavigationController) {
        self.navigationControoler = navContr
    }
    
    
    
    func eventOccured(with event: EventType) {
        switch event {
        case .addMeters(let meters):
            if let model = meters {
                coreData.addReport(model)
                navigationControoler.popViewController(animated: true)
            }
            
            break
        default:
            return
        }
    }
    
    

    
    

    
    func start() {
        
    }
    
    
    func coordinate(_ viewController: UIViewController) {
        
    }
    
}
