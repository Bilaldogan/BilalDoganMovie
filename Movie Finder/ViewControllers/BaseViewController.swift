//
//  BaseViewController.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 26.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    weak var hudView: HUDView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showHUD() {
        let hudView = HUDView(frame: self.view.frame)
        self.view.addSubview(hudView)
        self.hudView = hudView
        hudView.startAnimation()
    }
    
    func hideHUD() {
        self.hudView?.stopAnimation()
        self.hudView?.removeFromSuperview()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
