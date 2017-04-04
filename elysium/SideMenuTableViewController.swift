//
//  SideMenuTableViewController.swift
//  elysium
//
//  Created by user on 03/04/2017.
//  Copyright © 2017 UnionBank. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    
    @IBOutlet weak var loggedInAccountCell: UITableViewCell!
    @IBOutlet var sideMenuTable: UITableView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loggedInIDLabel = defaults.stringForKey("name") {
            self.loggedInAccountCell.textLabel?.text = loggedInIDLabel
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        loggedInAccountCell.userInteractionEnabled = false
        loggedInAccountCell.textLabel?.text = "hey!"
        
        if let loggedInIDLabel = defaults.stringForKey("name") {
            self.loggedInAccountCell.textLabel?.text = loggedInIDLabel
        }
        
        sideMenuTable.reloadData()
    }
    
    
    @IBAction func actionLogout(sender: AnyObject) {
        let alert = UIAlertController(title: "Logout Confirmation", message: "Are you sure you want to logout?", preferredStyle: .ActionSheet)
        let action = UIAlertAction(title: "Yes", style: .Default, handler: { (alert) -> Void in
            //self.selectedRowID = id
            self.clearUserDefaults()
            //self.performSegueWithIdentifier("BackToMain", sender: self)
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
}
