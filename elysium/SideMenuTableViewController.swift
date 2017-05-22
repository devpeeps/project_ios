//
//  SideMenuTableViewController.swift
//  elysium
//
//  Created by user on 03/04/2017.
//  Copyright © 2017 UnionBank. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    
    var loginStatus = ""
    
    @IBOutlet weak var loggedInAccountCell: UITableViewCell!
    @IBOutlet var sideMenuTable: UITableView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInAccountCell.userInteractionEnabled = false
        
        if let loggedInIDLabel = defaults.stringForKey("name") {
            self.loggedInAccountCell.textLabel?.text = loggedInIDLabel
            loginStatus = loggedInIDLabel
            NSLog("PRINT NAME: " + String(self.loggedInAccountCell.textLabel?.text))
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        loggedInAccountCell.userInteractionEnabled = false
        
        if let loggedInIDLabel = defaults.stringForKey("name") {
            self.loggedInAccountCell.textLabel?.text = loggedInIDLabel
            loginStatus = loggedInIDLabel
        }
        
        sideMenuTable.reloadData()
    }
    
    @IBAction func actionLogout(sender: AnyObject) {
        let alert = UIAlertController(title: "Logout Confirmation", message: "Are you sure you want to logout?", preferredStyle: .ActionSheet)
        let action = UIAlertAction(title: "Yes", style: .Default, handler: { (alert) -> Void in
            //self.selectedRowID = id
            self.clearUserDefaults()
            self.performSegueWithIdentifier("BackToMainMenu", sender: self)
        })
        alert.addAction(action)
        let action2 = UIAlertAction(title: "No", style: .Default, handler: { (alert) -> Void in
            //self.selectedAmount = appraisedVal
            //self.performSegueWithIdentifier("showCalculator", sender: self)
        })
        alert.addAction(action2)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func clearUserDefaults(){
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "id")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "name")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "email")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "autoInfo")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "autoRates")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "homeInfo")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "homeRates")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "ccInfo")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var itemCount = 0
        
        if(section == 0){
            if(loginStatus != "" && loginStatus != "Standard"){
                itemCount = 1
            }else{
                itemCount = 0
            }
        }else if(section == 1){
            itemCount = 7
        }else if(section == 2){
            if(loginStatus != "" && loginStatus != "Standard"){
                itemCount = 1
            }else{
                itemCount = 0
            }
        }
        
        return itemCount
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerHeight: CGFloat = 0
        
        if(section == 0){
            if(loginStatus != "" && loginStatus != "Standard"){
                headerHeight = tableView.sectionHeaderHeight
            }else{
                headerHeight = CGFloat.min
            }
        } else if(section == 1){
            headerHeight = tableView.sectionHeaderHeight
        } else if(section == 2){
            if(loginStatus != "" && loginStatus != "Standard"){
                headerHeight = tableView.sectionHeaderHeight
            }else{
                headerHeight = CGFloat.min
            }
        }
        
        return headerHeight
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var footerHeight: CGFloat = 0
        
        if(section == 0){
            if(loginStatus != "" && loginStatus != "Standard"){
                footerHeight = tableView.sectionFooterHeight
            }else{
                footerHeight = CGFloat.min
            }
        } else if(section == 1){
            footerHeight = tableView.sectionFooterHeight
        } else if(section == 2){
            if(loginStatus != "" && loginStatus != "Standard"){
                footerHeight = tableView.sectionFooterHeight
            }else{
                footerHeight = CGFloat.min
            }
        }
        
        return footerHeight
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionHeader = ""
        
        if(section == 0){
            if(loginStatus != "" && loginStatus != "Standard"){
                sectionHeader = "Currently Logged In"
            }else{
                sectionHeader = ""
            }
        } else if(section == 1){
            sectionHeader = "Menu"
        } else if(section == 2){
            if(loginStatus != "" && loginStatus != "Standard"){
                sectionHeader = "Settings"
            }else{
                sectionHeader = ""
            }
        }
        
        return sectionHeader
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
}
