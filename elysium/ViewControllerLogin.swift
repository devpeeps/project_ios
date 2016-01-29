//
//  ViewControllerLogin.swift
//  elysium
//
//  Created by Joshua Eleazar Bosinos on 05/01/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit

class ViewControllerLogin: UIViewController, UITextFieldDelegate {
    var id = ""
    var name = ""
    var email = ""
    var autoInfo = ["aouid","rmname","rmemail"]
    var homeInfo = ["aouid","rmname","rmemail"]
    var ccInfo = ["aouid","aoemail","rmname","rmemail"]
    var autoRates = [("",0.00)]
    var homeRates = [("",0.00)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.hidden = true
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        Reach().monitorReachabilityChanges()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasNotShown:"), name:UIKeyboardWillHideNotification, object: nil);
        
        txtPassword.delegate = self
        
    }
    
    func networkStatusChanged(notification: NSNotification) {
        //let userInfo = notification.userInfo
        //print(userInfo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var txtPassword: UITextField!
    
    @IBAction func actionBackToMain(sender: AnyObject) {
        self.performSegueWithIdentifier("IDontHavePassword", sender: self)
    }
    
    
    @IBAction func actionLogin(sender: AnyObject) {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        var contProc = true
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            contProc = false
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
        default:
            contProc = true
        }
        
        if(contProc){
        
            loadingIndicator.hidden = false
            loadingIndicator.startAnimating()
            
            var urlAsString = "";
            
            if(sender.tag == 0){
                urlAsString = "https://eclipse.unionbankph.com/custom/elysium_ws_login.php?passw=" + txtPassword.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + "&from=android"
            }else{
                urlAsString = "https://eclipse.unionbankph.com/custom/elysium_ws_login.php?passw=NON&from=android"
            }
            
            let url = NSURL(string: urlAsString)!
            let urlSession = NSURLSession.sharedSession()

            var err = false
            
            let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
                if (error != nil) {
                    print(error!.localizedDescription)
                    err = true
                }
                
                if(!err){
                    
                    let s = String(data: data!, encoding: NSUTF8StringEncoding)
                    
                    if(s == "INVALID_LOGIN"){
                        dispatch_async(dispatch_get_main_queue(), {
                            self.loadingIndicator.stopAnimating()
                            self.loadingIndicator.hidden = true
                            let alert = UIAlertController(title: "Invalid login", message: "You entered an invalid company code!", preferredStyle: .Alert)
                            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alert.addAction(action)
                            self.presentViewController(alert, animated: true, completion: nil)
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        })
                    }else{
                        let str = s!.characters.split{$0 == "|"}.map(String.init)
                        
                        let jsonStr = NSString(string: str[3]).dataUsingEncoding(NSUTF8StringEncoding)
                        let jsonStr_Standard = NSString(string: str[4]).dataUsingEncoding(NSUTF8StringEncoding)
                        do{
                            //let err: NSError?
                            let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonStr!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                            
                            let jsonResult_Standard = try NSJSONSerialization.JSONObjectWithData(jsonStr_Standard!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        
                            //if (err != nil) {
                            //    print("JSON Error \   (err!.localizedDescription)")
                            //}
                        
                            // 4
                            //let text1: String! = jsonResult["id"] as! String
                            //let text2: String! = jsonResult["name"] as! String
                            dispatch_async(dispatch_get_main_queue(), {
                                self.id = jsonResult["id"] as! String
                                self.name = jsonResult["name"] as! String
                                self.email = jsonResult["email"] as! String
                                
                                let products = jsonResult["products"] as! NSDictionary
                                let products_Standard = jsonResult_Standard["products"] as! NSDictionary
                                
                                //AUTO
                                let auto = products["auto"] as! NSDictionary
                                let autoRates = auto["rates"] as! NSDictionary
                                
                                let auto_Standard = products_Standard["auto"] as! NSDictionary
                                let autoRates_Standard = auto_Standard["rates"] as! NSDictionary
                                
                                self.autoInfo = [auto["aouid"] as! String, auto["rmname"] as! String, auto["rmemail"] as! String]

                                self.autoRates.removeAll()
                                for(term, rate) in autoRates{
                                    if(rate as! String == ""){
                                        self.autoRates.append((term as! String, (autoRates_Standard.valueForKey(term as! String) as! NSString).doubleValue))
                                    }else{
                                        self.autoRates.append((term as! String, (rate as! NSString).doubleValue))
                                    }
                                    
                                }
                                
                                //HOME
                                let home = products["home"] as! NSDictionary
                                let homeRates = home["rates"] as! NSDictionary
                                
                                let home_Standard = products_Standard["home"] as! NSDictionary
                                let homeRates_Standard = home_Standard["rates"] as! NSDictionary
                                
                                self.homeInfo = [home["aouid"] as! String, home["rmname"] as! String, home["rmemail"] as! String]
                                
                                self.homeRates.removeAll()
                                for(term, rate) in homeRates{
                                    if(rate as! String == ""){
                                        self.homeRates.append((term as! String, (homeRates_Standard.valueForKey(term as! String) as! NSString).doubleValue))
                                    }else{
                                        self.homeRates.append((term as! String, (rate as! NSString).doubleValue))
                                    }
                                    
                                }
                                
                                //CREDIT CARD
                                let creditcard = products["creditcard"] as! NSDictionary
                                let creditcard_Standard = products_Standard["creditcard"] as! NSDictionary
                                
                                var aouid = ""
                                var aoemail = ""
                                var rmname = ""
                                var rmemail = ""
                                if(creditcard["aouid"] as! String == ""){
                                    aouid = creditcard_Standard["aouid"] as! String
                                }else{
                                    aouid = creditcard["aouid"] as! String
                                }
                                
                                if(creditcard["aoemail"] as! String == ""){
                                    aoemail = creditcard_Standard["aoemail"] as! String
                                }else{
                                    aoemail = creditcard["aoemail"] as! String
                                }
                                
                                if(creditcard["rmname"] as! String == ""){
                                    rmname = creditcard_Standard["rmname"] as! String
                                }else{
                                    rmname = creditcard["rmname"] as! String
                                }
                                
                                if(creditcard["rmemail"] as! String == ""){
                                    rmemail = creditcard_Standard["rmemail"] as! String
                                }else{
                                    rmemail = creditcard["rmemail"] as! String
                                }
                                
                                self.ccInfo = [aouid, aoemail, rmname, rmemail]
                                
                                
                                self.loadingIndicator.stopAnimating()
                                self.loadingIndicator.hidden = true
                                
                                self.saveUserDefaults()
                                
                                if(sender.tag == 0){
                                    self.performSegueWithIdentifier("LoginSuccess", sender: self)
                                }else{
                                    self.performSegueWithIdentifier("IDontHavePassword", sender: self)
                                }
                                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            })
                        }catch{
                            self.loadingIndicator.stopAnimating()
                            let alert = UIAlertController(title: "Error", message: "An error has occured!", preferredStyle: .Alert)
                            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alert.addAction(action)
                            self.presentViewController(alert, animated: true, completion: nil)
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        }
                    }
                }else{
                    self.loadingIndicator.hidden = true
                    self.loadingIndicator.stopAnimating()
                    let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Please try again later.", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                }
            })
            jsonQuery.resume()
        }else{
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Please try again later.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
    
    func keyboardWasShown(notification: NSNotification) {
        /*
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
        self.bottomConstraint.constant = keyboardFrame.size.height + 20
        })
        */
        let userInfo: [NSObject : AnyObject] = notification.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    
    func keyboardWasNotShown(notification: NSNotification) {
        /*
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
        self.bottomConstraint.constant = keyboardFrame.size.height - 20
        })
        */
        let userInfo: [NSObject : AnyObject] = notification.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        if self.view.frame.origin.y + keyboardSize.height == 0 {
            self.view.frame.origin.y += keyboardSize.height
        }else{
            self.view.frame.origin.y = 0
        }
    }
    
    //touches the screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    //presses the return button from the keypad
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false;
    }
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LoginSuccess"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerMain{
                destinationVC.id = self.id
                destinationVC.name = self.name
                destinationVC.email = self.email
                destinationVC.autoInfo = self.autoInfo
                destinationVC.autoRates = self.autoRates
                destinationVC.homeInfo = self.homeInfo
                destinationVC.homeRates = self.homeRates
                destinationVC.ccInfo = self.ccInfo
            }
        }
    }
    
    func saveUserDefaults(){
        NSUserDefaults.standardUserDefaults().setObject(self.id, forKey: "id")
        NSUserDefaults.standardUserDefaults().setObject(self.name, forKey: "name")
        NSUserDefaults.standardUserDefaults().setObject(self.email, forKey: "email")
        NSUserDefaults.standardUserDefaults().setObject(self.autoInfo, forKey: "autoInfo")
        NSUserDefaults.standardUserDefaults().setObject(self.autoRates as? AnyObject, forKey: "autoRates")
        NSUserDefaults.standardUserDefaults().setObject(self.homeInfo, forKey: "homeInfo")
        NSUserDefaults.standardUserDefaults().setObject(self.homeRates as? AnyObject, forKey: "homeRates")
        NSUserDefaults.standardUserDefaults().setObject(self.ccInfo, forKey: "ccInfo")
    }

}
