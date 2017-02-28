//
//  MainPageTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 28/11/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit
import CoreData

class MainPageTableViewController: UITableViewController {
    
    var vcAction = ""
    var promoStatus = ""
    
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var autoPromoCell: UITableViewCell!
    @IBOutlet var listOfPromosCell: UITableViewCell!
    @IBOutlet var autoMainPageTable: UITableView!
    
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
        
        if(vcAction == "AutoPromoOptIn"){
            if let selectedAutoPromoLabel = defaults.stringForKey("selectedAutoPromo") {
                self.autoPromoCell.detailTextLabel?.text = selectedAutoPromoLabel
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let promoStatusLabel = defaults.stringForKey("promoStatus") {
            promoStatus = promoStatusLabel
        }
        
        if(promoStatus == "OptIn"){
            listOfPromosCell.userInteractionEnabled = false
            listOfPromosCell.accessoryType = .None
            if let selectedAutoPromoLabel = defaults.stringForKey("selectedAutoPromo") {
                self.autoPromoCell.detailTextLabel?.text = selectedAutoPromoLabel
            }
        }
        else{
            listOfPromosCell.contentView.backgroundColor = UIColor.clearColor()
            listOfPromosCell.accessoryType = .DisclosureIndicator
            listOfPromosCell.userInteractionEnabled = true
        }
        
        autoMainPageTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(vcAction == "AutoPromoOptIn"){
            if listOfPromosCell.selected == true {
                let alert = UIAlertView()
                alert.delegate = self
                alert.title = "Reminder"
                alert.message = "You are currently subcribed to Free Gas Promo."
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if promoStatus == "" && indexPath.section == 0 && indexPath.row == 6 {
            return 0
        }
        else if promoStatus == "OptOut" && indexPath.section == 0 && indexPath.row == 6 {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //AUTOLOANS
        if (segue.identifier == "ShowCarBrandList")
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowCarBrandList"
                destinationVC.rootVC = "autoMainMenu"
            }
            
        }
        
        if segue.identifier == "ShowRecentlyViewedCarModel"
        {
            if let destinationVC = segue.destinationViewController as? ListTableViewController{
                destinationVC.vcAction = "ShowRecentlyViewedCarModel"
            }
        }
        
        if (segue.identifier == "ShowAutoLoanCalculator")
        {
            if let destinationVC = segue.destinationViewController as? AutoTableViewController{
                destinationVC.vcAction = "ShowAutoLoanCalculator"
            }
            
            self.defaults.setObject("ShowAutoLoanCalculator", forKey: "vcAction")
            
            defaults.setObject("20", forKey: "selectedDP")
            defaults.setObject("60", forKey: "selectedTerm")
        }
        
        if segue.identifier == "ApplyLoanDirect"
        {
            if let destinationVC = segue.destinationViewController as? AutoTableViewController{
                destinationVC.vcAction = "ApplyLoanDirect"
                destinationVC.rootVC = "autoApplication"
            }
            
            self.defaults.setObject("ApplyLoanDirect", forKey: "vcAction")
            
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
        
        if segue.identifier == "ShowAutoInquiry"
        {
            if let destinationVC = segue.destinationViewController as? InquiryTableViewController{
                destinationVC.vcAction = "ShowAutoInquiry"
            }
        }
        
        if segue.identifier == "ShowAutoFAQ"
        {
            if let destinationVC = segue.destinationViewController as? FAQViewController{
                destinationVC.vcAction = "ShowAutoFAQ"
            }
        }
        
        if segue.identifier == "ShowAutoPromo"
        {
            if let destinationVC = segue.destinationViewController as? PromoViewController{
                destinationVC.vcAction = "ShowAutoPromo"
            }
            
            defaults.setObject("", forKey: "selectedAutoPromo")
            defaults.setObject("", forKey: "promoStatus")
        }
        
        if segue.identifier == "ShowSelectedAutoPromo"
        {
            if let destinationVC = segue.destinationViewController as? PromoDetailsViewController{
                destinationVC.vcAction = "ShowSelectedAutoPromo"
            }
        }
    }
}
