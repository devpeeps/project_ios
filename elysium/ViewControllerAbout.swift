//
//  ViewControllerAbout.swift
//  elysium
//
//  Created by Joshua Eleazar Bosinos on 08/01/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit


class ViewControllerAbout: UIViewController {

    var id = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        checkIfLogged()
        
        
        labelAppTitle.sizeToFit()
        
        let str = NSLocalizedString("about_text", comment: "").html2String
        
        let attributedString = NSAttributedString(string: str)
        textAbout.attributedText = attributedString
        
        let appver = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        labelAppVersion.text = appver

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var labelAppTitle: UILabel!
    @IBOutlet var labelAppVersion: UILabel!
    @IBOutlet var buttonLogout: UIButton!

    @IBOutlet var textAbout: UITextView!
    @IBAction func backToMain(sender: AnyObject) {
        
        
        if(self.id == "NON" || self.id == ""){
            self.performSegueWithIdentifier("BackToMain", sender: self)
        }else{
            self.performSegueWithIdentifier("BackToMainLogged", sender: self)
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
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    func checkIfLogged(){
        //Load User defaults
        let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if (userDefaults.objectForKey("id") != nil) {
            self.id = NSUserDefaults.standardUserDefaults().valueForKey("id") as! String
        }
        
        //show/hide logout button
        if(self.id == "NON" || self.id == ""){
            buttonLogout.hidden = true
        }else{
            buttonLogout.hidden = false
        }
    }


}


