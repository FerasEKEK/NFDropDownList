//
//  NFDropDownListTextFieldPresentingAnimator.swift
//  NFDropDownList
//
//  Created by Firas Al Khatib Al Khalidi on 7/27/16.
//  Copyright © 2016 Firas Al Khatib Al Khalidi. All rights reserved.
//

import UIKit
class NFDropDownListTextFieldPresentingAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let tableView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        tableView.alpha = 0
        let tableViewFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!)
        tableView.frame = tableViewFrame
        tableView.frame.size.height = 1
        let containerView = transitionContext.containerView
        containerView.addSubview(tableView)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { 
            tableView.frame = tableViewFrame
            tableView.alpha = 1
            }) { (Bool) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}
