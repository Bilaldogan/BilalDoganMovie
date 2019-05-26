//
//  HUDView.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 26.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import UIKit
import Lottie
class HUDView: UIView {
    private weak var animationView: AnimationView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBlurEffect()
        addLottieView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startAnimation() {
        animationView.play()
    }
    
    func stopAnimation() {
        animationView.stop()
    }
    
    private func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    private func addLottieView() {
        let lottieView = AnimationView(name: "film-roll")
        lottieView.animationSpeed = 1.5
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .loop
        
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lottieView)
        lottieView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        lottieView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        lottieView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        lottieView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        animationView = lottieView
    }
}
