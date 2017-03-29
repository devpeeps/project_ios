//
//  ViewControllerMy.swift
//  elysium
//
//  Created by Joshua Eleazar Bosinos on 28/01/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerMy: UIViewController, UITableViewDelegate, UITextFieldDelegate  {
    var id = ""
    var name = ""
    var email = ""
    var autoInfo = ["","",""]
    var homeInfo = ["","",""]
    var ccInfo = ["","","",""]
    var mobileNo = ""
    
    var urlLib = ""
    var vcAction = ""
    var withConnection = false
    var myAppArr = [("type","id","name","status","datesubmitted","datelastupdate")]

    var showRecent = false
    
    let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 280
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewControllerMy.DismissKeyboard))
        view.addGestureRecognizer(dismiss)
        dismiss.cancelsTouchesInView = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewControllerMy.keyboardWasShown(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewControllerMy.keyboardWasNotShown(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        // Do any additional setup after loading the view.
        checkIfLogged()
        
        if(vcAction == ""){
            myAppArr.removeAll()
            loadMyAppList()
        }
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
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var buttonLogout: UIButton!
    @IBOutlet var tableViewMyApp: UITableView!
    
    func loadMyAppList(){
        if let mobilenoLabel = defaults.stringForKey("MOBILENO") {
          mobileNo = mobilenoLabel
        }
        
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        var urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "MY")
        
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM1", withString: mobileNo.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)
        
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM2", withString: UIDevice.currentDevice().identifierForVendor!.UUIDString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)
        
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
            
            self.loadingIndicator.hidden = false
            self.loadingIndicator.startAnimating()
            
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
                    
                    if(s != ""){
                        dispatch_async(dispatch_get_main_queue(), {
                            let str = s!.componentsSeparatedByString("<br/>")
                            self.myAppArr.removeAll()
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[1] != ""){
                                    self.myAppArr.append((str2[0], str2[1], str2[2], str2[3], str2[4], str2[5]))
                                }
                            }
                            
                            self.tableViewMyApp.reloadData()
                            
                            self.view.userInteractionEnabled = true
                            self.loadingIndicator.hidden = true
                            self.loadingIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                        })
                    }else{
                        dispatch_async(dispatch_get_main_queue(), {
                            self.view.userInteractionEnabled = true
                            self.loadingIndicator.hidden = true
                            self.loadingIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            let alert = UIAlertController(title: "Nothing to Diplay", message: "You have not submitted any applications yet on this device.", preferredStyle: .Alert)
                            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                            })
                            alert.addAction(action)
                            self.presentViewController(alert, animated: true, completion: nil)
                        })
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.userInteractionEnabled = true
                        self.loadingIndicator.hidden = true
                        self.loadingIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection.", preferredStyle: .Alert)
                        let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                            //exit(1)
                        })
                        alert.addAction(action)
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            })
            jsonQuery.resume()
        }else{
            self.view.userInteractionEnabled = true
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAppArr.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat = CGFloat.min
        
        return headerHeight
    }
    
    @IBOutlet var txtLabel1: UILabel!
    @IBOutlet var txtLabel2: UILabel!
    @IBOutlet var txtLabel3: UILabel!
    @IBOutlet var txtRightLabel1: UILabel!
    @IBOutlet var txtRightLabel2: UILabel!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MyTableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("listcell", forIndexPath: indexPath) as! MyTableViewCell
        
        let cell = tableView.dequeueReusableCellWithIdentifier("listcell", forIndexPath: indexPath) as! MyTableViewCell
        
        
        let (type, id, name, status, datesubmitted, datelastupdated) = self.myAppArr[indexPath.row]
        
        if(name != ""){
            cell.txtLabel1.text = name
            cell.txtLabel2.text = status
            cell.txtLabel3.text = "Ref#" + id
            cell.txtRightLabel1.text = datesubmitted
            cell.txtRightLabel2.text = datelastupdated
            var imageView = UIImage(named: "")
            switch(type){
            case "AUTO": imageView = UIImage(named: "ic_auto")
            break;
            case "HOME": imageView = UIImage(named: "ic_home")
            break;
            case "CARD": imageView = UIImage(named: "ic_creditcard2")
            break;
            default:
                break;
            }
            cell.imageView!.image = imageView
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //do nthing for now
    }

    /*
    @IBOutlet var buttonMenuBack: UIButton!
    @IBAction func actionBackToMainMenu(sender: AnyObject) {
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
    */
    
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
        
        //show/hide logout button
        /*
        if(self.id == "NON" || self.id == ""){
            buttonLogout.hidden = true
        }else{
            buttonLogout.hidden = false
        }
        */
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
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