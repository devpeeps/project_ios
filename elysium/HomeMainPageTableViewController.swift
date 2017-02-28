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
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //HOME
        if segue.identifier == "ShowSearchPropertyPage" {
            if let destinationVC = segue.destinationViewController as? HomeTableViewController{
                destinationVC.vcAction = "ShowSearchPropertyPage"
            }
        }
        
        if segue.identifier == "ShowHomeLoanCalculator"
        {
            if let destinationVC = segue.destinationViewController as? HomeTableViewController{
                destinationVC.vcAction = "ShowHomeLoanCalculator"
            }
            
            defaults.setObject("20", forKey: "selectedDP")
            defaults.setObject("60", forKey: "selectedDP")
        }
        
        if segue.identifier == "ShowHomeApplication"
        {
            if let destinationVC = segue.destinationViewController as? HomeTableViewController{
                destinationVC.vcAction = "ShowHomeApplication"
            }
            
            self.defaults.setObject("ShowHomeLoanApplication", forKey: "vcAction")
            
            defaults.setObject("20", forKey: "selectedDP")
            defaults.setObject("60", forKey: "selectedTerm")
            defaults.setObject("", forKey: "selectedCarModel")
            defaults.setObject("", forKey: "selectedCarBrand")
            defaults.setObject("", forKey: "selectedCarModelId")
            defaults.setObject("", forKey: "selectedCarModelSRP")
            defaults.setObject("", forKey: "selectedOccupation")
            defaults.setObject("", forKey: "selectedIncomeType")
            defaults.setObject("", forKey: "selectedSPOccupation")
            defaults.setObject("", forKey: "selectedSPIncomeType")
            defaults.setObject("", forKey: "selectedC1Occupation")
            defaults.setObject("", forKey: "selectedC1IncomeType")
            defaults.setObject("", forKey: "selectedC2Occupation")
            defaults.setObject("", forKey: "selectedC2IncomeType")
            defaults.setObject("", forKey: "selectedC2IncomeType")
            defaults.setObject("", forKey: "selectedCivilStatus")
            defaults.setObject("", forKey: "selectedCivilStatusCode")
        }
        
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
