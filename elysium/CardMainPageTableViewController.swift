//
//  MainPageTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 28/11/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit
import CoreData

class CardMainPageTableViewController: UITableViewController {
    
    var vcAction = ""
    var promoStatus = ""
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 68, height: 58))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "ubp_logo.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
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
        
        //CREDITCARDS
        if segue.identifier == "ShowCardInquiry"
        {
            if let destinationVC = segue.destinationViewController as? InquiryTableViewController{
                destinationVC.vcAction = "ShowCardInquiry"
            }
        }
        
        if segue.identifier == "ShowCardFAQ"
        {
            if let destinationVC = segue.destinationViewController as? FAQViewController{
                destinationVC.vcAction = "ShowCardFAQ"
            }
            
            
        }
        
        if segue.identifier == "ShowCardType"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowCardType"
            }
        }
        
        if segue.identifier == "ShowCardPromo"
        {
            if let destinationVC = segue.destinationViewController as? PromoViewController{
                destinationVC.vcAction = "ShowCardPromo"
            }
        }
        
        
        if segue.identifier == "ShowApplyCard"
        {
            if let destinationVC = segue.destinationViewController as? CardTableViewController{
                destinationVC.vcAction = "ShowApplyCard"
            }
            
            defaults.setObject("", forKey: "selectedCardType")
            defaults.setObject("", forKey: "selectedCardTypeName")
            defaults.setObject("", forKey: "selectedSalutation")
            defaults.setObject("", forKey: "selectedC1Salutation")
            defaults.setObject("", forKey: "selectedC2Salutation")
            defaults.setObject("", forKey: "selectedCivilStatus")
            defaults.setObject("", forKey: "selectedProvince")
            defaults.setObject("", forKey: "selectedProvince_present")
            defaults.setObject("", forKey: "selectedProvince_permanent")
            defaults.setObject("", forKey: "selectedProvinceBiz")
            defaults.setObject("", forKey: "selectedOccupation")
            defaults.setObject("", forKey: "selectedCity")
            defaults.setObject("", forKey: "selectedCity_present")
            defaults.setObject("", forKey: "selectedCity_permanent")
            defaults.setObject("", forKey: "selectedCityBiz")
            defaults.setObject("", forKey: "selectedIncomeType")
            defaults.setObject("", forKey: "selectedOccupationGroup")
            defaults.setObject("", forKey: "selectedIndustry")
            defaults.setObject("", forKey: "selectedBank")
            defaults.setObject("", forKey: "selectedHomeOwnership")
            defaults.setObject("", forKey: "selectedHomeOwnershipID")
            defaults.setObject("", forKey: "selectedSourceOfFund")
            defaults.setObject("", forKey: "selectedSourceOfFundID")
            defaults.setObject("", forKey: "selectedBillingAddress")
            defaults.setObject("", forKey: "selectedBillingAddressCode")
            defaults.setObject("", forKey: "selectedDeliveryAddress")
            defaults.setObject("", forKey: "selectedDeliveryAddressCode")
        }
    }
}
