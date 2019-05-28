//
//  CustomPopAnimator.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 28.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import Foundation
import UIKit

open class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var duration: TimeInterval = 0.5
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    open  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? MovieDetailViewController else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) as? MovieListViewController else { return }
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        
        let width = fromView.frame.size.width
        let centerFrame = CGRect(x: 0, y: 0, width: width, height: fromView.frame.height)
        let completeLeftFrame = CGRect(x: -width, y: 0, width: width, height: fromView.frame.height)
        let completeRightFrame = CGRect(x: width, y: 0, width: width, height: fromView.frame.height)

        let detailImageView = fromVC.posterImageView.snapshotView(afterScreenUpdates: false)
        var detailImageViewFrameInContainer = toView.convert(detailImageView!.frame, to: transitionContext.containerView)
        detailImageViewFrameInContainer = detailImageViewFrameInContainer.offsetBy(dx: width, dy: 0)
        detailImageView?.frame = detailImageViewFrameInContainer
        detailImageView?.layoutIfNeeded()


        let movieCell = toVC.tableView.selectedCell() as! MovieCell
        let selectedCellImageView = movieCell.posterImageView
        let selectedCellImageViewFrameInContainer = selectedCellImageView?.superview?.convert(selectedCellImageView!.frame, to: toVC.view)

        
        containerView.insertSubview(toView, belowSubview: fromView)
        containerView.addSubview(detailImageView!)
        toView.frame = completeLeftFrame
        toView.layoutIfNeeded()
 
        let animations: (() -> Void) = { 
            detailImageView?.frame = selectedCellImageViewFrameInContainer!
            fromView.frame = completeRightFrame
            toView.frame = centerFrame
        }
        
        let completion: ((Bool) -> Void) = { _ in
            detailImageView?.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
       UIView.animate(withDuration: duration, animations: animations, completion: completion)
        
    }
}
