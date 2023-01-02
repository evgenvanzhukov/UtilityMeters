//
//  MeterRateCoordinator.swift
//  UtilityMeters
//
//  Created by Evgen on 28.12.2022.
//  Copyright © 2022 Evgen. All rights reserved.
//

import Foundation
import UIKit

class MeterRatesCoordinator : Coordinator {
    
    var parentCoordinator: Coordinator?
    var meterRateManager = MeterRateManager()
    
    var navigationControoler: UINavigationController
    
    init(_ navigationController: UINavigationController, parentCoordinator : Coordinator) {
        self.navigationControoler = navigationController
        self.parentCoordinator = parentCoordinator
        
    }
    
    func start() {
        let viewController = MeterRatesViewController.createObject()
        viewController.coordinator = self
        configureNavigationController()
        
        navigationControoler.pushViewController(viewController, animated: true)

    }
    
    func eventOccured(with event: EventType) {
        
    }
    
    func configureNavigationController() {
        
        let bounds = navigationControoler.view.bounds
        
        //let safearea = navigationControoler.view.safeAreaInsets
            
        let navigationBar = UINavigationBar(frame: CGRect(x: bounds.minX, y: 44/2, width: bounds.width, height: 44))
            
        let navigationItem = UINavigationItem(title: "Тарифы")
        
        let leftBtn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(backBtnPressed))
            
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
            
        navigationItem.leftBarButtonItem = leftBtn
        navigationItem.rightBarButtonItem = addBtn
        
        navigationBar.setItems([navigationItem], animated: false)
        self.navigationControoler.view.addSubview(navigationBar)
        
    }
    
    func addMeterRate(with model: MeterRate?) {
        if let rate = model {
            print("before pop: ", navigationControoler.viewControllers.count)
            navigationControoler.popViewController(animated: true)
            print("after pop: ", navigationControoler.viewControllers.count)
            meterRateManager.addRate(rate)
            (navigationControoler.viewControllers.last as? MeterRatesViewController)?.refresh()
        }
        else {
            print("nil model rate")
        }
    }
    
    @objc
    func backBtnPressed() {
        print("backBtnPressed")
        var controllers = navigationControoler.viewControllers
        controllers.removeLast()
        guard let appCoordinator = parentCoordinator as? AppCoordinator else {
            print("where is the parent??")
            return
        }
        appCoordinator.closeMeterRates()
        //appCoordinator.showMeters()
//        print("parent: ",parentCoordinator )
//        navigationControoler.viewControllers = controllers
    }
    
    @objc
    func addBtnPressed() {
        let addRateController = MeterRateDetailViewController.createObject()
        addRateController.coordinator = self
        navigationControoler.pushViewController(addRateController, animated: true)
    }
}
