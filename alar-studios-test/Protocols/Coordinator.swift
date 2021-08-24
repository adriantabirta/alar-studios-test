//
//  Coordinator.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 24.08.2021.
//

import UIKit

protocol Coordinator {
    
    /// Parrent cooridnator. Can be accested by casting it to desired Coordinator (usualy parrent).
    var parrentCoordinator: Coordinator? { get set }
    
    /// NavigationController for current coordinators. Can be passed to childrens.
    var navigationController: UINavigationController { get set }
    
    /// Child coordinators. Always keep reference to child coordinator to be able to call them from VCs
    var childCoordinators: [Coordinator] { get set }
    
    /// Main metthod to start a navigator work.
    func start()
}
