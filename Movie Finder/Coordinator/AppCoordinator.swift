//
//  AppCoordinator.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 25.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator:NSObject, Coordinator {
    @objc weak var window: UIWindow!
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    @objc init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    @objc func start() {
        let onBoardCoordinator = OnboardCoordinator(navigationController: navigationController)
        onBoardCoordinator.parentCoordinator = self
        self.childCoordinators.append(onBoardCoordinator)
        onBoardCoordinator.start()
    }
    
    @objc func didFinishOnboarding() {
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        self.childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
        
        guard let window = UIApplication.shared.delegate?.window else { return }
        window?.rootViewController = self.navigationController
        window?.makeKeyAndVisible()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
