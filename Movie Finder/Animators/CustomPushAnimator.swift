//
//  CustomPushAnimator.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 27.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import Foundation
import UIKit
open class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var duration: TimeInterval = 1.0
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    open  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? MovieListViewController else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) as? MovieDetailViewController else { return }
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        
        let width = fromView.frame.size.width
        let centerFrame = CGRect(x: 0, y: 0, width: width, height: fromView.frame.height)
        let completeLeftFrame = CGRect(x: -width, y: 0, width: width, height: fromView.frame.height)
        let completeRightFrame = CGRect(x: width, y: 0, width: width, height: fromView.frame.height)
        
        let movieCell = fromVC.tableView.selectedCell() as! MovieCell
        let fromImageView = movieCell.posterImageView.snapshotView(afterScreenUpdates: false)
        let fromImageViewFrameInContainer = movieCell.convert(fromImageView!.frame, to: fromView)
        fromImageView?.frame = fromImageViewFrameInContainer
        fromImageView?.cornerRadius = 0
        fromImageView?.layoutIfNeeded()
        
        
        let detailImageView = toVC.posterImageView
        let detailImageViewFrameInContainer = toView.convert(detailImageView!.frame, to: transitionContext.containerView)
        
        containerView.addSubview(toView)
        containerView.addSubview(fromImageView!)
        
        toView.frame = completeRightFrame

        toView.layoutIfNeeded()
        
        toVC.posterImageView.isHidden = true
        toVC.scrollView.alpha = 0
        
        let animations: (() -> Void) = {
            toVC.scrollView.alpha = 0.5
            fromView.frame = completeLeftFrame
            toView.frame = centerFrame
            fromImageView?.frame = detailImageViewFrameInContainer
        }
        
        let completion: ((Bool) -> Void) = { _ in
            fromImageView?.removeFromSuperview()
            toVC.scrollView.alpha = 1.0
            toVC.posterImageView.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.1,
                       options: .allowUserInteraction,
                       animations: animations, completion: completion)

    }
}
