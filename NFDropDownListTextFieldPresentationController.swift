//
//  NFDropDownListTextFieldPresentationController.swift
//  NFDropDownList
//
//  Created by Firas Al Khatib Al Khalidi on 7/27/16.
//  Copyright © 2016 Firas Al Khatib Al Khalidi. All rights reserved.
//

import UIKit

class NFDropDownListTextFieldPresentationController: UIPresentationController {
    var dimmingView = UIView()
    var dropDownTextField: NFDropDownListTextField!
    var cornerRadius: CGFloat = 5
    override func presentationTransitionWillBegin() {
        dimmingView.backgroundColor = UIColor.clear
        let touchHandler = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(_:)))
        dimmingView.addGestureRecognizer(touchHandler)
        self.containerView!.addSubview(dimmingView)
    }
    func tapHandler(_ gesture:UIGestureRecognizer) {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        self.dimmingView.removeFromSuperview()
    }
    override var frameOfPresentedViewInContainerView : CGRect {

        let translatedRectOfTextField = dropDownTextField.superview?.convert(dropDownTextField.frame, to: containerView)
        let screenBounds = UIScreen.main.bounds
        let numberOfItems = dropDownTextField.tableViewController.tableView.numberOfRows(inSection: 0)
        let height: CGFloat = CGFloat(44 * numberOfItems)
        var frame = CGRect(x: (translatedRectOfTextField?.origin.x)!, y: (translatedRectOfTextField?.origin.y)! + dropDownTextField.frame.height, width: dropDownTextField.frame.width, height: height)
        if !screenBounds.contains(frame){
            frame.size.height = screenBounds.height - frame.origin.y
        }
        return frame
    }
    
    override func containerViewWillLayoutSubviews() {
        self.presentedViewController.view.layer.cornerRadius = self.cornerRadius
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.presentedViewController.view.frame = self.frameOfPresentedViewInContainerView
            }, completion: nil)
        self.dimmingView.frame = self.containerView!.frame
    }
}
