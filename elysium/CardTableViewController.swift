//
//  CardTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 03/11/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit

class CardTableViewController: UITableViewController {
    @IBOutlet var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowCivilStatusList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowCivilStatusList"
            }
        }
    }
}