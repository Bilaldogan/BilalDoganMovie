//
//  MainCoordinator.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 25.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator:NSObject, Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let listVC = MovieListViewController.instantiate()
        listVC.viewModel = MovieListViewModel()
        listVC.coordinator = self
        self.navigationController.pushViewController(listVC, animated: false)
        self.navigationController.delegate = self
        
        //TODO: Ask notificaiton permission after onbarding
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.registerForRemoteNotification()
        }
    }
    
    func openDetail(imdbID: String) {
        let detailVC = MovieDetailViewController.instantiate()
        detailVC.viewModel = MovieDetailViewModel(imdbID: imdbID)
        detailVC.coordinator = self
        self.navigationController.setNavigationBarHidden(true, animated: true)
        self.navigationController.pushViewController(detailVC, animated: true)
    }
    
    func backTapped() {
        self.navigationController.setNavigationBarHidden(false, animated: true)
        self.navigationController.popViewController(animated: true)
    }
}

extension MainCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return CustomPushAnimator()
        case .pop:
            return CustomPopAnimator()
        case .none:
            return nil
        }
    }
    
}
