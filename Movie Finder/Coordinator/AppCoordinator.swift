//
//  AppCoordinator.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 25.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class AppCoordinator:NSObject, Coordinator {
    
    @objc weak var window: UIWindow!
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    var reachabilityManager = NetworkReachabilityManager()
    
    @objc init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    @objc func start() {
        startListenNetworkStatus()
        
        let onBoardCoordinator = OnboardCoordinator(navigationController: navigationController)
        onBoardCoordinator.parentCoordinator = self
        self.childCoordinators.append(onBoardCoordinator)
        onBoardCoordinator.start()
    }
    
    @objc func didFinishOnboarding() {
        guard NetworkReachabilityManager()?.isReachable ?? false else {
            showNetworkErrorOnTop()
            return
        }
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
    
    func checkNetwork() {
        if NetworkReachabilityManager()?.isReachable ?? false {
           dismisNetworkError()
        }
        startListenNetworkStatus()
    }
    
    private func startListenNetworkStatus() {
        //TODO: NetworkReachabilityManager dot working correclty its. if use one instance its stuck on notreachable state. Consider use reachability
        reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.listener =  { [unowned self] status in
            switch status {
            case .notReachable:
                self.showNetworkErrorOnTop()
            default:
                self.dismisNetworkError()
            }
        }
        reachabilityManager?.startListening()
    }
    
    private func networkListener(status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        switch status {
        case .notReachable:
            showNetworkErrorOnTop()
        default:
            break
        }
    }
    
    private func showNetworkErrorOnTop() {
        let noConnectionVC = NoConnectionVC()
        noConnectionVC.coordinator = self
        self.navigationController.present(noConnectionVC, animated: true, completion: nil)
    }
    
    private func dismisNetworkError() {
        if let connectionVC = self.navigationController.presentedViewController as? NoConnectionVC {
            connectionVC.dismiss(animated: true, completion:nil)
        }
    }
}
