//
//  MainPageTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 28/11/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit
import CoreData

class HomeMainPageTableViewController: UITableViewController {
    
    var vcAction = ""
    var promoStatus = ""
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 280
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //HOME
        if segue.identifier == "ShowHomeInquiry"
        {
            if let destinationVC = segue.destinationViewController as? InquiryTableViewController{
                destinationVC.vcAction = "ShowHomeInquiry"
            }
        }
        
        if segue.identifier == "ShowHomeFAQ"
        {
            if let destinationVC = segue.destinationViewController as? FAQViewController{
                destinationVC.vcAction = "ShowHomeFAQ"
            }
        }
    }
}
