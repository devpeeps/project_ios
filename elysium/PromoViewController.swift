//
//  ViewController.swift
//  TestApp
//
//  Created by Kaye Alberto on 07/12/2016.
//  Copyright © 2016 Kaye Alberto. All rights reserved.
//

import UIKit

class PromoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var vcAction = ""
    var urlLib = ""
    var withConnection = false
    var promoArr = [("", "", "")]
    var selectedAutoPromo = ""
    var selectedAutoPromoCode = ""
    
    @IBOutlet var tableViewPromo: UITableView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(vcAction == "ShowAutoPromo"){
            loadAutoPromoList()
        }
        
        if(vcAction == "ShowCardPromo"){
            loadCardPromoList()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadAutoPromoList(){
        urlLib = NSLocalizedString("urlLibPromos", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@PARAM1", withString: "AUTO")
        NSLog(urlLib)
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
            NSLog(String(url))
            var err = false
            
            let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
                if (error != nil) {
                    print(error!.localizedDescription)
                    err = true
                }
                
                NSLog(String(err))
                if(!err){
                    
                    let s = String(data: data!, encoding: NSUTF8StringEncoding)
                    if(s != ""){
                        dispatch_async(dispatch_get_main_queue(), {
                            let str = s!.componentsSeparatedByString("<br/>")
                            self.promoArr.removeAll()
                            for i in 0...str.count - 1{
                                if(str[i] != ""){
                                    let str2 = str[i].componentsSeparatedByString("***")
                                    self.promoArr.append((str2[1], str2[3], str2[4]))
                                }
                            }
                            
                            self.tableViewPromo.reloadData()
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
                            let alert = UIAlertController(title: "No Record Found", message: "Promos and Exclusive Offers not available", preferredStyle: .Alert)
                            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                                //exit(1)
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
                        let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Please try again.", preferredStyle: .Alert)
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
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Please try again.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)
                
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func loadCardPromoList(){
        urlLib = NSLocalizedString("urlLibPromos", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@PARAM1", withString: "CARDS")
        
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
                            self.promoArr.removeAll()
                            for i in 0...str.count - 1{
                                if(str[i] != ""){
                                    let str2 = str[i].componentsSeparatedByString("***")
                                    self.promoArr.append((str2[0], str2[3], str2[4]))
                                }
                            }
                            
                            self.tableViewPromo.reloadData()
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
                            let alert = UIAlertController(title: "No Record Found", message: "Promos and Exclusive Offers not available", preferredStyle: .Alert)
                            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                                //exit(1)
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
                        let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Please try again.", preferredStyle: .Alert)
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
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Please try again.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)
                
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let taskController = segue.destinationViewController as? PromoDetailsViewController
        let indexPath = self.tableViewPromo.indexPathForCell(sender as! UITableViewCell)
        let (promocode, promodesc, promourl) = self.promoArr[indexPath!.row]
        taskController!.promoUrl = promourl
        taskController!.promoDesc = promodesc
        self.defaults.setObject(promocode, forKey: "selectedAutoPromoCode")
        self.defaults.setObject(promourl, forKey: "selectedAutoPromoCell")
        self.defaults.setObject(promodesc, forKey: "selectedAutoPromoDesc")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promoArr.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var dropdownName = ""
        
        dropdownName = "Choose Promo"
        
        return dropdownName
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var listcell = tableView.dequeueReusableCellWithIdentifier("listcell") as? PromoTableViewCell
        let (_, _, promourl) = self.promoArr[indexPath.row]
        
        if listcell == nil{
            tableView .registerNib(UINib(nibName: "PromoTableViewCell", bundle: nil), forCellReuseIdentifier: "listcell")
            listcell = tableView.dequeueReusableCellWithIdentifier("listcell", forIndexPath: indexPath) as? PromoTableViewCell
        }
        
        if(promourl != ""){
            if let url = NSURL(string: promourl) {
                let request = NSURLRequest(URL: url)
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                    dispatch_async(dispatch_get_main_queue(), {
                        if let imageData = data as NSData? {
                            listcell!.imagePromo.image = UIImage(data: imageData)
                        }
                    })
                    
                }
                task.resume()
            }
        }
        return listcell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let (promocode, promodesc, promourl) = self.promoArr[indexPath.row]
        
        if(vcAction == "ShowAutoPromo"){
            NSLog("promocode: " + promocode)
            NSLog("promodesc: " + promodesc)
            NSLog("promourl: " + promourl)
            performSegueWithIdentifier("ShowAutoPromoDetails", sender: cell)
            self.defaults.setObject("Free Gas Promo", forKey: "selectedAutoPromo")
            self.defaults.setObject(promocode, forKey: "selectedAutoPromoCode")
        }
    
        if(vcAction == "ShowCardPromo"){
            performSegueWithIdentifier("ShowCardPromoDetails", sender: cell)
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130.0;
    }
}

