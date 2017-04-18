//
//  MainPageTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 28/11/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit
import CoreData

class HomePageTableViewController: UITableViewController {
    
    var id = ""
    var name = ""
    var email = ""
    var autoInfo = ["","",""]
    var homeInfo = ["","",""]
    var ccInfo = ["","","",""]
    var autoRates = [("",0.00)]
    var homeRates = [("",0.00)]
    var vcAction = ""
    
    var withConnection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if (userDefaults.objectForKey("name") != nil) {
            self.name = NSUserDefaults.standardUserDefaults().valueForKey("name") as! String
        }
        
        if(self.name != ""){
            getUserDefaults()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //@IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    func getUserDefaults(){
        let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if (userDefaults.objectForKey("name") != nil) {
            self.name = NSUserDefaults.standardUserDefaults().valueForKey("name") as! String
        }
        
        //loadingIndicator.hidden = false
        //loadingIndicator.startAnimating()
        
        var contProc = true
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            contProc = false
            withConnection = false
            //self.loadingIndicator.hidden = true
            //self.loadingIndicator.stopAnimating()
        default:
            contProc = true
            withConnection = true
        }
        
        if(contProc){
            
            //loadingIndicator.hidden = false
            //loadingIndicator.startAnimating()
            
            var urlAsString = "";
            
            if(name != "" && name != "Standard"){
                urlAsString = "https://eclipse.unionbankph.com/custom/elysium_ws_login.php?passw=" + name.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + "&from=android"
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
                            //self.loadingIndicator.stopAnimating()
                            //self.loadingIndicator.hidden = true
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
                                    
                                    self.autoInfo = [auto["aouid"] as! String, auto["rmname"] as! String, auto["rmemail"] as! String, auto["dp10"] as! String]
                                    
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
                                    
                                    
                                    //self.loadingIndicator.stopAnimating()
                                    //self.loadingIndicator.hidden = true
                                    
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
                                    
                                    //
                                    
                                })
                            }catch{
                                dispatch_async(dispatch_get_main_queue(), {
                                    //self.loadingIndicator.stopAnimating()
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
                                //self.loadingIndicator.stopAnimating()
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
                        //self.loadingIndicator.hidden = true
                        //self.loadingIndicator.stopAnimating()
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
            //self.loadingIndicator.hidden = true
            //self.loadingIndicator.stopAnimating()
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                exit(1)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
