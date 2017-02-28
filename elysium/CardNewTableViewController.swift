//
//  CardNewTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 06/01/2017.
//  Copyright © 2017 UnionBank. All rights reserved.
//

import UIKit
import CoreData

class CardNewTableViewController: UITableViewController, UINavigationControllerDelegate {

    var vcAction = ""
    
    let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "CardCategoryTravel"
        {
            if let destinationVC = segue.destinationViewController as? ListTableViewController{
                destinationVC.vcAction = "CardCategoryTravel"
            }
        }
        
        if segue.identifier == "CardCategoryCashBack"
        {
            if let destinationVC = segue.destinationViewController as? ListTableViewController{
                destinationVC.vcAction = "CardCategoryCashBack"
            }
        }
    }
}