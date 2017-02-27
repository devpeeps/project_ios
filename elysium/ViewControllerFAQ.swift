//
//  ViewControllerFAQ.swift
//  elysium
//
//  Created by Joshua Eleazar Bosinos on 25/01/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit

class ViewControllerFAQ: UIViewController {

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
    var str = ""
    
    let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //@IBOutlet var buttonLogout: UIButton!
    @IBOutlet var labelAppTitle: UILabel!
    @IBOutlet var textAbout: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkIfLogged()
        
        /*if(prevPage == "AutoMain"){
            str = NSLocalizedString("faq_auto", comment: "").html2String
            labelAppTitle.text = "FAQ - Auto Loan"
            
        }else if(prevPage == "HomeMain"){
            str = NSLocalizedString("faq_home", comment: "").html2String
            labelAppTitle.text = "FAQ - Home Loan"
            
        }else if(prevPage == "SalaryMain"){
            str = NSLocalizedString("faq_salary", comment: "").html2String
            labelAppTitle.text = "FAQ - Salary Loan"
        }*/
        
        if(vcAction == "ShowAutoFAQ")
        {
            str = NSLocalizedString("faq_auto", comment: "").html2String
            labelAppTitle.text = "Frequently Asked Question - Auto Loan"
        }
        
        //str = NSLocalizedString("faq_auto", comment: "").html2String
        //labelAppTitle.text = "Frequently Asked Question - Auto Loan"
        let attributedString = NSAttributedString(string: str)
        textAbout.attributedText = attributedString
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "AutoMain"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerAuto{
                destinationVC.vcAction = ""
                destinationVC.id = self.id
            }
        }
    }
    
    @IBAction func actionBackToMainMenu(sender: AnyObject) {
        if(self.prevPage == "AutoMain"){
            self.performSegueWithIdentifier("AutoMain", sender: self)
        }
        if(self.prevPage == "HomeMain"){
            self.performSegueWithIdentifier("HomeMain", sender: self)
        }
        if(self.prevPage == "CardMain"){
            self.performSegueWithIdentifier("CardMain", sender: self)
        }
        if(self.prevPage == "SalaryMain"){
            self.performSegueWithIdentifier("SalaryMain", sender: self)
        }
    }
    
    @IBAction func actionLogout(sender: AnyObject) {
        let alert = UIAlertController(title: "Logout Confirmation", message: "Are you sure you want to logout?", preferredStyle: .ActionSheet)
        let action = UIAlertAction(title: "Yes", style: .Default, handler: { (alert) -> Void in
            //self.selectedRowID = id
            self.clearUserDefaults()
            self.performSegueWithIdentifier("BackToMain", sender: self)
        })
        alert.addAction(action)
        let action2 = UIAlertAction(title: "No", style: .Default, handler: { (alert) -> Void in
            //self.selectedAmount = appraisedVal
            //self.performSegueWithIdentifier("showCalculator", sender: self)
        })
        alert.addAction(action2)
        presentViewController(alert, animated: true, completion: nil)
    }*/
    
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
        
        //show/hide logout button
        /*if(self.id == "NON" || self.id == ""){
            buttonLogout.hidden = true
        }else{
            buttonLogout.hidden = false
        }*/
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
