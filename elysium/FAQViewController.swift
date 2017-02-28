//
//  FAQViewController.swift
//  elysium
//
//  Created by TMS-ADS on 29/11/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController {
    
    var id = ""
    var name = ""
    var email = ""
    var autoInfo = ["","",""]
    var homeInfo = ["","",""]
    var ccInfo = ["","","",""]
    var products = ["Auto Loan","Home Loan","Credit Card","Salary"]
    var product = ""
    var prevPage = ""
    var vcAction = ""
    
    @IBOutlet var labelAppTitle: UILabel!
    @IBOutlet var textAbout: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfLogged()
        
        var str = ""
        
        if(vcAction == "ShowAutoFAQ")
        {
            str = NSLocalizedString("faq_auto", comment: "").html2String
            labelAppTitle.text = "Frequently Asked Question - Auto Loan"
            let attributedString = NSAttributedString(string: str)
            textAbout.attributedText = attributedString
        }
        
        if(vcAction == "ShowHomeFAQ")
        {
            str = NSLocalizedString("faq_home", comment: "").html2String
            labelAppTitle.text = "Frequently Asked Question - Home"
            let attributedString = NSAttributedString(string: str)
            textAbout.attributedText = attributedString
        }
        
        if(vcAction == "ShowCardFAQ")
        {
            str = NSLocalizedString("faq_card", comment: "").html2String
            labelAppTitle.text = "Frequently Asked Question - Credit Card"
            let attributedString = NSAttributedString(string: str)
            textAbout.attributedText = attributedString
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkIfLogged(){
        //Load User defaults
        let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if (userDefaults.objectForKey("id") != nil) {
            self.id = NSUserDefaults.standardUserDefaults().valueForKey("id") as! String
        }
        if (userDefaults.objectForKey("name") != nil) {
            self.name = NSUserDefaults.standardUserDefaults().valueForKey("name") as! String
        }
        if (userDefaults.objectForKey("email") != nil) {
            self.email = NSUserDefaults.standardUserDefaults().valueForKey("email") as! String
        }
        if (userDefaults.objectForKey("autoInfo") != nil) {
            self.autoInfo = NSUserDefaults.standardUserDefaults().valueForKey("autoInfo") as! [String]
        }
        if (userDefaults.objectForKey("homeInfo") != nil) {
            self.homeInfo = NSUserDefaults.standardUserDefaults().valueForKey("homeInfo") as! [String]
        }
        if (userDefaults.objectForKey("ccInfo") != nil) {
            self.ccInfo = NSUserDefaults.standardUserDefaults().valueForKey("ccInfo") as! [String]
        }
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