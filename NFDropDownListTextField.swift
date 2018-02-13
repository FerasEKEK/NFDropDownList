//
//  NFDropDownListTextField.swift
//  NFDropDownList
//
//  Created by Firas Al Khatib Al Khalidi on 7/27/16.
//  Copyright © 2016 Firas Al Khatib Al Khalidi. All rights reserved.
//

import UIKit
@objc protocol NFDropDownListTextFieldDataSource {
    func dropDownList(numberOfItemsInList list: NFDropDownListTextField) -> Int
    func dropDownList(stringForItemInList list: NFDropDownListTextField, itemIndex index: Int) -> String
    func dropDownList(presentingViewControllerForList list: NFDropDownListTextField) -> UIViewController
    @objc optional func dropDownList(textColorForItemInList list: NFDropDownListTextField, atIndex index: Int) -> UIColor
    @objc optional func dropDownList(backgroundColorOfItem list: NFDropDownListTextField, atIndex index: Int) -> UIColor
    @objc optional func dropDownList(cornerRadiusForList list: NFDropDownListTextField) -> CGFloat
}
@objc protocol NFDropDownListTextFieldDelegate {
    @objc optional func dropDownList(didSelectItemInList list: NFDropDownListTextField, atItemIndex index: Int, andItemTitle title: String)
}
class NFDropDownListTextField: UITextField {

    @IBOutlet weak var dropDownDelegate: NFDropDownListTextFieldDelegate?
    @IBOutlet weak var dataSource: NFDropDownListTextFieldDataSource? {
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
        dataSource?.dropDownList(presentingViewControllerForList: self).present(tableViewController, animated: true)
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
            return dataSource!.dropDownList(numberOfItemsInList: self)
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuse", for: indexPath)
        cell.textLabel?.text = dataSource?.dropDownList(stringForItemInList: self, itemIndex: indexPath.row)
        if let textColor = dataSource!.dropDownList?(textColorForItemInList: self, atIndex: indexPath.row) {
            cell.textLabel?.textColor = textColor
        }
        if let backgroundColor = dataSource!.dropDownList?(backgroundColorOfItem: self, atIndex: indexPath.row) {
            cell.contentView.backgroundColor = backgroundColor
            cell.backgroundColor = backgroundColor
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard dataSource != nil else{
            tableViewController.dismiss(animated: true, completion: nil)
            return
        }
        dropDownDelegate?.dropDownList?(didSelectItemInList: self, atItemIndex: indexPath.row, andItemTitle: dataSource!.dropDownList(stringForItemInList: self, itemIndex: indexPath.row))
        tableViewController.dismiss(animated: true, completion: nil)
    }
}
extension NFDropDownListTextField: UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController: NFDropDownListTextFieldPresentationController = NFDropDownListTextFieldPresentationController.init(presentedViewController: presented, presenting: presenting)
        if dataSource != nil{
            if let cornerRadiusForTableView = dataSource!.dropDownList?(cornerRadiusForList: self) {
                presentationController.cornerRadius = cornerRadiusForTableView
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
