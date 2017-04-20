//
//  NFDropDownListTextField.swift
//  NFDropDownList
//
//  Created by Firas Al Khatib Al Khalidi on 7/27/16.
//  Copyright © 2016 Firas Al Khatib Al Khalidi. All rights reserved.
//

import UIKit
@objc protocol NFDropDownListTextFieldDataSource {
    func dropDownListNumberOfItemsInList() -> Int
    func dropDownListStringForItemInList(itemIndex index: Int) -> String
    func dropDownListPresentingViewController() -> UIViewController
    @objc optional func dropDownListTextColorForItem(atIndex index: Int) -> UIColor
    @objc optional func dropDownListBackgroundColorOfItem(atIndex index: Int) -> UIColor
    @objc optional func dropDownListCornerRadiusFromPresentedItems() -> CGFloat
}
@objc protocol NFDropDownListTextFieldDelegate {
    @objc optional func dropDownListDidSelectItemAtIndexWithTitle(itemIndex index: Int, itemTitle title: String)
}
class NFDropDownListTextField: UITextField {

    weak var dropDownDelegate: NFDropDownListTextFieldDelegate?
    weak var dataSource: NFDropDownListTextFieldDataSource?{
        didSet{
            tableViewController.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuse")
            tableViewController.tableView.dataSource = self
            tableViewController.tableView.delegate = self
            tableViewController.tableView.reloadData()
            tableViewController.transitioningDelegate = self
            tableViewController.tableView.bounces = false
            tableViewController.modalPresentationStyle = .custom
            tableViewController.tableView.backgroundColor = UIColor.clear
            tableViewController.tableView.tableFooterView = UIView(frame: CGRect.zero)
            tableViewController.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    fileprivate(set) var tableViewController: NFTableViewController = NFTableViewController(style: UITableViewStyle.plain)
    override func becomeFirstResponder() -> Bool {
        dataSource?.dropDownListPresentingViewController().present(tableViewController, animated: true, completion: nil)
        return false
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
extension NFDropDownListTextField: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource != nil{
            return dataSource!.dropDownListNumberOfItemsInList()
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuse", for: indexPath)
        cell.textLabel?.text = dataSource?.dropDownListStringForItemInList(itemIndex: (indexPath as NSIndexPath).row)
        if let textColor = dataSource!.dropDownListTextColorForItem?(atIndex: (indexPath as NSIndexPath).row){
            cell.textLabel?.textColor = textColor
        }
        if let backgroundColor = dataSource!.dropDownListBackgroundColorOfItem?(atIndex: (indexPath as NSIndexPath).row){
            cell.contentView.backgroundColor = backgroundColor
            cell.backgroundColor = backgroundColor
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard dataSource != nil else{
            dropDownDelegate?.dropDownListDidSelectItemAtIndexWithTitle?(itemIndex: (indexPath as NSIndexPath).row, itemTitle: "")
            tableViewController.dismiss(animated: true, completion: nil)
            return
        }
        dropDownDelegate?.dropDownListDidSelectItemAtIndexWithTitle?(itemIndex: (indexPath as NSIndexPath).row, itemTitle: dataSource!.dropDownListStringForItemInList(itemIndex: (indexPath as NSIndexPath).row))
        tableViewController.dismiss(animated: true, completion: nil)
    }
}
extension NFDropDownListTextField: UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController: NFDropDownListTextFieldPresentationController = NFDropDownListTextFieldPresentationController.init(presentedViewController: presented, presenting: presenting)
        if dataSource != nil{
            let cornerRadiusForTableView = dataSource!.dropDownListCornerRadiusFromPresentedItems?()
            if cornerRadiusForTableView != nil{
                presentationController.cornerRadius = cornerRadiusForTableView!
            }
        }
        presentationController.dropDownTextField = self
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentingAnimator = NFDropDownListTextFieldPresentingAnimator()
        return presentingAnimator
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissalAnimator = NFDropDownListTextFieldDismissalAnimator()
        return dismissalAnimator
    }
}
