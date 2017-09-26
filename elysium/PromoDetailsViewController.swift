//
//  PromoViewController.swift
//  TestApp
//
//  Created by Kaye Alberto on 13/12/2016.
//  Copyright © 2016 Kaye Alberto. All rights reserved.
//

import UIKit

class PromoDetailsViewController: UIViewController {
    
    var vcAction = ""
    var promoUrl = ""
    var promoDesc = ""
    var promoStatus = ""
    var selectedAutoPromoCell = ""
    var selectedAutoPromoDesc = ""
    var selectedAutoPromoCode = ""
    
    @IBOutlet weak var imagePromo: UIImageView!
    @IBOutlet weak var webPromoDesc: UIWebView!
    @IBOutlet var promoOptOut: UIButton!
    @IBOutlet var promoOptIn: UIButton!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(vcAction == "ShowSelectedAutoPromo"){
            if let AutoPromoCellLabel = defaults.stringForKey("selectedAutoPromoCell") {
                promoUrl = AutoPromoCellLabel
            }
            
            if let AutoPromoDescLabel = defaults.stringForKey("selectedAutoPromoDesc") {
                promoDesc = AutoPromoDescLabel
            }
        }
        
        if(promoUrl != ""){
            if let url = NSURL(string: promoUrl) {
                let request = NSURLRequest(URL: url)
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                    dispatch_async(dispatch_get_main_queue(), {
                        if let imageData = data as NSData? {
                            self.imagePromo.image = UIImage(data: imageData)
                        }
                    })
                    
                }
                task.resume()
            }
        }
        webPromoDesc.loadHTMLString(promoDesc, baseURL: nil)
        webPromoDesc.dataDetectorTypes = UIDataDetectorTypes.Link
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let promoStatusLabel = defaults.stringForKey("promoStatus") {
            promoStatus = promoStatusLabel
        }
        
        if(promoStatus == ""){
            promoOptIn.hidden = false
            promoOptOut.hidden = true
        }
        
        if(promoStatus == "OptOut"){
            promoOptIn.hidden = false
            promoOptOut.hidden = true
        }
        
        if(promoStatus == "OptIn"){
            promoOptIn.hidden = true
            promoOptOut.hidden = false
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
    
    @IBAction func actionOptIn(sender: AnyObject) {
        self.defaults.setObject("OptIn", forKey: "promoStatus")
        let promo = "Free Gas Promo"
        
        /*
        let alert = UIAlertView()
        alert.delegate = self
        alert.title = "Promotional Confirmation Message"
        alert.message = "Thank you for subscribing to " + promo + " promotion"
        alert.addButtonWithTitle("OK")
        alert.show()
        */
        
        let alertController = UIAlertController(title: "Promotional Confirmation Message", message: "Thank you for subscribing to " + promo + " promotion", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { action in
            
        }
        alertController.addAction(OKAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionOptOut(sender: AnyObject) {
        self.defaults.setObject("OptOut", forKey: "promoStatus")
        self.defaults.setObject("", forKey: "selectedAutoPromoCode")
        self.defaults.setObject("", forKey: "selectedAutoPromoDesc")
        let promo = "Free Gas Promo"
        
        /*
        let alert = UIAlertView()
        alert.delegate = self
        alert.title = "Promotional Confirmation Message"
        alert.message = "You have unsubscribed from " + promo + " promotion"
        alert.addButtonWithTitle("OK")
        alert.show()
        */
        
        let alertController = UIAlertController(title: "Promotional Confirmation Message", message: "You have unsubscribed from " + promo + " promotion", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { action in
            
        }
        alertController.addAction(OKAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "AutoPromoOptIn")
        {
            if let destinationVC = segue.destinationViewController as? MainPageTableViewController{
                destinationVC.vcAction = "ShowSelectedAutoPromo"
            }
        }
    }
}
