//
//  DropdownTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 07/11/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var urlLib = ""
    var vcAction = ""
    var rootVC = ""
    var passedValue = ""
    var withConnection = false
    var propertyModelArr = [("modelid","modeldesc", "proj", "type",0.00,0.00,"areafrom","areato","developer","prov","city")]
    var carModelArr = [("","","","")]
    var cardTypeArr = [("","","","","")]
    var selectedCarBrand = ""
    var selectedCarBrandurl = ""
    var downpaymentArrAuto = [10,20,30,40,50,60,70,80,90]
    var carTermsArr = [60,48,36,24,18,12]
    var selectedCarModelId = ""
    var selectedCarModelSRP = 0
    var selectedTerm = "60"
    var selectedDP = "20"
    var selectedCardCategory = ""
    var selectedCardType = ""
    var selectedCardTypeName = ""
    var selectedPropertyType = ""
    var selectedProvince = ""
    var selectedCity = ""
    var selectedPriceFrom = ""
    var selectedPriceTo = ""
    var selectedPropertyModelId = ""
    var selectedPropertyProj = ""
    var selectedPropertyDeveloper = ""
    var selectedPropertyModelSRP = 0
    
    var showRecent = false
    
    @IBOutlet var tableViewCardType: UITableView!
    @IBOutlet var tableViewCarModels: UITableView!
    @IBOutlet var tableViewPropertyModels: UITableView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if(vcAction == "ShowCarModelList"){
            if let carBrand = defaults.stringForKey("selectedCarBrand") {
                selectedCarBrand = carBrand
            }
            NSLog("selected " + selectedCarBrand)
            loadCarModels(selectedCarBrand)
        }
        
        if(vcAction == "ShowRecentlyViewedCarModel"){
            loadCarModelsRecent()
        }
        
        if(vcAction == "CardCategoryTravel"){
            defaults.setObject("Travel", forKey: "selectedCardCategory")
            if let cardCategory = defaults.stringForKey("selectedCardCategory") {
                selectedCardCategory = cardCategory
            }
            loadCardTypeList()
        }
        
        if(vcAction == "CardCategoryCashBack"){
            defaults.setObject("Cash Back", forKey: "selectedCardCategory")
            if let cardCategory = defaults.stringForKey("selectedCardCategory") {
                selectedCardCategory = cardCategory
            }
            loadCardTypeList()
        }
        
        if(vcAction == "ShowCardTypeList"){
            if let cardCategory = defaults.stringForKey("selectedCardCategory") {
                selectedCardCategory = cardCategory
            }
            loadCardTypeList()
        }
        
        if(vcAction == "ShowPropertyModelList"){
            
            if let propertyTypeLabel = defaults.stringForKey("selectedPropertyType") {
                selectedPropertyType = propertyTypeLabel
            }
            
            if let priceFromLabel = defaults.stringForKey("selectedPriceFrom") {
                selectedPriceFrom = priceFromLabel
            }
            
            if let priceToLabel = defaults.stringForKey("selectedPriceTo") {
                selectedPriceTo = priceToLabel
            }
            
            if let provinceLabel = defaults.stringForKey("selectedProvince") {
                selectedProvince = provinceLabel
            }
            
            if let cityLabel = defaults.stringForKey("selectedCity") {
                selectedCity = cityLabel
            }
            
            loadPropertyModels()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCarModels(carBrand: String){
        
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        var urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "MODEL")
        
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM1", withString: carBrand.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM2", withString: "1")

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
            
        }
        else{
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
    
    func loadCarModelsRecent(){
        showRecent = true
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        var urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "MODEL")
        
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM1", withString: "HISTORY")
        
        var s = ""
        if (NSUserDefaults.standardUserDefaults().valueForKey("viewedVehicles") != nil) {
            s = NSUserDefaults.standardUserDefaults().valueForKey("viewedVehicles") as! String
        }
        
        
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM2", withString: s)
        NSLog(urlAsString)
        
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
                        dispatch_async(dispatch_get_main_queue(), {
                            self.view.userInteractionEnabled = true
                            self.loadingIndicator.hidden = true
                            self.loadingIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            let alert = UIAlertController(title: "Recently Viewed Vehicles Empty", message: "You have not recently viewed any vehicle.", preferredStyle: .Alert)
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
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func loadCardTypeList(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        var urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "CARDTYPE_FILTERCATEGORY")
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM1", withString: selectedCardCategory.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)
        
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
                            self.cardTypeArr.removeAll()
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[1] != ""){
                                    self.cardTypeArr.append((str2[1], str2[0], str2[2], str2[3], str2[4]))
                                }
                            }
                            self.tableViewCardType.reloadData()
                            
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
                            let alert = UIAlertController(title: "Recently Viewed Vehicles Empty", message: "You have not recently viewed any vehicle.", preferredStyle: .Alert)
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
    
    func loadPropertyModels(){
        
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        var urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "HOMEMODELS")
        
        NSLog("function: loadPropertyModels")
        NSLog("selectedPropertyType: " + selectedPropertyType)
        NSLog("selectedPriceFrom: " + selectedPriceFrom)
        NSLog("selectedPriceTo: " + selectedPriceTo)
        NSLog("selectedProvince: " + selectedProvince)
        NSLog("selectedCity: " + selectedCity)
 
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM1", withString: selectedPropertyType.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)
        
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM2", withString: selectedPriceFrom.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))
        
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM3", withString: selectedPriceTo.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))
        
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM4", withString: selectedProvince.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)
        
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM5", withString: selectedCity.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)
 
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
            //NSLog("url: " + String(url))
            //NSLog("urlSession: " + String(urlSession))
            
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
                            self.propertyModelArr.removeAll()
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2.count >= 3){
                                    self.propertyModelArr.append((str2[0], str2[1], str2[3], str2[4], Double(str2[13])!, Double(str2[14])!, str2[5], str2[6], str2[10], str2[11], str2[12]))
                                }
                            }
                            self.tableViewPropertyModels.reloadData()
                            self.view.userInteractionEnabled = true
                            self.loadingIndicator.hidden = true
                            self.loadingIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        })
                    }else{
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableViewPropertyModels.reloadData()
                            self.view.userInteractionEnabled = true
                            self.loadingIndicator.hidden = true
                            self.loadingIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            let alert = UIAlertController(title: "No Record Found", message: "No properties found using the specified search criteria.", preferredStyle: .Alert)
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var itemCount = 0
        
        if(vcAction == "ShowCarModelList"){
            itemCount = carModelArr.count
        }
        
        if(vcAction == "ShowRecentlyViewedCarModel"){
            itemCount = carModelArr.count
        }
        
        if(vcAction == "ShowCardTypeList" || vcAction == "CardCategoryTravel" || vcAction == "CardCategoryCashBack"){
            itemCount = cardTypeArr.count
        }
        
        if(vcAction == "ShowPropertyModelList"){
            itemCount = propertyModelArr.count
        }
        
        return itemCount
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let listcell = tableView.dequeueReusableCellWithIdentifier("listcell", forIndexPath: indexPath) as UITableViewCell
        
        if(vcAction == "ShowCarModelList" || vcAction == "ShowRecentlyViewedCarModel"){
            var (_, modeldesc, srp, _) = self.carModelArr[indexPath.row]
            
            if(modeldesc != ""){
                listcell.textLabel!.text = modeldesc
                if(srp == ""){
                    srp = "0"
                }
                let x = Int(srp)
                listcell.detailTextLabel!.text = "PHP " + x!.stringFormattedWithSepator
            }else{
                listcell.textLabel!.text = ""
                listcell.detailTextLabel!.text = ""
            }
        } else if(vcAction == "ShowCardTypeList" || vcAction == "CardCategoryTravel" || vcAction == "CardCategoryCashBack"){
            let (_, name, img, _, category) = self.cardTypeArr[indexPath.row]

            if(name != ""){
                listcell.textLabel?.text = name
                listcell.detailTextLabel?.text = category
                let imageView = UIImage(named: img)
                listcell.imageView!.image = imageView
            }
        } else if(vcAction == "ShowPropertyModelList"){
            let (_, modeldesc, proj, _, _, srpto, areafrom, areato, _, prov, city) = self.propertyModelArr[indexPath.row]
            
            if(modeldesc != ""){
                listcell.detailTextLabel!.numberOfLines = 1
                listcell.textLabel?.text = modeldesc.capitalizedString + " - " + proj.capitalizedString
                let x = Int(srpto)
                //let sub = city + ", " + prov + "\n PHP " + x.stringFormattedWithSepator + "(From " + areafrom + "sqm to " + areato + "sqm)"
                listcell.detailTextLabel?.text = city + ", " + prov + "\n PHP " + x.stringFormattedWithSepator + "(From " + areafrom + "sqm to " + areato + "sqm)"
                //listcell.detailTextLabel?.text = "PHP " + x.stringFormattedWithSepator + "(From " + areafrom + "sqm to " + areato + "sqm)"
                //listcell.textLabel?.text = "PHP " + x.stringFormattedWithSepator + "(From " + areafrom + "sqm to " + areato + "sqm)"
                //listcell.lblFirstRow?.text = modeldesc.capitalizedString + " - " + proj.capitalizedString
                //listcell.lblThirdRow.text = city + ", " + prov
                //let x = Int(srpto)
                //listcell.lblSecondRow.text = "PHP " + x.stringFormattedWithSepator + "(From " + areafrom + "sqm to " + areato + "sqm)"
            }
        }
        return listcell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var dropdownName = ""
        
        if(vcAction == "ShowCarModelList"){
            dropdownName = "Choose Car Model"
        }
        
        if(vcAction == "ShowRecentlyViewedCarModel"){
            dropdownName = "Recently Viewed Car Model"
        }
        
        if(vcAction == "ShowCardTypeList"){
            dropdownName = "Choose Credit Card"
        }
        
        if(vcAction == "CardCategoryTravel"){
            dropdownName = "Getgo"
        }
        
        if(vcAction == "CardCategoryCashBack"){
            dropdownName = "Cash Back"
        }
        
        if(vcAction == "ShowPropertyModelList"){
            dropdownName = "Choose Property Model"
        }
        
        return dropdownName
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow! //optional, to get from any UIButton for example
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell

        if((rootVC == "autoMainMenu" && vcAction == "ShowCarModelList") || vcAction == "ShowRecentlyViewedCarModel"){
            selectedCarModelId = currentCell.textLabel!.text!
            self.defaults.setObject(selectedCarModelId, forKey: "selectedCarModel")
            
            let (modelid, modeldesc, srp, brand) = self.carModelArr[indexPath.row]
            
            let alert = UIAlertController(title: "Options for", message: brand + " " + modeldesc, preferredStyle: .ActionSheet)
            let action = UIAlertAction(title: "View Model Details", style: .Default, handler: { (alert) -> Void in
                //self.selectedCarModelId = modelid
                //self.performSegueWithIdentifier("ViewCarDetails", sender: self)
                let x = Int(srp)!.stringFormattedWithSepator
                let alert_ = UIAlertController(title: "Vehicle Details", message: "Brand : " + brand + "\r\n" + "Model Description : " + modeldesc + "\r\n" + "SRP : PHP " + x, preferredStyle: .Alert)
                let action_ = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                })
                alert_.addAction(action_)
                self.presentViewController(alert_, animated: true, completion: nil)
                
                self.defaults.setObject(brand, forKey: "selectedCarBrand")
                self.defaults.setObject(modelid, forKey: "selectedCarModelId")
                self.defaults.setObject(x, forKey: "selectedCarModelSRP")
                
                //SAVE SELECTED TO RECENTLY VIEWED ITEM
                let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
                if (userDefaults.objectForKey("viewedVehicles") != nil) {
                    let s = NSUserDefaults.standardUserDefaults().valueForKey("viewedVehicles") as! String
                    
                    let arr = s.characters.split{$0 == ","}.map(String.init)
                    var selectedModelId_viewed = false
                    for(mId) in arr{
                        if(mId == modelid){
                            selectedModelId_viewed = true
                        }
                    }
                    if(!selectedModelId_viewed){
                        NSUserDefaults.standardUserDefaults().setObject(s + "," + modelid, forKey: "viewedVehicles")
                    }
                }else{
                    NSUserDefaults.standardUserDefaults().setObject(modelid, forKey: "viewedVehicles")
                }
            })
            alert.addAction(action)
            let action2 = UIAlertAction(title: "Auto Loan Calculator", style: .Default, handler: { (alert) -> Void in
                self.selectedCarModelId = modelid
                self.selectedCarModelSRP = Int(self.carModelArr[indexPath.row].2)!
                self.selectedCarBrand = brand
                
                let x = Int(srp)!.stringFormattedWithSepator
                self.defaults.setObject(brand, forKey: "selectedCarBrand")
                self.defaults.setObject(modelid, forKey: "selectedCarModelId")
                self.defaults.setObject(x, forKey: "selectedCarModelSRP")
                
                //SAVE SELECTED TO RECENTLY VIEWED ITEM
                let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
                if (userDefaults.objectForKey("viewedVehicles") != nil) {
                    let s = NSUserDefaults.standardUserDefaults().valueForKey("viewedVehicles") as! String
                    
                    let arr = s.characters.split{$0 == ","}.map(String.init)
                    var selectedModelId_viewed = false
                    for(mId) in arr{
                        if(mId == modelid){
                            selectedModelId_viewed = true
                        }
                    }
                    if(!selectedModelId_viewed){
                        NSUserDefaults.standardUserDefaults().setObject(s + "," + modelid, forKey: "viewedVehicles")
                    }
                }else{
                    NSUserDefaults.standardUserDefaults().setObject(modelid, forKey: "viewedVehicles")
                }
                
                self.defaults.setObject("ShowCalculateAutoLoan", forKey: "vcAction")
                
                self.performSegueWithIdentifier("ShowCalculateAutoLoan", sender: self)
            })
            alert.addAction(action2)
            
            /*
            let action3 = UIAlertAction(title: "Apply for Auto Loan", style: .Default, handler: { (alert) -> Void in
                self.selectedCarModelId = modelid
                self.selectedCarModelSRP = Int(self.carModelArr[indexPath.row].2)!
                self.selectedCarBrand = brand
                
                let x = Int(srp)!.stringFormattedWithSepator
                self.defaults.setObject(brand, forKey: "selectedCarBrand")
                self.defaults.setObject(modelid, forKey: "selectedCarModelId")
                self.defaults.setObject(x, forKey: "selectedCarModelSRP")
                
                //SAVE SELECTED TO RECENTLY VIEWED ITEM
                let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
                if (userDefaults.objectForKey("viewedVehicles") != nil) {
                    let s = NSUserDefaults.standardUserDefaults().valueForKey("viewedVehicles") as! String
                    
                    let arr = s.characters.split{$0 == ","}.map(String.init)
                    var selectedModelId_viewed = false
                    for(mId) in arr{
                        if(mId == modelid){
                            selectedModelId_viewed = true
                        }
                    }
                    if(!selectedModelId_viewed){
                        NSUserDefaults.standardUserDefaults().setObject(s + "," + modelid, forKey: "viewedVehicles")
                    }
                }else{
                    NSUserDefaults.standardUserDefaults().setObject(modelid, forKey: "viewedVehicles")
                }
                
                //self.performSegueWithIdentifier("ApplyLoanDirect", sender: self)
                
            })
            alert.addAction(action3)
            */
 
            let action4 = UIAlertAction(title: "Cancel", style: .Default, handler: { (alert) -> Void in
                //nothing
            })
            alert.addAction(action4)
            
            /*
            let action4 = UIAlertAction(title: "Inquire Now", style: .Default, handler: { (alert) -> Void in
            self.selectedCarModelId = modelid
            self.performSegueWithIdentifier("Inquire", sender: self)
            })
            alert.addAction(action4)
            */
            
            presentViewController(alert, animated: true, completion: nil)
        }
        
        if(rootVC == "autoApplication" && vcAction == "ShowCarModelList") {
            selectedCarModelId = currentCell.textLabel!.text!
            let (modelid, _, srp, brand) = self.carModelArr[indexPath.row]
            let x = Int(srp)!.stringFormattedWithSepator
            self.defaults.setObject(brand, forKey: "selectedCarBrand")
            self.defaults.setObject(modelid, forKey: "selectedCarModelId")
            self.defaults.setObject(selectedCarModelId, forKey: "selectedCarModel")
            self.defaults.setObject(x, forKey: "selectedCarModelSRP")
        }
        
        if(vcAction == "ShowCardTypeList" || vcAction == "CardCategoryTravel" || vcAction == "CardCategoryCashBack"){
            selectedCarModelId = currentCell.textLabel!.text!
            let (id, name, _, desc, category) = self.cardTypeArr[indexPath.row]
            
            let alert = UIAlertController(title: "Options for", message: name, preferredStyle: .ActionSheet)
            let action = UIAlertAction(title: "View Card Details", style: .Default, handler: { (alert) -> Void in
                
                let alert_ = UIAlertController(title: "Card Details", message: "Name : " + name + "\r\n" + "Category : " + category + "\r\n" + "Description : " + desc, preferredStyle: .ActionSheet)
                let action_ = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                })
                alert_.addAction(action_)
                self.presentViewController(alert_, animated: true, completion: nil)
                
            })
            alert.addAction(action)
            
            let action3 = UIAlertAction(title: "Apply for Credit Card", style: .Default, handler: { (alert) -> Void in
                self.selectedCardType = id
                self.selectedCardTypeName = name
                self.performSegueWithIdentifier("ApplyCreditCard", sender: self)
                
            })
            alert.addAction(action3)
            
            /*let action4 = UIAlertAction(title: "Inquire Now", style: .Default, handler: { (alert) -> Void in
                self.selectedCardType = id
                self.performSegueWithIdentifier("Inquiry", sender: self)
            })
            alert.addAction(action4)*/
            
            let action5 = UIAlertAction(title: "Cancel", style: .Default, handler: { (alert) -> Void in
                //nothing
            })
            alert.addAction(action5)
            
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if(vcAction == "ShowCarModelList" || vcAction == "ShowRecentlyViewedCarModel"){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        } else if(vcAction == "ShowCardTypeList" || vcAction == "CardCategoryTravel" || vcAction == "CardCategoryCashBack"){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }
        
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "ShowAutoLoanCalculator")
        {
            if let destinationVC = segue.destinationViewController as? AutoTableViewController{
                destinationVC.vcAction = "ShowAutoLoanCalculator"
            }
        }
        
        if (segue.identifier == "ShowCalculateAutoLoan")
        {
            if let destinationVC = segue.destinationViewController as? AutoTableViewController{
                destinationVC.vcAction = "ShowCalculateAutoLoan"
            }
        }
        
        if (segue.identifier == "ApplyLoanDirect")
        {
            if let destinationVC = segue.destinationViewController as? AutoTableViewController{
                destinationVC.vcAction = "ApplyLoanDirect"
            }
        }
    }
}

