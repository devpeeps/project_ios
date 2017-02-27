//
//  DropdownTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 07/11/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit
import CoreData

class DropdownTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var urlLib = ""
    var vcAction = ""
    var rootVC = ""
    var passedValue = ""
    var withConnection = false
    var cardCategoryArr = [("","")]
    var carBrandArr = [("","")]
    var carModelArr = [("","","","")]
    var emptypeArr = [("","")]
    var positionArr = [("","")]
    var provinceArr = [("","")]
    var cityArr = [("","Choose City","")]
    var occupationgroupArr = [("1","EXECUTIVE"), ("2","MANAGER AND OFFICER"), ("3","STAFF/CLERK"), ("4","BUSINESS OWNER"), ("5","OTHERS") ]
    var downpaymentArrAuto = [10,20,30,40,50,60,70,80,90]
    var carTermsArr = [60,48,36,24,18,12]
    var civilStatusArr = [("S","Single"),("M","Married"),("W","Widow/er")]
    var salutationArr = [("MR","Mr"),("MS","Ms"),("MRS","Mrs")]
    var industryArr = [("","")]
    var bankArr = [("","")]
    
    
    var selectedCarBrand = ""
    var selectedCarBrandID = ""
    var selectedCarModelId = ""
    var selectedCarModelSRP = 0
    var selectedTerm = "60"
    var selectedDP = ""
    var selectedIncomeType = ""
    var selectedSPIncomeType = ""
    var selectedSPIncomeTypeID = ""
    var selectedC1IncomeType = ""
    var selectedC1IncomeTypeID = ""
    var selectedC2IncomeType = ""
    var selectedC2IncomeTypeID = ""
    var selectedOccupation = ""
    var selectedOccupationID = ""
    var selectedSPOccupation = ""
    var selectedSPOccupationID = ""
    var selectedC1Occupation = ""
    var selectedC1OccupationID = ""
    var selectedC2Occupation = ""
    var selectedC2OccupationID = ""
    var selectedCivilStatus = ""
    var selectedCivilStatusCode = ""
    var selectedC1CivilStatus = ""
    var selectedC1CivilStatusCode = ""
    var selectedC2CivilStatus = ""
    var selectedC2CivilStatusCode = ""
    var selectedCardCategory = ""
    var selectedCardType = ""
    var selectedCardTypeName = ""
    var selectedSalutation = ""
    var selectedSalutationCode = ""
    var selectedC1Salutation = ""
    var selectedC2Salutation = ""
    var selectedProvince = ""
    var selectedProvinceCode = ""
    var selectedProvinceBiz = ""
    var selectedProvinceBizCode = ""
    var selectedCity = ""
    var selectedCityCode = ""
    var selectedCityBiz = ""
    var selectedCityBizCode = ""
    var selectedOccupationGrpup = ""
    var selectedOccupationGroupCode = ""
    var selectedIndustry = ""
    var selectedIndustryCode = ""
    var selectedBank = ""
    var selectedBankCode = ""
    
    
    
    
    
    @IBOutlet var tableViewCardCategory: UITableView!
    @IBOutlet var tableViewDropdown: UITableView!
    @IBOutlet var tableViewDropdown2: UITableView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var tableViewDropdown3: UITableView!
    
    let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        if(vcAction == "ShowCarBrandList" || vcAction == "SelectCarBrandModel"){
            loadCarBrandList()
        }
        
        if(vcAction == "ShowDownpaymentPercentList"){
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
        }
        
        if(vcAction == "ShowCarTermList"){
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
        }
        
        if(vcAction == "ShowCivilStatusList" || vcAction == "ShowC1CivilStatusList" || vcAction == "ShowC2CivilStatusList"){
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
        }

        
        if(vcAction == "ShowSalutationList" || vcAction == "ShowC1SalutationList" || vcAction == "ShowC2SalutationList"){
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
        }
        
        
        if(vcAction == "ShowOccupationList" || vcAction == "ShowSPOccupationList" || vcAction == "ShowC1OccupationList" || vcAction == "ShowC2OccupationList"){
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            loadPosition()
        }

        
        if(vcAction == "ShowOccupationGroupList" || vcAction == "ShowOccupationGroupList" || vcAction == "ShowC1OccupationGroupList" || vcAction == "ShowC2OccupationGroupList"){
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
        }
        
        
        
        if(vcAction == "ShowIncomeType" || vcAction == "ShowSPIncomeType" || vcAction == "ShowC1IncomeType" || vcAction == "ShowC2IncomeType"){
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            loadEmpType()
        }
        
        if(vcAction == "ShowCardType"){
            loadCardCategoryList()
        }
        
        if(vcAction == "ShowProvinceList" || vcAction == "ShowBizProvinceList") {
            loadProvinceList()
        }

        if(vcAction == "ShowCityList" || vcAction == "ShowBizCityList") {
        let provinceId = defaults.stringForKey("selectedProvinceCode")
            //NSLog("selectedProvince: " + String(provinceId))
            loadCityList(provinceId!)
        }
        
        if(vcAction == "ShowIndustryList") {
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            loadIndustryList()
        }
        
        if(vcAction == "ShowBankList") {
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            loadBankList()
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    func showActivityIndicatory(uiView: UIView) {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.center = self.tableView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        uiView.addSubview(actInd)
        loadingIndicator.startAnimating()
    }
    
    func loadBankList(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "CATS-BANK")
        
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
                            self.bankArr.removeAll()
                            
                            for i in 0...str.count - 2{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[0] != ""){
                                    self.bankArr.append((str2[1], str2[0]))
                                    
                                }
                            }
                            
                            self.tableViewDropdown.reloadData()
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
                        self.view.userInteractionEnabled = true
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
            self.view.userInteractionEnabled = true
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Please try again.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)
                
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func loadIndustryList(){
        urlLib = NSLocalizedString("urlLib", comment: "")

        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "CATS-BUSINDUSTRY")
        
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
                            self.industryArr.removeAll()
                            
                            for i in 0...str.count - 2{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[0] != ""){
                                    self.industryArr.append((str2[1], str2[0]))
                                    
                                }
                            }
                            
                            self.tableViewDropdown.reloadData()
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
                        self.view.userInteractionEnabled = true
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
            self.view.userInteractionEnabled = true
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Please try again.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)

            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }

    
    
    func loadProvinceList(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "CATS-PROVINCE")
        
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
                            self.provinceArr.removeAll()
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[0] != ""){
                                    self.provinceArr.append((str2[1], str2[0]))
                                    
                                }
                            }
                 
                            
                            /*
                            self.province.reloadAllComponents()
                            self.empprovince.reloadAllComponents()
                            self.permprovince.reloadAllComponents()
                            */
                            
                            
                            self.tableViewDropdown.reloadData()
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
    
    
    
    
    
    
    
    func loadCityList(provinceId: String){
        
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        var urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "CATS-CITY")
        
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM1", withString: provinceId.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)
        NSLog("URL: " + String(urlAsString))
        

        
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
                            self.cityArr.removeAll()
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[0] != ""){
                                    self.cityArr.append((str2[1], str2[0], provinceId))
                                    
                                }
                            }
                     
                            self.tableViewDropdown.reloadData()
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
              
                
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    
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
                                    
                                    if(self.selectedCarBrand != ""){
                                        if(self.carBrandArr[i].0 == self.selectedCarBrand){
                                            self.selectedCarBrand = self.carBrandArr[i].0
                                        }
                                    }else{
                                        if(i == 0){
                                            self.selectedCarBrand = self.carBrandArr[i].0
                                        }
                                    }
                                }
                            }

                            self.tableViewDropdown.reloadData()
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
    
    func loadEmpType(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "EMPTYPE")
        
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
                            self.emptypeArr.removeAll()
                            for i in 1...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[1] != ""){
                                    self.emptypeArr.append((str2[1], str2[0]))
                                }
                            }
                            
                            self.tableViewDropdown2.reloadData()
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
                        self.view.userInteractionEnabled = true
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
            self.view.userInteractionEnabled = true
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Please try again.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func loadPosition(){
        urlLib = NSLocalizedString("urlLib", comment: "")

        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "JOBPOS")
        
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
                            self.positionArr.removeAll()
                            for i in 0...str.count - 1{
                                
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[1] != ""){
                                    self.positionArr.append((str2[1], str2[0]))
                                }
                            }
                            self.tableViewDropdown.reloadData()
                            
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
                        self.view.userInteractionEnabled = true
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
            self.view.userInteractionEnabled = true
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Please try again.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func loadCardCategoryList(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "CARD_CATEGORY")
        
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
                            self.cardCategoryArr.removeAll()
                            for i in 0...str.count - 1{
                                if(str[i] != ""){
                                    self.cardCategoryArr.append((str[i], str[i]))
                                }
                            }
                            self.tableViewCardCategory.reloadData()
                            
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
        
        if(vcAction == "ShowCarBrandList" || vcAction == "SelectCarBrandModel"){
            itemCount = carBrandArr.count
        }
        else if(vcAction == "ShowDownpaymentPercentList"){
            itemCount = downpaymentArrAuto.count
        }
        else if(vcAction == "ShowCarTermList"){
            itemCount = carTermsArr.count
        }
        else if(vcAction == "ShowOccupationList" || vcAction == "ShowSPOccupationList" || vcAction == "ShowC1OccupationList" || vcAction == "ShowC2OccupationList"){
            itemCount = positionArr.count
        }
            
        else if(vcAction == "ShowOccupationGroupList" || vcAction == "ShowC1OccupationGroupList" || vcAction == "ShowC2OccupationGroupList"){
            itemCount = occupationgroupArr.count
        }
        else if(vcAction == "ShowIncomeType" || vcAction == "ShowSPIncomeType" || vcAction == "ShowC1IncomeType" || vcAction == "ShowC2IncomeType"){
            itemCount = emptypeArr.count
        }
        else if(vcAction == "ShowCardType"){
            itemCount = cardCategoryArr.count
        }
        else if(vcAction == "ShowCivilStatusList" || vcAction == "ShowC1CivilStatusList" || vcAction == "ShowC2CivilStatusList"){
            itemCount = civilStatusArr.count
        }
        else if(vcAction == "ShowSalutationList" || vcAction == "ShowC1SalutationList" || vcAction == "ShowC2SalutationList"){
            itemCount = salutationArr.count
        }
        
        else if(vcAction == "ShowProvinceList" || vcAction == "ShowBizProvinceList" || vcAction == "ShowC2ProvinceList"){
            itemCount = provinceArr.count
        }
        
        else if(vcAction == "ShowCityList" || vcAction == "ShowBizCityList" || vcAction == "ShowC2CityList"){
            itemCount = cityArr.count
        }
        
        else if(vcAction == "ShowIndustryList"){
            itemCount = industryArr.count
        }
        else if(vcAction == "ShowBankList"){
            itemCount = bankArr.count
        }
        
        return itemCount
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var dropdownName = ""
        
        if(vcAction == "ShowCarBrandList" || vcAction == "SelectCarBrandModel"){
            dropdownName = "Choose Car Brand"
        }
        else if(vcAction == "ShowDownpaymentPercentList"){
            dropdownName = "Select Downpayment %"
        }
        else if(vcAction == "ShowCarTermList"){
            dropdownName = "Select Car Term (in Months)"
        }
        else if(vcAction == "ShowOccupationList" || vcAction == "ShowSPOccupationList" || vcAction == "ShowC1OccupationList" || vcAction == "ShowC2OccupationList"){
            dropdownName = "Select Occupation"
        }
        
        else if(vcAction == "ShowOccupationGroupList" || vcAction == "ShowC1OccupationGroupList" || vcAction == "ShowC2OccupationGroupList"){
            dropdownName = "Select Occupation Group"
        }
            
        else if(vcAction == "ShowIncomeType" || vcAction == "ShowSPIncomeType" || vcAction == "ShowC1IncomeType" || vcAction == "ShowC2IncomeType"){
            dropdownName = "Select Source of Income Type"
        }
        else if(vcAction == "ShowCardType"){
            dropdownName = "Choose Card Category"
        }
        else if(vcAction == "ShowCivilStatusList" || vcAction == "ShowC1CivilStatusList" || vcAction == "ShowC2CivilStatusList"){
            dropdownName = "Select Civil Status"
        }
        else if(vcAction == "ShowProvinceList" || vcAction == "ShowBizProvinceList" || vcAction == "ShowC2ProvinceList"){
            dropdownName = "Select Province"
        }
        else if(vcAction == "ShowCityList" || vcAction == "ShowBizCityList" || vcAction == "ShowC2CityList"){
            dropdownName = "Select City"
        }
        else if(vcAction == "ShowIndustryList"){
            dropdownName = "Choose Business/Employment Industry"
        }
        
        else if(vcAction == "ShowBankList"){
            dropdownName = "Choose Bank"
        }
    
        return dropdownName
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let listcell = tableView.dequeueReusableCellWithIdentifier("listcell", forIndexPath: indexPath) as UITableViewCell
        
        if(vcAction == "ShowCarBrandList" || vcAction == "SelectCarBrandModel"){
            let (id_carBrand, carBrand) = self.carBrandArr[indexPath.row]
            
            if(id_carBrand != ""){
                listcell.textLabel!.text = carBrand
            }else{
                listcell.textLabel!.text = ""
            }
        }
        else if(vcAction == "ShowDownpaymentPercentList"){
            let downpayment = self.downpaymentArrAuto[indexPath.row]
            
            if(downpayment != 0){
                listcell.textLabel?.text = String(downpayment)
            }else{
                listcell.textLabel!.text = ""
            }
        }
        else if(vcAction == "ShowCarTermList"){
            let carTerm = self.carTermsArr[indexPath.row]
            
            if(carTerm != 0){
                listcell.textLabel?.text = String(carTerm)
            }else{
                listcell.textLabel!.text = ""
            }
        }
        else if(vcAction == "ShowOccupationList" || vcAction == "ShowSPOccupationList" || vcAction == "ShowC1OccupationList" || vcAction == "ShowC2OccupationList"){
            let (id_position, position) = self.positionArr[indexPath.row]
            
            if(Int(id_position) != 0){
                listcell.textLabel?.text = position
            }else{
                listcell.textLabel!.text = ""
            }
        }
        else if(vcAction == "ShowIncomeType" || vcAction == "ShowSPIncomeType" || vcAction == "ShowC1IncomeType" || vcAction == "ShowC2IncomeType"){
            let (id_empType, empType) = self.emptypeArr[indexPath.row]
            
            if(Int(id_empType) != 0){
                listcell.textLabel?.text = empType
            }else{
                listcell.textLabel!.text = ""
            }
        }
        else if(vcAction == "ShowCardType"){
            let (id_cardCategory, cardCategory) = self.cardCategoryArr[indexPath.row]
            
            if(Int(id_cardCategory) != 0){
                listcell.textLabel?.text = cardCategory
                var imageView = UIImage(named: "")
                switch(cardCategory){
                    case "Rewards": imageView = UIImage(named: "tmb_rewards")
                        break;
                    case "Cash Back": imageView = UIImage(named: "tmb_cashback")
                        break;
                    case "Travel": imageView = UIImage(named: "tmb_travel")
                        break;
                    case "Lifestyle": imageView = UIImage(named: "tmb_shop")
                        break;
                    case "Affinity": imageView = UIImage(named: "tmb_school")
                        break;
                    case "Business": imageView = UIImage(named: "tmb_business")
                        break;
                    case "Gas/Auto": imageView = UIImage(named: "tmb_gasauto")
                        break;
                    case "Charity": imageView = UIImage(named: "tmb_charity")
                        break;
                    case "Promo": imageView = UIImage(named: "tmb_promo")
                        break;
                    default:
                        break;
                }
                listcell.imageView!.image = imageView
            }else{
                listcell.textLabel!.text = ""
            }
        }
        else if(vcAction == "ShowCivilStatusList" || vcAction == "ShowC1CivilStatusList" || vcAction == "ShowC2CivilStatusList"){
            let (id_civilStat, civilStat) = self.civilStatusArr[indexPath.row]
            
            if(id_civilStat != ""){
                listcell.textLabel?.text = civilStat
            }else{
                listcell.textLabel!.text = ""
            }
        }
        
        else if(vcAction == "ShowSalutationList" || vcAction == "ShowC1SalutationList" || vcAction == "ShowC2SalutationList" ){
            let (id_salutationCode, salutationCode) = self.salutationArr[indexPath.row]
            
            if(id_salutationCode != ""){
                listcell.textLabel?.text = salutationCode
            }else{
                listcell.textLabel!.text = ""
            }
        }
            
        else if(vcAction == "ShowOccupationGroupList" || vcAction == "ShowC1OccupationGroupList" || vcAction == "ShowC2OccupationGroupList" ){
            let (id_occupationGroupCode, occupationGroupCode) = self.occupationgroupArr[indexPath.row]
            
            if(id_occupationGroupCode != ""){
                listcell.textLabel?.text = occupationGroupCode
            }else{
                listcell.textLabel!.text = ""
            }
        }

        else if(vcAction == "ShowProvinceList" || vcAction == "ShowBizProvinceList" || vcAction == "ShowC2ProvinceList" ){
            let (id_provinceCode, provinceCode) = self.provinceArr[indexPath.row]
            
            if(id_provinceCode != ""){
                listcell.textLabel?.text = provinceCode
            }else{
                listcell.textLabel!.text = ""
            }
        }

        else if(vcAction == "ShowCityList" || vcAction == "ShowBizCityList" || vcAction == "ShowC2CityList" ){
            let (id_cityCode, cityCode, provinceCode) = self.cityArr[indexPath.row]
            
            if(id_cityCode != ""){
                listcell.textLabel?.text = cityCode
            }else{
                listcell.textLabel!.text = ""
            }
        }
        
        else if(vcAction == "ShowIndustryList" ){
            let (id_industryCode, industryCode) = self.industryArr[indexPath.row]
            
            if(id_industryCode != ""){
                listcell.textLabel?.text = industryCode
            }else{
                listcell.textLabel!.text = ""
            }
        }
        
        else if(vcAction == "ShowBankList" ){
            let (id_bankCode, bankCode) = self.bankArr[indexPath.row]
            
            if(id_bankCode != ""){
                listcell.textLabel?.text = bankCode
            }else{
                listcell.textLabel!.text = ""
            }
        }
        
        return listcell
    }
    
    
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //let indexPath = tableView.indexPathForSelectedRow! //optional, to get from any UIButton for example
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        if(vcAction == "ShowDownpaymentPercentList"){
            selectedDP = currentCell.textLabel!.text!
            defaults.setObject(currentCell.textLabel!.text!, forKey: "selectedDP")
        }
        
        if(vcAction == "ShowCarTermList"){
            selectedTerm = currentCell.textLabel!.text!
            defaults.setObject(currentCell.textLabel!.text!, forKey: "selectedTerm")
        }
        
        if(vcAction == "ShowCarBrandList" || vcAction == "SelectCarBrandModel"){
            let (id_carBrand, carBrand) = self.carBrandArr[indexPath.row]
            defaults.setObject(carBrand, forKey: "selectedCarBrand")
            defaults.setObject(id_carBrand, forKey: "selectedCarBrandID")
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        if(vcAction == "ShowOccupationList"){
            let (id_position, position) = self.positionArr[indexPath.row]
            defaults.setObject(position, forKey: "selectedOccupation")
            defaults.setObject(id_position, forKey: "selectedOccupationID")
        }
        
        if(vcAction == "ShowIncomeType"){
            let (id_emptype, emptype) = self.emptypeArr[indexPath.row]
            defaults.setObject(emptype, forKey: "selectedIncomeType")
            defaults.setObject(id_emptype, forKey: "selectedIncomeTypeID")
        }
        
        if(vcAction == "ShowSPOccupationList"){
            let (id_position, position) = self.positionArr[indexPath.row]
            defaults.setObject(position, forKey: "selectedSPOccupation")
            defaults.setObject(id_position, forKey: "selectedSPOccupationID")
        }
        
        if(vcAction == "ShowSPIncomeType"){
            let (id_emptype, emptype) = self.emptypeArr[indexPath.row]
            defaults.setObject(emptype, forKey: "selectedSPIncomeType")
            defaults.setObject(id_emptype, forKey: "selectedSPIncomeTypeID")
        }
        
        if(vcAction == "ShowC1OccupationList"){
            let (id_position, position) = self.positionArr[indexPath.row]
            defaults.setObject(position, forKey: "selectedC1Occupation")
            defaults.setObject(id_position, forKey: "selectedC1OccupationID")
        }
        
        if(vcAction == "ShowC1IncomeType"){
            let (id_emptype, emptype) = self.emptypeArr[indexPath.row]
            defaults.setObject(emptype, forKey: "selectedC1IncomeType")
            defaults.setObject(id_emptype, forKey: "selectedC1IncomeTypeID")
        }
        
        if(vcAction == "ShowC2OccupationList"){
            let (id_position, position) = self.positionArr[indexPath.row]
            defaults.setObject(position, forKey: "selectedC2Occupation")
            defaults.setObject(id_position, forKey: "selectedC2OccupationID")
        }
        
        if(vcAction == "ShowC2IncomeType"){
            let (id_emptype, emptype) = self.emptypeArr[indexPath.row]
            defaults.setObject(emptype, forKey: "selectedC2IncomeType")
            defaults.setObject(id_emptype, forKey: "selectedC2IncomeTypeID")
        }
        
        if(vcAction == "ShowCardType"){
            selectedCardCategory = currentCell.textLabel!.text!
            defaults.setObject(currentCell.textLabel!.text!, forKey: "selectedCardCategory")
        }
        
        if(vcAction == "ShowCivilStatusList"){
            let (id_civilStat, civilStat) = self.civilStatusArr[indexPath.row]
            defaults.setObject(civilStat, forKey: "selectedCivilStatus")
            defaults.setObject(id_civilStat, forKey: "selectedCivilStatusCode")
        }
        
        if(vcAction == "ShowC1CivilStatusList"){
            let (id_C1civilStat, C1civilStat) = self.civilStatusArr[indexPath.row]
            defaults.setObject(C1civilStat, forKey: "selectedC1CivilStatus")
            defaults.setObject(id_C1civilStat, forKey: "selectedC1CivilStatusCode")
        }
        
        if(vcAction == "ShowC2CivilStatusList"){
            let (id_C2civilStat, C2civilStat) = self.civilStatusArr[indexPath.row]
            defaults.setObject(C2civilStat, forKey: "selectedC2CivilStatus")
            defaults.setObject(id_C2civilStat, forKey: "selectedC2CivilStatusCode")
        }

        if(vcAction == "ShowSalutationList"){
            let (id_salutationCode, salutationCode) = self.salutationArr[indexPath.row]
            defaults.setObject(salutationCode, forKey: "selectedSalutation")
            defaults.setObject(id_salutationCode, forKey: "selectedSalutationCode")
        }

        if(vcAction == "ShowC1SalutationList"){
            let (id_C1salutationCode, C1salutationCode) = self.salutationArr[indexPath.row]
            defaults.setObject(C1salutationCode, forKey: "selectedC1Salutation")
            defaults.setObject(id_C1salutationCode, forKey: "selectedC1SalutationCode")
        }
        
        if(vcAction == "ShowC2SalutationList"){
            let (id_C2salutationCode, C2salutationCode) = self.salutationArr[indexPath.row]
            defaults.setObject(C2salutationCode, forKey: "selectedC2Salutation")
            defaults.setObject(id_C2salutationCode, forKey: "selectedC2SalutationCode")
        }
        
        if(vcAction == "ShowProvinceList"){
            let (id_provinceCode, provinceCode) = self.provinceArr[indexPath.row]
            defaults.setObject(provinceCode, forKey: "selectedProvince")
            defaults.setObject(id_provinceCode, forKey: "selectedProvinceCode")
        }

        if(vcAction == "ShowBizProvinceList"){
            let (id_bizProvinceCode, bizProvinceCode) = self.provinceArr[indexPath.row]
            defaults.setObject(bizProvinceCode, forKey: "selectedProvinceBiz")
            defaults.setObject(id_bizProvinceCode, forKey: "selectedProvinceBizCode")
        }
        
        if(vcAction == "ShowCityList"){
            let (id_cityCode, cityCode, provinceId) = self.cityArr[indexPath.row]
            defaults.setObject(cityCode, forKey: "selectedCity")
            defaults.setObject(id_cityCode, forKey: "selectedCityCode")
        }

        if(vcAction == "ShowBizCityList"){
            let (id_bizCityCode, bizCityCode, bizProvinceId) = self.cityArr[indexPath.row]
            defaults.setObject(bizCityCode, forKey: "selectedCityBiz")
            defaults.setObject(id_bizCityCode, forKey: "selectedCityBizCode")
        }
        
        if(vcAction == "ShowOccupationGroupList"){
            let (id_occupationGroup, occupationGroup) = self.occupationgroupArr[indexPath.row]
            defaults.setObject(occupationGroup, forKey: "selectedOccupationGroup")
            defaults.setObject(id_occupationGroup, forKey: "selectedOccupationGroupCode")
        }
        
        if(vcAction == "ShowIndustryList"){
            let (id_industryCode, industryCode) = self.industryArr[indexPath.row]
            defaults.setObject(industryCode, forKey: "selectedIndustry")
            defaults.setObject(id_industryCode, forKey: "selectedIndustryCode")
        }
        
        if(vcAction == "ShowBankList"){
            let (id_bankCode, bankCode) = self.bankArr[indexPath.row]
            defaults.setObject(bankCode, forKey: "selectedBank")
            defaults.setObject(id_bankCode, forKey: "selectedBankCode")
        }
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if(vcAction == "ShowDownpaymentPercentList"){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }
        
        if(vcAction == "ShowCarTermList"){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }
        
        if(vcAction == "ShowOccupationList" || vcAction == "ShowSPOccupationList" || vcAction == "ShowC1OccupationList" || vcAction == "ShowC2OccupationList"){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }
        
        if(vcAction == "ShowOccupationGroupList" || vcAction == "ShowC1OccupationGroupList" || vcAction == "ShowC2OccupationGroupList"){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }
        
        if(vcAction == "ShowIncomeType" || vcAction == "ShowSPIncomeType" || vcAction == "ShowC1IncomeType" || vcAction == "ShowC2IncomeType"){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }
        
        if(vcAction == "ShowCivilStatusList" || vcAction == "ShowC1CivilStatusList" || vcAction == "ShowC2CivilStatusList"){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }
        
        if(vcAction == "ShowSalutationList" || vcAction == "ShowC1SalutationList" || vcAction == "ShowC2SalutationList"){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }
        
        if(vcAction == "ShowIndustryList" ){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }
        
        if(vcAction == "ShowBankList" ){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }

        if(vcAction == "ShowProvinceList" || vcAction == "ShowBizProvinceList" || vcAction == "ShowC2ProvinceList"){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }

        
        if(vcAction == "ShowCityList" || vcAction == "ShowBizCityList" || vcAction == "ShowC2CityList"){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDownpaymentPercentList"
        {
            if let destinationVC = segue.destinationViewController as? AutoTableViewController{
                destinationVC.vcAction = "ShowDownpaymentPercentList"
            }
        }
        
        if segue.identifier == "ShowCarModelList"
        {
            if let destinationVC = segue.destinationViewController as? ListTableViewController{
                destinationVC.vcAction = "ShowCarModelList"
                
                if(vcAction == "ShowCarBrandList"){
                    destinationVC.rootVC = "autoMainMenu"
                }
                
                if(vcAction == "SelectCarBrandModel"){
                    destinationVC.rootVC = "autoApplication"
                }
            }
        }
        
        if segue.identifier == "ShowCardTypeList"
        {
            if let destinationVC = segue.destinationViewController as? ListTableViewController{
                destinationVC.vcAction = "ShowCardTypeList"
            }
        }

        if segue.identifier == "ShowProvinceList"
        {
            if let destinationVC = segue.destinationViewController as? ListTableViewController{
                destinationVC.vcAction = "ShowProvinceList"
            }
        }

        if segue.identifier == "ShowBizProvinceList"
        {
            if let destinationVC = segue.destinationViewController as? ListTableViewController{
                destinationVC.vcAction = "ShowProvinceList"
            }
        }
        
        if segue.identifier == "ShowCityList"
        {
            if let destinationVC = segue.destinationViewController as? ListTableViewController{
                destinationVC.vcAction = "ShowCityList"
            }
        }
        
        if segue.identifier == "ShowBizCityList"
        {
            if let destinationVC = segue.destinationViewController as? ListTableViewController{
                destinationVC.vcAction = "ShowBizCityList"
            }
        }
        
        if segue.identifier == "ShowIndustryList"
        {
            if let destinationVC = segue.destinationViewController as? ListTableViewController{
                destinationVC.vcAction = "ShowIndustryList"
            }
        }
        
        if segue.identifier == "ShowOccupationList"
        {
            if let destinationVC = segue.destinationViewController as? ListTableViewController{
                destinationVC.vcAction = "ShowOccupationList"
            }
        }
        
        if segue.identifier == "ShowBankList"
        {
            if let destinationVC = segue.destinationViewController as? ListTableViewController{
                destinationVC.vcAction = "ShowBankList"
            }
        }
    }
}

