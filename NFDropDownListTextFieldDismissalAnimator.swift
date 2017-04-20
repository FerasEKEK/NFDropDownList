//
//  NFDropDownListTextFieldDismissalAnimator.swift
//  NFDropDownList
//
//  Created by Firas Al Khatib Al Khalidi on 7/27/16.
//  Copyright © 2016 Firas Al Khatib Al Khalidi. All rights reserved.
//

import UIKit
class NFDropDownListTextFieldDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let tableView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        var tableViewFrame = transitionContext.initialFrame(for: transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!)
        tableViewFrame.size.height = 1
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            tableView.frame = tableViewFrame
            tableView.alpha = 0
        }) { (Bool) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
