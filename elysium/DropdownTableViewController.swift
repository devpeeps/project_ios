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
    var selectedCarBrand = ""
    var selectedCarBrandID = ""
    var downpaymentArrAuto = [10,20,30,40,50,60,70,80,90]
    var downpaymentArrHome = [10,20,30,40,50,60,70,80,90]
    var carTermsArr = [60,48,36,24,18,12]
    var homeTermsArr = [20,19,18,17,16,15,14,12,11,10,9,8,7,6,5,4,3,2,1]
    var propertytypeArr = [("","")]
    var provinceArr = [("","")]
    var cityArr = [("","","")]
    var occupationgroupArr = [("1","EXECUTIVE"), ("2","MANAGER AND OFFICER"), ("3","STAFF/CLERK"), ("4","BUSINESS OWNER"), ("5","OTHERS") ]
    var civilStatusArr = [("S","Single"),("M","Married"),("W","Widow/er")]
    var salutationArr = [("MR","Mr"),("MS","Ms"),("MRS","Mrs")]
    var homeownershipArr = [
        ("0", "OWNED/NOT MORTGAGED"),("1","OWNED/MORTGAGED"), ("2", "LIVING WITH PARENTS"), ("3", "RENTED"), ("4","USED FOR FREE/OTHERS") ]
    var sourceFundsArr = [("1","Business Income"), ("2","Rental Income"), ("3","Investment"), ("4","Personal Savings"), ("5","Salary"), ("6","Inheritance"), ("7","Sales of Property"), ("8","Pension"), ("9","Others")]
    var industryArr = [("","")]
    var bankArr = [("","")]
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
    var emptypeArr = [("","")]
    var positionArr = [("","")]
    var selectedPropertyType = ""
    var selectedProvince = ""
    var selectedProvinceID = ""
    var selectedCity = ""
    var selectedCityID = ""
    
    var selectedProvince_present = ""
    var selectedProvinceID_present = ""
    var selectedCity_present = ""
    var selectedCityID_present = ""
    
    var selectedProvince_permanent = ""
    var selectedProvinceID_permanent = ""
    var selectedCity_permanent = ""
    var selectedCityID_permanent = ""
    
    var selectedProvinceBiz = ""
    var selectedProvinceBizCode = ""
    var selectedCityBiz = ""
    var selectedCityBizCode = ""
    
    var selectedOccupationGroup = ""
    var selectedOccupationGroupCode = ""
    var selectedIndustry = ""
    var selectedIndustryCode = ""
    var selectedBank = ""
    var selectedBankCode = ""
    
    @IBOutlet var tableViewCardCategory: UITableView!
    @IBOutlet var tableViewDropdown: UITableView!
    @IBOutlet var tableViewDropdown2: UITableView!
    @IBOutlet var tableViewDropdownPropertyType: UITableView!
    @IBOutlet var tableViewDropdownProvince: UITableView!
    @IBOutlet var tableViewDropdownCity: UITableView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
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
        
        if(vcAction == "ShowCarTermList" || vcAction == "ShowHomeTermList" || vcAction == "ShowTermList"){
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
        }
        
        if(vcAction == "ShowSalutationList" || vcAction == "ShowC1SalutationList" || vcAction == "ShowC2SalutationList"){
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
        }
        
        if(vcAction == "ShowCivilStatusList" || vcAction == "ShowC1CivilStatusList" || vcAction == "ShowC2CivilStatusList"){
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
        }
        
        if(vcAction == "ShowOccupationList" || vcAction == "ShowSPOccupationList" || vcAction == "ShowC1OccupationList" || vcAction == "ShowC2OccupationList"){
            loadPosition()
        }
        
        if(vcAction == "ShowOccupationGroupList" || vcAction == "ShowOccupationGroupList" || vcAction == "ShowC1OccupationGroupList" || vcAction == "ShowC2OccupationGroupList"){
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
        }
        
        if(vcAction == "ShowIncomeType" || vcAction == "ShowSPIncomeType" || vcAction == "ShowC1IncomeType" || vcAction == "ShowC2IncomeType"){
            loadEmpType()
        }
        
        if(vcAction == "ShowCardType"){
            loadCardCategoryList()
        }
        
        if(vcAction == "ShowPropertyType"){
            loadPropertyTypeList()
        }
        
        if(vcAction == "ShowProvinceList" || vcAction == "ShowProvinceList_present" || vcAction == "ShowProvinceList_permanent" || vcAction == "ShowBizProvinceList"){
            loadProvinceList()
        }
        
        if(vcAction == "ShowCityList"){
            if let provinceID = defaults.stringForKey("selectedProvinceID") {
                selectedProvinceID = provinceID
            }
            loadCityList(selectedProvinceID)
        }
        
        if(vcAction == "ShowCityList_present"){
            if let provinceID_present = defaults.stringForKey("selectedProvinceID_present") {
                selectedProvinceID_present = provinceID_present
            }
            loadCityList(selectedProvinceID_present)
        }
        
        if(vcAction == "ShowCityList_permanent"){
            if let provinceID_permanent = defaults.stringForKey("selectedProvinceID_permanent") {
                selectedProvinceID_permanent = provinceID_permanent
            }
            loadCityList(selectedProvinceID_permanent)
        }
        
        if(vcAction == "ShowBizCityList"){
            if let provinceBizCode = defaults.stringForKey("selectedProvinceBizCode") {
                selectedProvinceBizCode = provinceBizCode
            }
            loadCityList(selectedProvinceBizCode)
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
        
        if(vcAction == "ShowHomeOwnershipList") {
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
        }
        
        if(vcAction == "ShowSourceOfFundList") {
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        //self.view.userInteractionEnabled = false
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
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
    
    func loadPropertyTypeList(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "PROPTYPE")
        
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
                            self.propertytypeArr.removeAll()
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[1] != ""){
                                    self.propertytypeArr.append((str2[1], str2[0]))
                                }
                            }
                            self.tableViewDropdownPropertyType.reloadData()
                            
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
    
    func loadProvinceList(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "PROVINCE")
        
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
                                if(str2[1] != ""){
                                    self.provinceArr.append((str2[1], str2[0]))
                                }
                            }
                            self.tableViewDropdownProvince.reloadData()
                            
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
        if(provinceId != ""){
            
            urlLib = NSLocalizedString("urlLib", comment: "")
            self.view.userInteractionEnabled = false
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            var urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "CITY")
            urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM1", withString: provinceId.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)
            
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
                                    if(str2[1] != ""){
                                        self.cityArr.append((str2[1], str2[0], provinceId))
                                    }
                                }
                                self.tableViewDropdownCity.reloadData()
                                
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
        else if(vcAction == "ShowHomeTermList"){
            itemCount = homeTermsArr.count
        }
        else if(vcAction == "ShowPropertyType"){
            itemCount = propertytypeArr.count
        }
        else if(vcAction == "ShowProvinceList" || vcAction == "ShowProvinceList_present" || vcAction == "ShowProvinceList_permanent" || vcAction == "ShowBizProvinceList"){
            itemCount = provinceArr.count
        }
        else if(vcAction == "ShowCityList" || vcAction == "ShowCityList_present" || vcAction == "ShowCityList_permanent" || vcAction == "ShowBizCityList"){
            itemCount = cityArr.count
        }
        else if(vcAction == "ShowOccupationList" || vcAction == "ShowSPOccupationList" || vcAction == "ShowC1OccupationList" || vcAction == "ShowC2OccupationList"){
            itemCount = positionArr.count
        }
        else if(vcAction == "ShowOccupationGroupList" || vcAction == "ShowC1OccupationGroupList" || vcAction == "ShowC2OccupationGroupList"){
            itemCount = occupationgroupArr.count
        }
        else if(vcAction == "ShowIndustryList"){
            itemCount = industryArr.count
        }
        else if(vcAction == "ShowBankList"){
            itemCount = bankArr.count
        }
        else if(vcAction == "ShowHomeOwnershipList"){
            itemCount = homeownershipArr.count
        }
        else if(vcAction == "ShowSourceOfFundList"){
            itemCount = sourceFundsArr.count
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
        else if(vcAction == "ShowHomeTermList"){
            dropdownName = "Select Home Term (in Months)"
        }
        else if(vcAction == "ShowPropertyType"){
            dropdownName = "Select Property Type"
        }
        else if(vcAction == "ShowProvinceList" || vcAction == "ShowProvinceList_present" || vcAction == "ShowProvinceList_permanent" || vcAction == "ShowBizProvinceList"){
            dropdownName = "Select Province"
        }
        else if(vcAction == "ShowCityList" || vcAction == "ShowCityList_present" || vcAction == "ShowCityList_permanent" || vcAction == "ShowBizCityList"){
            dropdownName = "Select City"
        }
        else if(vcAction == "ShowOccupationList" || vcAction == "ShowSPOccupationList" || vcAction == "ShowC1OccupationList" || vcAction == "ShowC2OccupationList"){
            dropdownName = "Select Occupation"
        }
        else if(vcAction == "ShowOccupationGroupList" || vcAction == "ShowC1OccupationGroupList" || vcAction == "ShowC2OccupationGroupList"){
            dropdownName = "Select Occupation Group"
        }
        else if(vcAction == "ShowIndustryList"){
            dropdownName = "Choose Business/Employment Industry"
        }
        else if(vcAction == "ShowBankList"){
            dropdownName = "Choose Bank"
        }
        else if(vcAction == "ShowHomeOwnershipList"){
            dropdownName = "Select Home Ownership"
        }
        else if(vcAction == "ShowSourceOfFundList"){
            dropdownName = "Select Source Of Fund"
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
        else if(vcAction == "ShowSalutationList" || vcAction == "ShowC1SalutationList" || vcAction == "ShowC2SalutationList"){
            dropdownName = "Select Salutation"
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
        else if(vcAction == "ShowHomeTermList"){
            let homeTerm = self.homeTermsArr[indexPath.row]
            
            if(homeTerm != 0){
                listcell.textLabel?.text = String(homeTerm)
            }else{
                listcell.textLabel!.text = ""
            }
        }
        else if(vcAction == "ShowPropertyType"){
            let (id_propertyType, propertyType) = self.propertytypeArr[indexPath.row]
            
            if(Int(id_propertyType) != 0){
                listcell.textLabel?.text = String(propertyType)
            }else{
                listcell.textLabel!.text = ""
            }
        }
        else if(vcAction == "ShowProvinceList" || vcAction == "ShowProvinceList_present" || vcAction == "ShowProvinceList_permanent" || vcAction == "ShowBizProvinceList"){
            let (id_province, province) = self.provinceArr[indexPath.row]
            
            if(Int(id_province) != 0){
                listcell.textLabel?.text = String(province)
            }else{
                listcell.textLabel!.text = ""
            }
        }
        else if(vcAction == "ShowCityList" || vcAction == "ShowCityList_present" || vcAction == "ShowCityList_permanent" || vcAction == "ShowBizCityList"){
            let (id_city, city, id_province) = self.cityArr[indexPath.row]
            
            if(Int(id_city) != 0 && Int(id_province) != 0){
                listcell.textLabel?.text = String(city)
            }else{
                listcell.textLabel?.text = ""
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
        else if(vcAction == "ShowOccupationGroupList" || vcAction == "ShowC1OccupationGroupList" || vcAction == "ShowC2OccupationGroupList" ){
            let (id_occupationGroupCode, occupationGroupCode) = self.occupationgroupArr[indexPath.row]
            
            if(id_occupationGroupCode != ""){
                listcell.textLabel?.text = occupationGroupCode
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
        else if(vcAction == "ShowHomeOwnershipList"){
            let (id_homeownership, homeownership) = self.homeownershipArr[indexPath.row]
            
            if(id_homeownership != ""){
                listcell.textLabel?.text = homeownership
            }else{
                listcell.textLabel!.text = ""
            }
        }
        else if(vcAction == "ShowSourceOfFundList"){
            let (id_sourceoffund, sourceoffund) = self.sourceFundsArr[indexPath.row]
            
            if(id_sourceoffund != ""){
                listcell.textLabel?.text = sourceoffund
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
        
        if(vcAction == "ShowHomeTermList"){
            selectedTerm = currentCell.textLabel!.text!
            defaults.setObject(currentCell.textLabel!.text!, forKey: "selectedTerm")
        }
        
        if(vcAction == "ShowPropertyType"){
            selectedPropertyType = currentCell.textLabel!.text!
            defaults.setObject(currentCell.textLabel!.text!, forKey: "selectedPropertyType")
        }
        
        if(vcAction == "ShowProvinceList"){
            let (id_province, province) = self.provinceArr[indexPath.row]
            defaults.setObject(province, forKey: "selectedProvince")
            defaults.setObject(id_province, forKey: "selectedProvinceID")
            defaults.setObject("", forKey: "selectedCity")
        }
        
        if(vcAction == "ShowProvinceList_present"){
            let (id_province, province) = self.provinceArr[indexPath.row]
            defaults.setObject(province, forKey: "selectedProvince_present")
            defaults.setObject(id_province, forKey: "selectedProvinceID_present")
            defaults.setObject("", forKey: "selectedCity_present")
        }
        
        if(vcAction == "ShowProvinceList_permanent"){
            let (id_province, province) = self.provinceArr[indexPath.row]
            defaults.setObject(province, forKey: "selectedProvince_permanent")
            defaults.setObject(id_province, forKey: "selectedProvinceID_permanent")
            defaults.setObject("", forKey: "selectedCity_permanent")
        }
        
        if(vcAction == "ShowBizProvinceList"){
            let (id_bizProvinceCode, bizProvinceCode) = self.provinceArr[indexPath.row]
            defaults.setObject(bizProvinceCode, forKey: "selectedProvinceBiz")
            defaults.setObject(id_bizProvinceCode, forKey: "selectedProvinceBizCode")
            defaults.setObject("", forKey: "selectedCityBiz")
        }
        
        if(vcAction == "ShowCityList"){
            let (id_city, city, _) = self.cityArr[indexPath.row]
            defaults.setObject(city, forKey: "selectedCity")
            defaults.setObject(id_city, forKey: "selectedCityID")
        }
        
        if(vcAction == "ShowCityList_present"){
            let (id_city, city, _) = self.cityArr[indexPath.row]
            defaults.setObject(city, forKey: "selectedCity_present")
            defaults.setObject(id_city, forKey: "selectedCityID_present")
        }
        
        if(vcAction == "ShowCityList_permanent"){
            let (id_city, city, _) = self.cityArr[indexPath.row]
            defaults.setObject(city, forKey: "selectedCity_permanent")
            defaults.setObject(id_city, forKey: "selectedCityID_permanent")
        }
        
        if(vcAction == "ShowBizCityList"){
            let (id_bizCityCode, bizCityCode, _) = self.cityArr[indexPath.row]
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
        
        if(vcAction == "ShowHomeOwnershipList"){
            let (id_homeownership, homeownership) = self.homeownershipArr[indexPath.row]
            defaults.setObject(homeownership, forKey: "selectedHomeOwnership")
            defaults.setObject(id_homeownership, forKey: "selectedHomeOwnershipID")
        }
        
        if(vcAction == "ShowSourceOfFundList"){
            let (id_sourceoffunds, sourceoffunds) = self.sourceFundsArr[indexPath.row]
            defaults.setObject(sourceoffunds, forKey: "selectedSourceOfFund")
            defaults.setObject(id_sourceoffunds, forKey: "selectedSourceOfFundID")
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
        
        if(vcAction == "ShowHomeTermList"){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }
        
        if(vcAction == "ShowPropertyType"){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }
        
        if(vcAction == "ShowProvinceList" || vcAction == "ShowProvinceList_present" || vcAction == "ShowProvinceList_permanent" || vcAction == "ShowBizProvinceList"){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }
        
        if(vcAction == "ShowCityList" || vcAction == "ShowCityList_present" || vcAction == "ShowCityList_permanent" || vcAction == "ShowBizCityList"){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .Checkmark
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
        
        if(vcAction == "ShowHomeOwnershipList"){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRowAtIndexPath(oldIndex)?.accessoryType = .None
            }
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }
        
        if(vcAction == "ShowSourceOfFundList"){
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
    }
}

