//
//  ViewControllerAuto.swift
//  elysium
//
//  Created by Joshua Eleazar Bosinos on 08/01/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit

class ViewControllerAuto: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource  {
    var id = ""
    var urlLib = ""
    var vcAction = ""
    var withConnection = false
    var carBrandArr = [("Choose Car Brand","")]
    var carModelArr = [("","","","")]
    var selectedCarBrand = ""
    var selectedCarModelId = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        checkIfLogged()
        
        if(vcAction == ""){
            loadCarBrandList()
        }
        
        if(vcAction == "ShowCarModelList"){
            loadCarModels(self.selectedCarBrand)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var pickerCarBrand: UIPickerView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var buttonLogout: UIButton!
    
    func loadCarBrandList(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "BRAND_SPINNER")
        
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
                            self.carBrandArr.removeAll()
                            for i in 0...str.count - 1{
                                if(str[i] != ""){
                                    self.carBrandArr.append((str[i], str[i]))
                                    if(i == 0){
                                        self.selectedCarBrand = self.carBrandArr[i].0
                                    }
                                }
                            }
                            self.pickerCarBrand.reloadAllComponents()
                            self.view.userInteractionEnabled = true
                            self.loadingIndicator.hidden = true
                            self.loadingIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        })
                    }else{
                        
                    }
                }else{
                    self.loadingIndicator.hidden = true
                    self.loadingIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                        exit(1)
                    })
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
            jsonQuery.resume()
        }else{
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                exit(1)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return carBrandArr.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return carBrandArr[row].0
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCarBrand = carBrandArr[row].0
    }
    
    @IBAction func actionSearchCarModel(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowCarModelList", sender: self)
    }
    
    @IBOutlet var tableViewCarModels: UITableView!
    func loadCarModels(carBrand: String){
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        var urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "MODEL")
        
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM1", withString: carBrand)
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM2", withString: "1")
        //NSLog(urlAsString)
        
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
                            self.carModelArr.removeAll()
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString(",")
                                if(str2.count >= 3){
                                    self.carModelArr.append((str2[0], str2[1], str2[2], str2[3]))
                                }
                            }
                            self.tableViewCarModels.reloadData()
                            self.view.userInteractionEnabled = true
                            self.loadingIndicator.hidden = true
                            self.loadingIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        })
                    }else{
                        
                    }
                }else{
                    self.loadingIndicator.hidden = true
                    self.loadingIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                        exit(1)
                    })
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
            jsonQuery.resume()
        }else{
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                exit(1)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carModelArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        var (_, modeldesc, srp, _) = self.carModelArr[indexPath.row]
        cell.textLabel!.text = modeldesc
        if(srp == ""){
            srp = "0"
        }
        let x = Int(srp)
        cell.detailTextLabel!.text = "PHP " + x!.stringFormattedWithSepator
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let (modelid, modeldesc, _, brand) = self.carModelArr[indexPath.row]
        
        let alert = UIAlertController(title: "Options for", message: brand + " " + modeldesc, preferredStyle: .ActionSheet)
        let action = UIAlertAction(title: "View Model Details", style: .Default, handler: { (alert) -> Void in
            self.selectedCarModelId = modelid
            self.performSegueWithIdentifier("showMapView", sender: self)
        })
        alert.addAction(action)
        let action2 = UIAlertAction(title: "Auto Loan Calculator", style: .Default, handler: { (alert) -> Void in
            self.selectedCarModelId = modelid
            self.performSegueWithIdentifier("showMapView", sender: self)
        })
        alert.addAction(action2)
        let action3 = UIAlertAction(title: "Apply for Auto Loan", style: .Default, handler: { (alert) -> Void in
            self.selectedCarModelId = modelid
            self.performSegueWithIdentifier("showMapView", sender: self)
        })
        alert.addAction(action3)
        let action4 = UIAlertAction(title: "Inquire Now", style: .Default, handler: { (alert) -> Void in
            self.selectedCarModelId = modelid
            self.performSegueWithIdentifier("showMapView", sender: self)
        })
        alert.addAction(action4)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func actionBackToMainMenu(sender: AnyObject) {
        if(self.id != "NON" && self.id != ""){
            self.performSegueWithIdentifier("BackToMainLogged", sender: self)
        }else{
            self.performSegueWithIdentifier("BackToMain", sender: self)
        }
    }
    @IBAction func actionLogout(sender: AnyObject) {
        let alert = UIAlertController(title: "Logout Confirmation", message: "Are you sure you want to logout?", preferredStyle: .ActionSheet)
        let action = UIAlertAction(title: "Yes", style: .Default, handler: { (alert) -> Void in
            //self.selectedRowID = id
            self.performSegueWithIdentifier("BackToMain", sender: self)
            self.clearUserDefaults()
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
        
        //show/hide logout button
        if(self.id != "NON" && self.id != ""){
            buttonLogout.hidden = false
        }else{
            buttonLogout.hidden = true
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
        if segue.identifier == "ShowCarModelList"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerAuto{
                destinationVC.vcAction = "ShowCarModelList"
                destinationVC.id = self.id
                destinationVC.selectedCarBrand = self.selectedCarBrand
            }
        }
    }
    

}

struct Number {
    static let formatterWithSepator: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .DecimalStyle
        return formatter
    }()
}
extension IntegerType {
    var stringFormattedWithSepator: String {
        return Number.formatterWithSepator.stringFromNumber(hashValue) ?? ""
    }
}
