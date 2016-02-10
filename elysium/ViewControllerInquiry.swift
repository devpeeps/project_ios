//
//  ViewControllerInquiry.swift
//  elysium
//
//  Created by Joshua Eleazar Bosinos on 25/01/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerInquiry: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate  {

    var id = ""
    var name = ""
    var email = ""
    var autoInfo = ["","",""]
    var homeInfo = ["","",""]
    var ccInfo = ["","","",""]
    var autoRates = [("",0.00)]
    var autoRates_Standard = [("",0.00)]
    var homeRates = [("",0.00)]
    
    var withConnection = false
    
    var products = ["Auto Loan","Home Loan","Credit Card"]
    var product = ""
    var prevPage = ""
    
    var selectedCarBrand = ""
    
    var selectedPropertyType = ""
    var selectedProvince = ""
    var selectedCity = ""
    var selectedPriceFrom = ""
    var selectedPriceTo = ""
    
    var selectedCardCategory = ""
    
    var showRecent = false
    
    
    @IBOutlet var buttonLogout: UIButton!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet var pickerProduct: UIPickerView!
    
    @IBOutlet var lastname: UITextField!
    @IBOutlet var firstname: UITextField!
    @IBOutlet var middlename: UITextField!
    @IBOutlet var phonenumber: UITextField!
    @IBOutlet var mobilenumber: UITextField!
    @IBOutlet var emailaddress: UITextField!
    @IBOutlet var empphone: UITextField!
    @IBOutlet var remarks: UITextField!
    
    let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.hidden = true
        
        checkIfLogged()
        
        if(prevPage == "AutoMain"){
            pickerProduct.selectRow(0, inComponent: 0, animated: false)
        }else if(prevPage == "HomeMain"){
            pickerProduct.selectRow(1, inComponent: 0, animated: false)
        }else if(prevPage == "CardMain"){
            pickerProduct.selectRow(2, inComponent: 0, animated: false)
        }
        
        lastname.delegate = self
        firstname.delegate = self
        middlename.delegate = self
        phonenumber.delegate = self
        mobilenumber.delegate = self
        emailaddress.delegate = self
        empphone.delegate = self
        remarks.delegate = self
        
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(dismiss)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasNotShown:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return products.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {   let titleData = products[row]
        
        return titleData
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
        }
        pickerLabel!.textAlignment = .Left
        
        let titleData = products[row]
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Arial", size: 16.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    
    @IBAction func actionSubmit(sender: AnyObject) {
        let tnc = NSLocalizedString("tnc_apply", comment: "").html2String
        
        let alert = UIAlertController(title: "Acceptance of Terms & Conditions", message: tnc, preferredStyle: .ActionSheet)
        let action = UIAlertAction(title: "Yes, I accept", style: .Default, handler: { (alert) -> Void in
            self.submitInquiry()
        })
        alert.addAction(action)
        let action2 = UIAlertAction(title: "No, I do not accept", style: .Default, handler: { (alert) -> Void in
            //do nothing
        })
        alert.addAction(action2)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func submitInquiry(){
        self.loadingIndicator.hidden = false
        self.loadingIndicator.startAnimating()
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        
        let url = NSLocalizedString("urlINQ", comment: "")
        
        var stringUrl = url
        
        var errorctr = 0;
        var errormsg = "";
        stringUrl = stringUrl + "companyid=" + self.id;
        
        stringUrl = stringUrl + "&product=" + self.product.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        if(self.product == "Auto Loan"){
            stringUrl = stringUrl + "&ao=" + autoInfo[0].stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&aoemail=" + ""
        }else if(self.product == "Home Loan"){
            stringUrl = stringUrl + "&ao=" + homeInfo[0].stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&aoemail=" + ""
        }else if(self.product == "Credit Card"){
            stringUrl = stringUrl + "&ao=" + ccInfo[0].stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&aoemail=" + ccInfo[1].stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        }
        
        if(self.lastname.text == ""){
            errorctr++;
            errormsg += "Last Name\n";
        }
        if(self.firstname.text == ""){
            errorctr++;
            errormsg += "First Name\n";
        }
        if(self.mobilenumber.text == ""){ //CHECK IF VALID PHONE
            errorctr++;
            errormsg += "Mobile No\n";
        }
        if(self.emailaddress.text == "" || isValidEmail(self.emailaddress.text!) == false){ //CHECK IF VALID EMAIL
            errorctr++;
            errormsg += "Email Address\n";
        }
        if(self.empphone.text == ""){
            errorctr++;
            errormsg += "Emp/Biz Phone\n";
        }
        
        stringUrl = stringUrl + "&fullname=" + self.lastname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + (", " + self.firstname.text!).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + (" " + self.middlename.text!).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&lname=" + self.lastname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&fname=" + self.firstname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&mname=" + self.middlename.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&phone=" + self.phonenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&mobileno=" + self.mobilenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&email=" + self.emailaddress.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&officeno=" + self.empphone.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&msg=" + self.remarks.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&duid=" + UIDevice.currentDevice().identifierForVendor!.UUIDString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&dtype=ios"
        
        if(errorctr > 0){
            let alert = UIAlertController(title: "Error in Form", message: "You have blank/invalid/errors on some required fields.\n" + errormsg, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            self.view.userInteractionEnabled = true
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }else{
            NSUserDefaults.standardUserDefaults().setObject(self.lastname.text, forKey: "LASTNAME")
            NSUserDefaults.standardUserDefaults().setObject(self.firstname.text, forKey: "FIRSTNAME")
            NSUserDefaults.standardUserDefaults().setObject(self.middlename.text, forKey: "MIDDLENAME")
            NSUserDefaults.standardUserDefaults().setObject(self.mobilenumber.text, forKey: "MOBILENO")
            NSUserDefaults.standardUserDefaults().setObject(self.emailaddress.text, forKey: "EMAIL")
            NSUserDefaults.standardUserDefaults().setObject(self.phonenumber.text, forKey: "RESPHONE")
            NSUserDefaults.standardUserDefaults().setObject(self.empphone.text, forKey: "EMPBIZPHONE")
            
            
            let entityDescription = NSEntityDescription.entityForName("UrlStrings", inManagedObjectContext: manageObjectContext)
            let url = UrlStrings(entity:entityDescription!, insertIntoManagedObjectContext: manageObjectContext)
            url.url = stringUrl
            url.datecreated = String(NSDate())
            url.datesuccess = "0"
            url.refid = "INQ"
            
            
            
            self.view.userInteractionEnabled = true
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "Inquiry Submitted", message: "Your inquiry has been saved for submission. Please make sure not to quit the app and to have a stable data connection for a few minutes. You will receive an alert once it has been successfully sent.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                if(self.prevPage == "AutoMain"){
                    self.performSegueWithIdentifier("AutoMain", sender: self)
                }
                if(self.prevPage == "HomeMain"){
                    self.performSegueWithIdentifier("HomeMain", sender: self)
                }
                if(self.prevPage == "CardMain"){
                    self.performSegueWithIdentifier("CardTypeList", sender: self)
                }
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
            
            
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "AutoMain"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerAuto{
                destinationVC.vcAction = ""
                destinationVC.id = self.id
            }
        }
        if segue.identifier == "HomeMain"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerHome{
                destinationVC.vcAction = ""
                destinationVC.id = self.id
            }
        }
        if segue.identifier == "CardTypeList"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerCard{
                destinationVC.vcAction = ""
                destinationVC.id = self.id
                destinationVC.selectedCardCategory = selectedCardCategory
                destinationVC.vcAction = "ShowCardTypeList"
                destinationVC.prevPage = "mainCard"
            }
        }
    }
    
    @IBAction func actionBackToMainMenu(sender: AnyObject) {
        if(self.prevPage == "" || self.prevPage == "main"){
            if(self.id == "NON" || self.id == ""){
                self.performSegueWithIdentifier("BackToMain", sender: self)
            }else{
                self.performSegueWithIdentifier("BackToMainLogged", sender: self)
            }
        }else{
            if(self.prevPage == "AutoMain"){
                self.performSegueWithIdentifier("AutoMain", sender: self)
            }
            if(self.prevPage == "HomeMain"){
                self.performSegueWithIdentifier("HomeMain", sender: self)
            }
            if(self.prevPage == "CardMain"){
                self.performSegueWithIdentifier("CardTypeList", sender: self)
            }
            if(self.prevPage == "SalaryMain"){
                self.performSegueWithIdentifier("SalaryMain", sender: self)
            }
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
        if(self.id == "NON" || self.id == ""){
            buttonLogout.hidden = true
        }else{
            buttonLogout.hidden = false
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
    
        getUserDefaults()
    }
    
    func getUserDefaults(){
        let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if (userDefaults.objectForKey("id") != nil) {
            self.id = NSUserDefaults.standardUserDefaults().valueForKey("id") as! String
        }
        
        loadingIndicator.hidden = false
        loadingIndicator.startAnimating()
        
        var contProc = true
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            contProc = false
            withConnection = false
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
        default:
            contProc = true
            withConnection = true
        }
        
        if(contProc){
            
            loadingIndicator.hidden = false
            loadingIndicator.startAnimating()
            
            var urlAsString = "";
            
            if(id != ""){
                urlAsString = "https://eclipse.unionbankph.com/custom/elysium_ws_login.php?passw=" + id.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + "&from=android"
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
                            NSUserDefaults.standardUserDefaults().setObject("", forKey: "id")
                            self.loadingIndicator.stopAnimating()
                            self.loadingIndicator.hidden = true
                            let alert = UIAlertController(title: "Something's wrong", message: "There seems to be a problem with your installation. Relaunch the app to resolve the problem.", preferredStyle: .Alert)
                            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                                exit(1)
                            })
                            alert.addAction(action)
                            self.presentViewController(alert, animated: true, completion: nil)
                        })
                    }else{
                        let str = s!.characters.split{$0 == "|"}.map(String.init)
                        if(str.count >= 3){
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
                                    
                                    //SAVE
                                    NSUserDefaults.standardUserDefaults().setObject(self.id, forKey: "id")
                                    NSUserDefaults.standardUserDefaults().setObject(self.name, forKey: "name")
                                    NSUserDefaults.standardUserDefaults().setObject(self.email, forKey: "email")
                                    NSUserDefaults.standardUserDefaults().setObject(self.autoInfo, forKey: "autoInfo")
                                    
                                    for(term, rate) in self.autoRates{
                                        NSUserDefaults.standardUserDefaults().setObject(rate, forKey: "autoRates_" + term)
                                    }
                                    
                                    //NSUserDefaults.standardUserDefaults().setObject(self.autoRates as? AnyObject, forKey: "autoRates")
                                    
                                    NSUserDefaults.standardUserDefaults().setObject(self.homeInfo, forKey: "homeInfo")
                                    
                                    
                                    for(term, rate) in self.homeRates{
                                        NSUserDefaults.standardUserDefaults().setObject(rate, forKey: "homeRates_" + term)
                                    }
                                    
                                    //NSUserDefaults.standardUserDefaults().setObject(self.homeRates as? AnyObject, forKey: "homeRates")
                                    
                                    NSUserDefaults.standardUserDefaults().setObject(self.ccInfo, forKey: "ccInfo")
                                    
                                })
                            }catch{
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.loadingIndicator.stopAnimating()
                                    let alert = UIAlertController(title: "Error", message: "An error has occured! Relaunch the app and try again.", preferredStyle: .Alert)
                                    let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                                        exit(1)
                                    })
                                    alert.addAction(action)
                                    self.presentViewController(alert, animated: true, completion: nil)
                                })
                            }
                        }else{
                            dispatch_async(dispatch_get_main_queue(), {
                                self.loadingIndicator.stopAnimating()
                                let alert = UIAlertController(title: "Error", message: "There seems to be a problem with the connection. Please try again later.", preferredStyle: .Alert)
                                let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                                    exit(1)
                                })
                                alert.addAction(action)
                                self.presentViewController(alert, animated: true, completion: nil)
                            })
                        }
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loadingIndicator.hidden = true
                        self.loadingIndicator.stopAnimating()
                        let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
                        let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                            exit(1)
                        })
                        alert.addAction(action)
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            })
            jsonQuery.resume()
        }else{
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                exit(1)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
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
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }

}
