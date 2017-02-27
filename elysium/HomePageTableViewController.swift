//
//  MainPageTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 28/11/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit
import CoreData

class HomePageTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //AUTOLOANS
        /*if (segue.identifier == "ShowAutoLoanMainPage")
        {
            if let destinationVC = segue.destinationViewController as? MainPageTableViewController{
                destinationVC.vcAction = "ShowAutoLoanMainPage"
                NSLog("ShowAutoLoanMainPage")
            }
        }*/
    }
}
