//
//  NoConnectionVC.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 26.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import Foundation

class NoConnectionVC: UIViewController {
    
    weak var coordinator: AppCoordinator?
    
    private weak var imageView: UIImageView!
    private weak var descriptionLabel: UILabel!
    private weak var tryAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addImageView()
        addDescription()
        addButton()
    }
    
    private func addImageView() {
        let noConnectionImage = UIImage(named: "no-connection")
        let imageView = UIImageView(image: noConnectionImage)
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true

        self.imageView = imageView
    }
    
    private func addDescription() {
        let label = UILabel(frame: .zero)
        label.text = "Please Check your internet connection."
        
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.descriptionLabel = label
    }
    
    private func addButton() {
        let button = UIButton(frame: .zero)
        button.setTitle("Try Again", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.cornerRadius = 5
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(tryAgain(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    @objc func tryAgain(_ sender: UIButton) {
        coordinator?.checkNetwork()
    }
}
