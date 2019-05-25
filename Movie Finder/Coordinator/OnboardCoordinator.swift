//
//  OnboardCoordinator.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 25.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import Foundation

@objc class OnboardCoordinator:NSObject, Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    weak var parentCoordinator: AppCoordinator?
    
    @objc init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    @objc func start() {
        self.navigationController.isNavigationBarHidden = true
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    @objc func splashEnded() {
        parentCoordinator?.didFinishOnboarding()
        parentCoordinator?.childDidFinish(self)
    }
}
