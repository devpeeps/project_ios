//
//  ViewControllerSalary.swift
//  elysium
//
//  Created by erick apostol on 14/07/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit
import CoreData

var protocolClasses = ViewControllerSalary()

class ViewControllerSalary: UIViewController, UITableViewDelegate, UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate{
    
    var id = ""
    var prevPage = ""
    var vcAction = ""
    var selectedTerm = "10"
    var salaryTermsArr = [12,24,36]

    var urlLuminous = ""
    var withConnection = false
    
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var address1: UITextField!
    @IBOutlet var companyCode: UITextField!
    @IBOutlet var mobilenumber: UITextField!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var middlename: UITextField!
    @IBOutlet var lastname: UITextField!
    @IBOutlet var firstname: UITextField!
    @IBOutlet var phonenumber: UITextField!
    @IBOutlet var birthday: UIDatePicker!
    @IBOutlet var address2: UITextField!
    @IBOutlet var mobileNumber: UITextField!
    @IBOutlet var cardNumber: UITextField!
    @IBOutlet var emailAddress: UITextField!
    
    @IBOutlet var codeOTP: UITextField!
    @IBOutlet var otpButton: UIButton!
    
    @IBOutlet var submitOTPCode: UIButton!
    @IBOutlet var resendOTP: UIButton!
    @IBOutlet var termscond: UILabel!
    @IBOutlet var submitApp: UIButton!
    @IBOutlet var computeAmort: UIButton!
    @IBOutlet var loanAmount: UITextField!
    @IBOutlet var sss: UITextField!
    
    @IBOutlet var payrollAccntNo: UITextField!
    @IBOutlet var tin: UITextField!
    @IBOutlet var pickerTerm: UIPickerView!

    @IBOutlet var txtMonthlyAmort: UITextField!
    
    
    @IBAction func companyCodeButton(sender: AnyObject) {
        checkMaxLength (sender as! UITextField, maxLength: 5)
    }
    
    
    @IBAction func computeAmort(sender: AnyObject) {
        let x = Int(calculateAmort())
        NSLog(String(x))
        txtMonthlyAmort.text = x.stringFormattedWithSepator
        
    }

    
    let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewControllerSalary.DismissKeyboard))
        view.addGestureRecognizer(dismiss)
        dismiss.cancelsTouchesInView = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewControllerSalary.keyboardWasShown(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewControllerSalary.keyboardWasNotShown(_:)), name:UIKeyboardWillHideNotification, object: nil);

        

        // Do any additional setup after loading the view.
        //checkIfLogged()
        // Do any additional setup after loading the view.
        
        //self.pickerTerm.dataSource = self;
        //self.pickerTerm.delegate = self;
        
        
        if(vcAction == ""){
            prevPage = "main"
            //loadCarBrandList()
        }
        
        if(vcAction == "SalaryLoanCalculator"){
            loadCalculatorValues()
        }
        
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (companyCode.text!.characters.count > maxLength) {
            companyCode.deleteBackward()
        }
    }
    
    func keyboardWasShown(notification: NSNotification) {

        let userInfo: [NSObject : AnyObject] = notification.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= 0
                })
            }
        } else {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    
    func keyboardWasNotShown(notification: NSNotification) {

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
    

    func calculateAmort() -> Double{
        /*
        let aor = 0.00
        var amount_financed = 0.00
        let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()

        if (userDefaults.objectForKey("homeRates_standard") != nil) {
            //aor = NSUserDefaults.standardUserDefaults().objectForKey("homeRates_standard") as! Double
        }
        
        let rate = aor / 100;
        amount_financed = Double(loanAmount.text!.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))!
       
        //NSLog("dp = " + String(dp))

        NSLog("loanAmount = " + String(loanAmount.text!.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)))
    
        NSLog("amount_financed = " + String(amount_financed))
    
        let term = Double(selectedTerm)!

    
        var amort = ((rate / 12) * (0 - amount_financed))
    
        amort = amort * (pow((1 + (rate / 12)), 12 * term) / (1 - pow((1 + (rate / 12)), 12 * term)));
         */
        return 1
 
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func actioninquiry(sender: AnyObject) {
        self.performSegueWithIdentifier("Inquiry", sender: self)
    }
    
    @IBAction func actionFAQ(sender: AnyObject) {
        self.performSegueWithIdentifier("FAQ", sender: self)
    }
    
    
    @IBOutlet var buttonMenuBack: UIButton!
    
    @IBAction func actionBackToMainMenu(sender: AnyObject) {
        if(self.prevPage == "" || self.prevPage == "main"){
            if(self.id == "NON" || self.id == ""){
                self.performSegueWithIdentifier("BackToMain", sender: self)
            }else{
                self.performSegueWithIdentifier("BackToMainLogged", sender: self)
            }
        }else{
            if(self.prevPage == "mainCard"){
                self.performSegueWithIdentifier("BackToCardMain", sender: self)
            }
            if(self.prevPage == "cardTypeList"){
                self.performSegueWithIdentifier("ShowCardTypeList", sender: self)
            }
            if(self.prevPage == "CardMainNew"){
                self.performSegueWithIdentifier("CardMainNew", sender: self)
            }
            
        }
        
        
    }
    
    
    
    @IBAction func actionSubmitOTPCode(sender: AnyObject) {
        self.checkOTPCode()
   
    }
    
    func checkOTPCode() {
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        
        let url = NSLocalizedString("urlLUMINOUS_LOGIN", comment: "")
        
        var stringUrl = url
        
        var errorctr = 0;
        var errormsg = "";
        
        
        if (self.codeOTP.text == "") {
            errorctr += 1;
            errormsg += "Valid OTP Code\n";
        }
        
        if(errorctr > 0) {
            let alert = UIAlertController(title: "Error in Form", message: "You have blank/invalid/errors on some required fields.\n" + errormsg, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
            //self.loadingIndicator.hidden = true
            //self.loadingIndicator.stopAnimating()
            self.view.userInteractionEnabled = true
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }else{
             stringUrl = stringUrl + "&otp=" + self.codeOTP.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            let entityDescription = NSEntityDescription.entityForName("UrlStrings", inManagedObjectContext: manageObjectContext)
            
            let url = UrlStrings(entity:entityDescription!, insertIntoManagedObjectContext: manageObjectContext)
            
            url.url = stringUrl
            url.datecreated = String(NSDate())
            url.refid = "OTP"
            url.datesuccess = "0"
            
            self.view.userInteractionEnabled = true
            //self.loadingIndicator.hidden = true
            //self.loadingIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "OTP Code", message: "OTP successfully submitted. Please wait for the code via SMS or to your email", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                self.performSegueWithIdentifier("SalaryLoanCalculator", sender: self)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func actionSubmitOTP(sender: AnyObject) {
        
        //dispatch_async(dispatch_get_main_queue(), {
            self.submitOTP()
        //})
        
        /*
        let tnc = NSLocalizedString("tnc_apply", comment: "").html2String
        
        let alert = UIAlertController(title: "Acceptance of Terms & Conditions", message: tnc, preferredStyle: .ActionSheet)
        let action = UIAlertAction(title: "Yes, I accept", style: .Default, handler: { (alert) -> Void in
            self.submitOTP()
        })
        alert.addAction(action)
        let action2 = UIAlertAction(title: "No, I do not accept", style: .Default, handler: { (alert) -> Void in
            //do nothing
        })
        alert.addAction(action2)
        presentViewController(alert, animated: true, completion: nil)
 */
        
    }
    
    func submitOTP(){
        
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var errorctr = 0;
        var errormsg = "";
        
        if (self.companyCode.text == "") {
            errorctr += 1;
            errormsg += "Company Code\n";
        }
        
        if (self.cardNumber.text == "") {
            errorctr += 1;
            errormsg += "Card Number\n";
        }
        
        if (self.emailAddress.text == "") {
            errorctr += 1;
            errormsg += "Email\n";
        }
        
        if (self.mobileNumber.text == "") {
            errorctr += 1;
            errormsg += "Mobile No\n";
        }
        
        if(errorctr > 0) {
            let alert = UIAlertController(title: "Error in Form", message: "You have blank/invalid/errors on some required fields.\n" + errormsg, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
            //self.loadingIndicator.hidden = true
            //self.loadingIndicator.stopAnimating()
            self.view.userInteractionEnabled = true
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
        }else{
            
            var stringUrl = "https://eclipse.unionbankph.com/custom/luminousLogin_ws.php?"
            
            stringUrl = stringUrl + "&key=3235323732303366656162303934373363306566633664353262346564323536".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&lumCompanyValue=" + self.companyCode.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&lumATMCardNo=" + self.cardNumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&lumEmail=" + self.emailAddress.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&lumCellPhone=" + self.mobileNumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            NSUserDefaults.standardUserDefaults().setObject(self.companyCode.text, forKey: "lumCompanyValue")
            NSUserDefaults.standardUserDefaults().setObject(self.cardNumber.text, forKey: "lumATMCardNo")
            NSUserDefaults.standardUserDefaults().setObject(self.emailAddress.text, forKey: "lumEmail")
            NSUserDefaults.standardUserDefaults().setObject(self.mobileNumber.text, forKey: "lumCellPhone")
            
            let url = NSURL(string: stringUrl)
            let urlSession = NSURLSession.sharedSession()
            
            var err = false
            
            let jsonQuery = urlSession.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
                if (error != nil) {
                    print(error!.localizedDescription)
                    err = true
                }
                print(err)
                
                if(!err){
                    
                    let s = String(data: data!, encoding: NSUTF8StringEncoding)
                    
                    if(s == "ERROR104"){
                        
                        let alert = UIAlertController(title: "Thank you for your interest", message: "Unfortunately, you are not qualified for salary loan at this time.", preferredStyle: .Alert)
                        
                        let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                            exit(1)
                        })
                        alert.addAction(action)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                        //self.loadingIndicator.hidden = true
                        //self.loadingIndicator.stopAnimating()
                        self.view.userInteractionEnabled = true
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                    }else if(s == "ERROR105") {
                        dispatch_async(dispatch_get_main_queue(), {
                            //self.loadingIndicator.stopAnimating()
                            //self.loadingIndicator.hidden = true
                            let alert = UIAlertController(title: "Thank you for your interest", message: "Unfortunately, you already have an existing salary loan application.", preferredStyle: .Alert)
                            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alert.addAction(action)
                            self.presentViewController(alert, animated: true, completion: nil)
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        })
                    }else if(s == "SUCCESS"){
                        print("SUCCESS")
                    }else{
                        print(s)
                    }
                    print(s)
                }
                
            })
            jsonQuery.resume()
        }
        
        
        //self.loadingIndicator.hidden = false
        //self.loadingIndicator.startAnimating()
        /*UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let url = NSLocalizedString("urlLUMINOUS_LOGIN", comment: "")
        var stringUrl = url
        
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
            
            var errorctr = 0;
            var errormsg = "";
            
            if (self.companyCode.text == "") {
                errorctr += 1;
                errormsg += "Company Code\n";
            }
            
            if (self.cardNumber.text == "") {
                errorctr += 1;
                errormsg += "Card Number\n";
            }
            
            if (self.emailAddress.text == "") {
                errorctr += 1;
                errormsg += "Email\n";
            }
            
            if (self.mobileNumber.text == "") {
                errorctr += 1;
                errormsg += "Mobile No\n";
            }
            
            if(errorctr > 0) {
                let alert = UIAlertController(title: "Error in Form", message: "You have blank/invalid/errors on some required fields.\n" + errormsg, preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                    //exit(1)
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                
                //self.loadingIndicator.hidden = true
                //self.loadingIndicator.stopAnimating()
                self.view.userInteractionEnabled = true
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
            else{
                
                //loadingIndicator.hidden = false
                //loadingIndicator.startAnimating()
                
                stringUrl = stringUrl + "&lumCompanyValue=" + self.companyCode.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
                
                stringUrl = stringUrl + "&lumATMCardNo=" + self.cardNumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
                
                stringUrl = stringUrl + "&lumEmail=" + self.emailAddress.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
                
                stringUrl = stringUrl + "&lumCellPhone=" + self.mobileNumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
                
                stringUrl = stringUrl + "&duid=" + UIDevice.currentDevice().identifierForVendor!.UUIDString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
                stringUrl = stringUrl + "&dtype=ios"
                
                let url = NSURL(string: stringUrl)!
                let urlSession = NSURLSession.sharedSession()
                print(stringUrl)
                var err = false
                
                let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
                    if (error != nil) {
                        print(error!.localizedDescription)
                        err = true
                    }
                    
                    if(!err){
                        
                        let s = String(data: data!, encoding: NSUTF8StringEncoding)
                        
                        if(s == "ERROR104"){
                            
                            let alert = UIAlertController(title: "Thank you for your interest", message: "Unfortunately, you are not qualified for salary loan at this time.", preferredStyle: .Alert)
                            
                            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                                //exit(1)
                            })
                            alert.addAction(action)
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                            self.loadingIndicator.hidden = true
                            self.loadingIndicator.stopAnimating()
                            self.view.userInteractionEnabled = true
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                        }else if(s == "ERROR105") {
                            dispatch_async(dispatch_get_main_queue(), {
                                //self.loadingIndicator.stopAnimating()
                                //self.loadingIndicator.hidden = true
                                let alert = UIAlertController(title: "Thank you for your interest", message: "Unfortunately, you already have an existing salary loan application.", preferredStyle: .Alert)
                                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                                alert.addAction(action)
                                self.presentViewController(alert, animated: true, completion: nil)
                                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            })
                        }else if(s == "SUCCESS"){
                            
                        }else{
                            
                        }
                    }
                    
                })
                jsonQuery.resume()
                
            }
        }
        else{
            //self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Please try again later.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    
        /*self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var stringUrl = urlLuminous
        
        
        
        stringUrl = stringUrl + "&lumCompanyValue=" + self.companyCode.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&lumATMCardNo=" + self.cardNumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&lumEmail=" + self.emailAddress.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&lumCellPhone=" + self.mobileNumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        if(errorctr > 0) {
            let alert = UIAlertController(title: "Error in Form", message: "You have blank/invalid/errors on some required fields.\n" + errormsg, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
            //self.loadingIndicator.hidden = true
            //self.loadingIndicator.stopAnimating()
            self.view.userInteractionEnabled = true
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
        }
        else{
            
            /*stringUrl = stringUrl + "&lumCompanyValue=" + self.companyCode.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&lumATMCardNo=" + self.cardNumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&lumEmail=" + self.emailAddress.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&lumCellPhone=" + self.mobileNumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;*/
            
            NSUserDefaults.standardUserDefaults().setObject(self.companyCode.text, forKey: "lumCompanyValue")
            NSUserDefaults.standardUserDefaults().setObject(self.cardNumber.text, forKey: "lumATMCardNo")
            NSUserDefaults.standardUserDefaults().setObject(self.emailAddress.text, forKey: "lumEmail")
            NSUserDefaults.standardUserDefaults().setObject(self.mobileNumber.text, forKey: "lumCellPhone")
            
            
            let url = NSURL(string: stringUrl)!
            let urlSession = NSURLSession.sharedSession()
            
            var err = false
            
            let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
                if (error != nil) {
                    print(error!.localizedDescription)
                    err = true
                }
            
                if(!err){
                    
                    let s = String(data: data!, encoding: NSUTF8StringEncoding)
                    
                    if(s == "ERROR104"){
                        
                        let alert = UIAlertController(title: "Thank you for your interest", message: "Unfortunately, you are not qualified for salary loan at this time.", preferredStyle: .Alert)
                        
                        let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                            //exit(1)
                        })
                        alert.addAction(action)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                        self.loadingIndicator.hidden = true
                        self.loadingIndicator.stopAnimating()
                        self.view.userInteractionEnabled = true
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                       
                    }else if(s == "ERROR105") {
                        dispatch_async(dispatch_get_main_queue(), {
                            //self.loadingIndicator.stopAnimating()
                            //self.loadingIndicator.hidden = true
                            let alert = UIAlertController(title: "Thank you for your interest", message: "Unfortunately, you already have an existing salary loan application.", preferredStyle: .Alert)
                            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alert.addAction(action)
                            self.presentViewController(alert, animated: true, completion: nil)
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        })
                    }else if(s == "SUCCESS"){
                        
                    }else{
                        
                        
                    }
                }
            
            })
            jsonQuery.resume()*/

            //
            /*
            let alert = UIAlertController(title: "Thank you for your interest", message: "Unfortunately, you are not qualified for salary loan at this time.", preferredStyle: .Alert)
            
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
            self.view.userInteractionEnabled = true
            UIApplication.sharedApplication().endIgnoringInteractionEvents()*/
            
            /*
            NSUserDefaults.standardUserDefaults().setObject(self.companyCode.text, forKey: "lumCompanyValue")
            NSUserDefaults.standardUserDefaults().setObject(self.cardNumber.text, forKey: "lumATMCardNo")
            NSUserDefaults.standardUserDefaults().setObject(self.emailAddress.text, forKey: "lumEmail")
            NSUserDefaults.standardUserDefaults().setObject(self.mobileNumber.text, forKey: "lumCellPhone")
     
            
            let entityDescription = NSEntityDescription.entityForName("UrlStrings", inManagedObjectContext: manageObjectContext)
            
            let url = UrlStrings(entity:entityDescription!, insertIntoManagedObjectContext: manageObjectContext)
            
            url.url = stringUrl
            url.datecreated = String(NSDate())
            url.refid = "OTP"
            url.datesuccess = "0"
            
            self.view.userInteractionEnabled = true
            //self.loadingIndicator.hidden = true
            //self.loadingIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "OTP Code", message: "OTP successfully submitted. Please wait for the code via SMS or to your email", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                self.performSegueWithIdentifier("salaryOTP", sender: self)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            */
        }*/
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Inquiry"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerInquiry{
                destinationVC.id = self.id
                destinationVC.prevPage = "SalaryMain"
                destinationVC.product = "Salary Loan"
            }
        }
        
        if segue.identifier == "FAQ"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerFAQ{
                destinationVC.id = self.id
                destinationVC.prevPage = "SalaryMain"
            }
        }
        
        if segue.identifier == "BackToMain"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerFAQ{
                destinationVC.id = self.id
                destinationVC.prevPage = "SalaryMain"
            }
        }
        
        if segue.identifier == "SalaryLoanCalculator"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerSalary{
                destinationVC.vcAction = "SalaryLoanCalculator"
                destinationVC.id = self.id
 
            }
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let tag = String(pickerView.tag)
        let index1 = tag.startIndex.advancedBy(1)
        let tagIndex = Int(tag.substringToIndex(index1))
        
        if(tagIndex == 1){
            return salaryTermsArr.count
        }
        return 0
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {   var titleData = ""
        let tag = String(pickerView.tag)
        let index1 = tag.startIndex.advancedBy(1)
        let tagIndex = Int(tag.substringToIndex(index1))
        
        if(tagIndex == 1){
            titleData = String(salaryTermsArr[row])
        }
        return titleData
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let tag = String(pickerView.tag)
    let index1 = tag.startIndex.advancedBy(1)
    let tagIndex = Int(tag.substringToIndex(index1))
    
    
        if(tagIndex == 1){ //SALARY TERM CALCULATOR
            selectedTerm = String(salaryTermsArr[row])
        
        }else if(tagIndex == 3){ //PROVINCE
     
    
        }else if(tagIndex == 4){ //CIVIL STATUS
    
        }else if(tagIndex == 6){ //POSITION
            
    
        }else if(tagIndex == 7){ //CITY
    
        }
    
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
        }
        pickerLabel!.textAlignment = .Center
        
        let tag = String(pickerView.tag)
        let index1 = tag.startIndex.advancedBy(1)
        let tagIndex = Int(tag.substringToIndex(index1))
        
        var titleData = ""
        if(tagIndex == 1){ //SALARY TERM CALCULATOR
            titleData = String(salaryTermsArr[row])
            pickerLabel!.textAlignment = .Left
        }
        
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Arial", size: 16.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        
        return pickerLabel
    }
    
    
    
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func loadCalculatorValues(){
        
        //loanAmount.text
        pickerTerm.selectRow(0, inComponent: 0, animated: false)
        
        //let x = Int(calculateAmort())
        //txtMonthlyAmort.text = x.stringFormattedWithSepator
        
    }
}
