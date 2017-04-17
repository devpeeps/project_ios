//
//  ViewControllerCard.swift
//  elysium
//
//  Created by Joshua Eleazar Bosinos on 27/01/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerCard: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    var id = ""
    var name = ""
    var email = ""
    var autoInfo = ["","",""]
    var homeInfo = ["","",""]
    var ccInfo = ["","","",""]
    var autoRates = [("",0.00)]
    var homeRates = [("",0.00)]
    
    var urlLib = ""
    var vcAction = ""
    var withConnection = false
    var cardCategoryArr = [("","")]
    var cardTypeArr = [("","","","","")]
    var cardPromoArr = [("","")]
    
    var civilStatusArr = [("S","Single"),("M","Married"),("W","Widow/er")]
    var salutationArr = [("","")]
    var homeownershipArr = [
            ("0", "OWNED/NOT MORTGAGED"),("1","OWNED/MORTGAGED"), ("2", "LIVING WITH PARENTS"), ("3", "RENTED"), ("4","USED FOR FREE/OTHERS") ]
    var provinceArr = [("","Choose Province")]
    var cityArr = [("","Choose City","")]
    var selectedProvince = ""
    var selectedCity = ""
    var emptypeArr = [("","")]
    var positionArr = [("","")]
    var positionGroupArr = [("","")]
    var selectedCardCategory = ""
    var selectedCardType = ""
    var selectedCardTypeName = ""
    var prevPage = ""
    var selectedWithExistingCard = false
    var selectedWithC1 = false
    var selectedWithC2 = false
    var sourceFundsArr = [("1","Business Income"), ("2","Rental Income"), ("3","Investment"), ("4","Personal Savings"), ("5","Salary"), ("6","Inheritance"), ("7","Sales of Property"), ("8","Pension"), ("9","Others")]
    var bankNameArr = [("","")]
    var addresssSelectionArr = [("H","Residential Address"), ("C", "Office Address")]
    var industryArr = [("","")]
    var showRecent = false
    
    @IBOutlet var scrollViewCardMenu: UIScrollView!
    @IBOutlet var scrollview: UIScrollView!
    
    let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewControllerCard.DismissKeyboard))
        view.addGestureRecognizer(dismiss)
        dismiss.cancelsTouchesInView = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewControllerCard.keyboardWasShown(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewControllerCard.keyboardWasNotShown(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        // Do any additional setup after loading the view.
        checkIfLogged()
        
        if(vcAction == ""){
            prevPage = "main"
            //cardCategoryArr.removeAll()
            //loadCardCategoryList()
        }
        
        if(vcAction == "ShowCardCategoryList") {
            prevPage = "main"
            cardCategoryArr.removeAll()
            loadCardCategoryList()
        }
        
        
        if(vcAction == "CardMainNew") {
            //Load Nothing
        }
        
        if(vcAction == "ShowCardPromoList"){
            cardPromoArr.removeAll()
            loadCardPromoList()
        }
        
        if(vcAction == "apply"){
            prevPage = "ShowCardCategoryList"
            scrollview.contentSize = CGSize(width:400, height:3970)
            loadAppForm()
            loadProvinceList()
            
        }

        if(vcAction == "ShowCardTypeList_MC"){
            prevPage = "ShowCardCategoryList"
            cardTypeArr.removeAll()
            loadCardTypeMC()
        }
        
        if(vcAction == "ShowCardTypeList_GETGO"){
            prevPage = "ShowCardCategoryList"
            cardTypeArr.removeAll()
            loadCardTypeGETGO()
        }
        
        if(vcAction == "ShowCardTypeList"){
            prevPage = "ShowCardCategoryList"
            cardTypeArr.removeAll()
            loadCardTypeList()
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
    
    
    func loadCardTypeGETGO(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "CARDTYPE_FILTERCATEGORY_GETGO")
        
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
                            if(self.id == "NON" || self.id == ""){
                                self.performSegueWithIdentifier("BackToMain", sender: self)
                            }else{
                                self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                            }
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
                if(self.id == "NON" || self.id == ""){
                    self.performSegueWithIdentifier("BackToMain", sender: self)
                }else{
                    self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                }
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    func loadCardTypeMC(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "CARDTYPE_FILTERCATEGORY_MC")
        
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
                            if(self.id == "NON" || self.id == ""){
                                self.performSegueWithIdentifier("BackToMain", sender: self)
                            }else{
                                self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                            }
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
                if(self.id == "NON" || self.id == ""){
                    self.performSegueWithIdentifier("BackToMain", sender: self)
                }else{
                    self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                }
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    func loadCardPromoList(){
        let urlLibPromos = NSLocalizedString("urlLibPromos", comment: "")
        
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLibPromos.stringByReplacingOccurrencesOfString("@@PARAM1", withString: "CARDS")
        
        /*
        urlLib = NSLocalizedString("urlLibPromos", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@PARAM1", withString: "CARDS")
        */
        
        
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
                            //self.cardCategoryArr.removeAll()
                            self.cardPromoArr.removeAll()
                            for i in 0...str.count - 1{
                                if(str[i] != ""){
                                    //self.cardCategoryArr.append((str[i], str[i]))
                                    self.cardPromoArr.append((str[i], str[i]))
                                }
                            }
                            //self.tableViewCardCategory.reloadData()
                            self.tableViewCardPromo.reloadData()
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
                            if(self.id == "NON" || self.id == ""){
                                self.performSegueWithIdentifier("BackToMain", sender: self)
                            }else{
                                self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                            }
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
                if(self.id == "NON" || self.id == ""){
                    self.performSegueWithIdentifier("BackToMain", sender: self)
                }else{
                    self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                }
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    //**********END****
    
    
    
    
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
            
            //loadingIndicator.hidden = false
            //loadingIndicator.startAnimating()
            
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
                            if(self.id == "NON" || self.id == ""){
                                self.performSegueWithIdentifier("BackToMain", sender: self)
                            }else{
                                self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                            }
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
                if(self.id == "NON" || self.id == ""){
                    self.performSegueWithIdentifier("BackToMain", sender: self)
                }else{
                    self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                }
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
                            if(self.id == "NON" || self.id == ""){
                                self.performSegueWithIdentifier("BackToMain", sender: self)
                            }else{
                                self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                            }
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
                if(self.id == "NON" || self.id == ""){
                    self.performSegueWithIdentifier("BackToMain", sender: self)
                }else{
                    self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                }
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let tag = String(pickerView.tag)
        let index1 = tag.startIndex.advancedBy(1)
        let tagIndex = Int(tag.substringToIndex(index1))
        
        if(tagIndex == 4){
            return civilStatusArr.count
        }else if(tagIndex == 5){
            return emptypeArr.count
        }else if(tagIndex == 6){
            return positionArr.count
        }else if(tagIndex == 1) {
            return salutationArr.count
        }else if(tag == "222") {
            return homeownershipArr.count
        }else if(tagIndex == 3) {
            return provinceArr.count
        }else if(tagIndex == 7) {
            return cityArr.count
        }else if(tag == "888") {
            return sourceFundsArr.count
        }else if(tag == "99") {
            return bankNameArr.count
        }else if(tag == "21") {
            return positionGroupArr.count
        }else if(tag == "90") {
            return addresssSelectionArr.count
        }else if(tag == "91") {
            return addresssSelectionArr.count
        }else if(tag == "80") {
            return industryArr.count
            
        }
        return 0
        
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {   var titleData = ""
        let tag = String(pickerView.tag)
        let index1 = tag.startIndex.advancedBy(1)
        let tagIndex = Int(tag.substringToIndex(index1))
        
        if(tagIndex == 4){
            titleData = String(civilStatusArr[row].1)
        }else if(tagIndex == 5){
            titleData = String(emptypeArr[row].1)
        }else if(tagIndex == 6){
            titleData = String(positionArr[row].1)
        }else if(tagIndex == 1) {
            titleData = String(salutationArr[row].1)
        }else if(tag == "222") {
            titleData = String(homeownershipArr[row].1)
        }else if(tagIndex == 3) {
            titleData = String(provinceArr[row].1)
        }else if(tagIndex == 7) {
            titleData = String(cityArr[row].0)
        }else if(tag == "888") {
            titleData = String(sourceFundsArr[row].1)
        }else if(tag == "99") {
            titleData = String(bankNameArr[row].1)
        }else if(tag == "21") {
            titleData = String(positionGroupArr[row].1)
        }else if(tag == "90" ) {
            titleData = String(addresssSelectionArr[row].1)
            
        }else if(tag == "91") {
            titleData = String(addresssSelectionArr[row].1)
        
        }else if(tag == "80") {
                titleData = String(industryArr[row].1)
        }
        return titleData
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let tag = String(pickerView.tag)
        let index1 = tag.startIndex.advancedBy(1)
        let tagIndex = Int(tag.substringToIndex(index1))
        
        if(tagIndex == 5){ //EMP TYPE
            if(pickerView.tag == 5){ //FOR CLIENT
                switch(emptypeArr[row].0){
                case "6" :
                    empname.enabled = false
                    position.userInteractionEnabled = false
                    empincome.enabled = false
                    empyears.enabled = false
                    empaddress1.enabled = false
                    empaddress2.enabled = false
                    empphone.enabled = false
                    position.alpha = 0.6
                    
                    break
                case "0","1","2","3","4","5":
                    empname.enabled = true
                    position.userInteractionEnabled = true
                    empincome.enabled = true
                    empyears.enabled = true
                    empaddress1.enabled = true
                    empaddress2.enabled = true
                    empphone.enabled = true
                    position.alpha = 1
                    
                    break
                default: break //do nothing
                }
            }else if(pickerView.tag == 555){ //FOR C1
                switch(emptypeArr[row].0){
                case "6" :
                    //c1empname.enabled = false
                    //c1position.userInteractionEnabled = false
                    //c1empincome.enabled = false
                    //c1empyears.enabled = false
                    //c1empaddress1.enabled = false
                    //c1empaddress2.enabled = false
                    //c1empphone.enabled = false
                    //c1position.alpha = 0.6
                    
                    break
                case "0","1","2","3","4","5":
                    //c1empname.enabled = true
                    //c1position.userInteractionEnabled = true
                    //c1empincome.enabled = true
                    //c1empyears.enabled = true
                    //c1empaddress1.enabled = true
                    //c1empaddress2.enabled = true
                    //c1empphone.enabled = true
                    //c1position.alpha = 1
                    
                    break
                default: break //do nothing
                }
            }else if(pickerView.tag == 5555){ //FOR C2
                switch(emptypeArr[row].0){
                case "6" :
                    //c2empname.enabled = false
                    //c2position.userInteractionEnabled = false
                    //c2empincome.enabled = false
                    //c2empyears.enabled = false
                    //c2empaddress1.enabled = false
                    //c2empaddress2.enabled = false
                    //c2empphone.enabled = false
                    //c2position.alpha = 0.6
                    
                    break
                case "0","1","2","3","4","5":
                    //c2empname.enabled = true
                    //c2position.userInteractionEnabled = true
                    //c2empincome.enabled = true
                    //c2empyears.enabled = true
                    //c2empaddress1.enabled = true
                    //c2empaddress2.enabled = true
                    //c2empphone.enabled = true
                    //c2position.alpha = 1
                    
                    break
                default: break //do nothing
                }
            }
            
            
            
        }else if(tagIndex == 6){ //POSITION
            //selectedTerm = String(carTermsArr[row])

        }else if(tagIndex == 1){ //SALUTATION
            if(pickerView.tag == 11) {
                
            }else if(pickerView.tag == 111) {
                
            }else if(pickerView.tag == 1111) {
                
            }
            
        }else if(tagIndex == 3){ //PROVINCE
            
            if(pickerView.tag == 33){ //CLIENT RESIDENCE
                selectedProvince = String(provinceArr[row].0)
                loadCityList(selectedProvince)
                
            }else if(pickerView.tag == 333) { //CLIENT PERM PROVINCE
                selectedProvince = String(provinceArr[row].0)
                loadCityList(selectedProvince)
            
            }else if(pickerView.tag == 3333) { //CLIENT EMP PROVINCE
                selectedProvince = String(provinceArr[row].0)
                loadCityList(selectedProvince)
            }
            
        }else if(tagIndex == 7){ //CITY
            
            if(pickerView.tag == 77) { //CLIENT CITY RESIDENCE
                selectedProvince = String(provinceArr[row].0)
                loadCityList(selectedProvince)
                postalcode.text = selectedProvince
                
                
            }else if(pickerView.tag == 777) { //CLIENT CITY PERM
                selectedProvince = String(provinceArr[row].0)
                loadCityList(selectedProvince)
                permpostalcode.text = selectedProvince
                
            }else if(pickerView.tag == 7777) { //CLIENT CITY EMP
                selectedProvince = String(provinceArr[row].0)
                loadCityList(selectedProvince)
                emppostalcode.text = selectedProvince
                
            }else if(pickerView.tag == 99) {
                //
            }
            
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
        if(tagIndex == 4){ //CIVIL STATUS
            titleData = String(civilStatusArr[row].1)
            pickerLabel!.textAlignment = .Left
            
        }else if(tagIndex == 5){ //EMP TYPE
            titleData = String(emptypeArr[row].1)
            pickerLabel!.textAlignment = .Left
            
        }else if(tagIndex == 6){ //POSITION
            titleData = String(positionArr[row].1)
            pickerLabel!.textAlignment = .Left
            
        }else if(tagIndex == 1){ //SALUTATION
            titleData = String(salutationArr[row].1)
            pickerLabel!.textAlignment = .Left
            
        }else if(tag == "222"){ //HOMEOWNERSHIP
            titleData = String(homeownershipArr[row].1)
            pickerLabel!.textAlignment = .Left
            
        }else if(tagIndex == 3){ //PROVINCE
            titleData = String(provinceArr[row].1)
            pickerLabel!.textAlignment = .Left
            
        }else if(tagIndex == 7){ //CITY
            titleData = String(cityArr[row].1)
            pickerLabel!.textAlignment = .Left
        
        }else if(tag == "888") { //SOURCE OF FUNDS
            titleData = String(sourceFundsArr[row].1)
            pickerLabel!.textAlignment = .Left
            
        }else if(tag=="99") {// BANK NAME
            titleData = String(bankNameArr[row].1)
            pickerLabel!.textAlignment = .Left
            
        }else if(tag=="21") {
            titleData = String(positionGroupArr[row].1)
            pickerLabel!.textAlignment = .Left
            
        } else if(tag == "90" ) {
            titleData = String(addresssSelectionArr[row].1)
            pickerLabel!.textAlignment = .Left
            
        } else if(tag == "91" ) {
            titleData = String(addresssSelectionArr[row].1)
            pickerLabel!.textAlignment = .Left
            
        }else if(tag == "80") {
            titleData = String(industryArr[row].1)
            pickerLabel!.textAlignment = .Left
        
        }
        
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Arial", size: 16.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        
        return pickerLabel
    }
    /*
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    */
    
    @IBOutlet var tableViewCardPromo: UITableView!
    @IBOutlet var tableViewCardCategory: UITableView!
    @IBOutlet var tableViewCardType: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag == 0){
            return cardCategoryArr.count
        }else if(tableView.tag == 1){
            return cardTypeArr.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        if(tableView.tag == 0){
            let (_, name) = self.cardCategoryArr[indexPath.row]
            
            if(name != ""){
                cell.textLabel?.text = name
                var imageView = UIImage(named: "")
                switch(name){
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
                cell.imageView!.image = imageView
            }
        }else if(tableView.tag == 1){
            let (_, name, img, _, category) = self.cardTypeArr[indexPath.row]
            
            if(name != ""){
                cell.textLabel?.text = name
                cell.detailTextLabel?.text = category
                let imageView = UIImage(named: img)
                cell.imageView!.image = imageView
 
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(tableView.tag == 0){
            return ""
        }else if(tableView.tag == 1){
            return selectedCardCategory

        }
        return ""
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView.tag == 0){
            let (id, _) = self.cardCategoryArr[indexPath.row]
            self.selectedCardCategory = id
            self.performSegueWithIdentifier("ShowCardTypeList", sender: self)
        }else{
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
                self.performSegueWithIdentifier("ApplyLoan", sender: self)
                
            })
            alert.addAction(action3)
            
            let action4 = UIAlertAction(title: "Inquire Now", style: .Default, handler: { (alert) -> Void in
                self.selectedCardType = id
                self.performSegueWithIdentifier("Inquiry", sender: self)
            })
            alert.addAction(action4)
            
            let action5 = UIAlertAction(title: "Cancel", style: .Default, handler: { (alert) -> Void in
                //nothing
            })
            alert.addAction(action5)
            
            presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    
    @IBOutlet var homeownership: UIPickerView!
    @IBOutlet var salutation: UIPickerView!
    @IBOutlet var lastname: UITextField!
    @IBOutlet var firstname: UITextField!
    @IBOutlet var middlename: UITextField!
    @IBOutlet var birthday: UIDatePicker!
    @IBOutlet var civilstatus: UIPickerView!
    @IBOutlet var phonenumber: UITextField!
    @IBOutlet var mobilenumber: UITextField!
    @IBOutlet var emailaddress: UITextField!
    @IBOutlet var address1: UITextField!
    @IBOutlet var address2: UITextField!
    @IBOutlet var postalcode: UITextField!
    @IBOutlet var emptype: UIPickerView!
    @IBOutlet var empname: UITextField!
    @IBOutlet var position: UIPickerView!
    @IBOutlet var empincome: UITextField!
    @IBOutlet var empyears: UITextField!
    @IBOutlet var empaddress1: UITextField!
    @IBOutlet var empaddress2: UITextField!
    @IBOutlet var empphone: UITextField!
    @IBOutlet var province: UIPickerView!
    @IBOutlet var city: UIPickerView!
    @IBOutlet var permaddress1: UITextField!
    @IBOutlet var permprovince: UIPickerView!
    @IBOutlet var permcity: UIPickerView!
    @IBOutlet var permpostalcode: UITextField!
    @IBOutlet var withpermaddress: UISwitch!
    
    @IBOutlet var bizindustry: UIPickerView!
    @IBOutlet var positiongroup: UIPickerView!
    @IBOutlet var emppostalcode: UITextField!
    @IBOutlet var empcity: UIPickerView!
    @IBOutlet var empprovince: UIPickerView!
    
    @IBOutlet var gsis: UITextField!
    @IBOutlet var sss: UITextField!
    @IBOutlet var tin: UITextField!
    @IBOutlet var empsourcefunds: UIPickerView!
    
    @IBOutlet var withexistingcard: UISwitch!
    @IBOutlet var withexistingbankname: UIPickerView!
    @IBOutlet var withexistingcardno: UITextField!
    
    @IBOutlet var withc1: UISwitch!
    @IBOutlet var withc2: UISwitch!
    
    @IBOutlet var c1salutation: UIPickerView!
    @IBOutlet var c1lastname: UITextField!
    @IBOutlet var c1firstname: UITextField!
    @IBOutlet var c1middlename: UITextField!
    @IBOutlet var c1birthday: UIDatePicker!
    @IBOutlet var c1phonenumber: UITextField!
    @IBOutlet var c1mobilenumber: UITextField!
    @IBOutlet var c1address1: UITextField!
    @IBOutlet var c1address2: UITextField!
    
    @IBOutlet var c2salutation: UIPickerView!
    @IBOutlet var c2lastname: UITextField!
    @IBOutlet var c2firstname: UITextField!
    @IBOutlet var c2middlename: UITextField!
    @IBOutlet var c2birthday: UIDatePicker!
    @IBOutlet var c2phonenumber: UITextField!
    @IBOutlet var c2mobilenumber: UITextField!
    @IBOutlet var c2address1: UITextField!
    @IBOutlet var c2address2: UITextField!
    
    @IBOutlet var c2permaddress: UITextField!
    @IBOutlet var billingaddress: UIPickerView!
    @IBOutlet var deliveryaddress: UIPickerView!
    
    @IBOutlet var c1switchaddress: UISwitch!
    @IBAction func c1switchaddress(sender: AnyObject) {
        if(c1switchaddress.on) {
            c1address2.hidden  = true
        }else{
            c1address2.hidden = false
        }
    }
    @IBOutlet var c2switchaddress: UISwitch!
    
    @IBAction func c2switchaddress(sender: AnyObject) {
        if(c2switchaddress.on) {
            c2permaddress.hidden  = true
        }else{
            c2permaddress.hidden = false
        }
    }

    
    @IBAction func ShowCardCategoryList(sender: AnyObject) {
        
    }
    
    func loadAppForm(){
        self.loadingIndicator.hidden = false
        self.loadingIndicator.startAnimating()
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        self.loadEmpTypePicker()
        self.loadPositionPicker()
        self.loadBankName()
        self.loadSalutation()
        self.loadOccupationGroup()
        self.loadIndustry()
        
        
        
        
        c1lastname.enabled = false
        c1firstname.enabled = false
        c1middlename.enabled = false
        
        c1phonenumber.enabled = false
        c1mobilenumber.enabled = false
        c1address1.enabled = false
        c1address2.enabled = false
        //c1emptype.userInteractionEnabled = false
        //c1empname.enabled = false
        //c1position.userInteractionEnabled = false
        //c1empincome.enabled = false
        //c1empyears.enabled = false
        //c1empaddress1.enabled = false
        //c1empaddress2.enabled = false
        //c1empphone.enabled = false
        
        //c1birthday.alpha = 0.6
        //c1civilstatus.alpha = 0.6
        //c1emptype.alpha = 0.6
        //c1position.alpha = 0.6
        
        withc2.enabled = false
        c2lastname.enabled = false
        c2firstname.enabled = false
        c2middlename.enabled = false
        //c2birthday.userInteractionEnabled = false
        //c2civilstatus.userInteractionEnabled = false
        //c2gender.enabled = false
        c2phonenumber.enabled = false
        c2mobilenumber.enabled = false
        c2address1.enabled = false
        //c2address2.enabled = false
        //c2emptype.userInteractionEnabled = false
        //c2empname.enabled = false
        //c2position.userInteractionEnabled = false
        //c2empincome.enabled = false
        //c2empyears.enabled = false
        //c2empaddress1.enabled = false
        //c2empaddress2.enabled = false
        //c2empphone.enabled = false
        
        //c2birthday.alpha = 0.6
        //c2civilstatus.alpha = 0.6
        //c2emptype.alpha = 0.6
        //c2position.alpha = 0.6
        
        
        
        lastname.delegate = self
        firstname.delegate = self
        middlename.delegate = self
        phonenumber.delegate = self
        mobilenumber.delegate = self
        address1.delegate = self
        address2.delegate = self
        emailaddress.delegate = self
        empname.delegate = self
        empincome.delegate = self
        empyears.delegate = self
        empaddress1.delegate = self
        empaddress2.delegate = self
        empphone.delegate = self

        
        c1lastname.delegate = self
        c1firstname.delegate = self
        c1middlename.delegate = self
        c1phonenumber.delegate = self
        c1mobilenumber.delegate = self
        c1address1.delegate = self
        c1address2.delegate = self
        //c1empname.delegate = self
        //c1empincome.delegate = self
        //c1empyears.delegate = self
        //c1empaddress1.delegate = self
        //c1empaddress2.delegate = self
        //c1empphone.delegate = self
        
        c2lastname.delegate = self
        c2firstname.delegate = self
        c2middlename.delegate = self
        c2phonenumber.delegate = self
        c2mobilenumber.delegate = self
        c2address1.delegate = self
        c2address2.delegate = self
        //c2empname.delegate = self
        //c2empincome.delegate = self
        //c2empyears.delegate = self
        //c2empaddress1.delegate = self
        //c2empaddress2.delegate = self
        //c2empphone.delegate = self
        
    }
 
    

    func loadSalutation(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        //self.view.userInteractionEnabled = false
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "CATS-SALUTATION")
        
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
                            self.salutationArr.removeAll()
                            for i in 0...str.count - 2{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[0] != ""){
                                    self.salutationArr.append((str2[1], str2[0]))
                                    //if(i == 0){
                                    
                                    //}
                                }
                            }
                            self.salutation.reloadAllComponents()
                            self.c1salutation.reloadAllComponents()
                            self.c2salutation.reloadAllComponents()
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
                            if(self.id == "NON" || self.id == ""){
                                self.performSegueWithIdentifier("BackToMain", sender: self)
                            }else{
                                self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                            }
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
                if(self.id == "NON" || self.id == ""){
                    self.performSegueWithIdentifier("BackToMain", sender: self)
                }else{
                    self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                }
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }

    
    func loadBankName(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        //self.view.userInteractionEnabled = false
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "CATS-BANK")
        
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
                            self.bankNameArr.removeAll()
                            for i in 0...str.count - 2{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[0] != ""){
                                    self.bankNameArr.append((str2[1], str2[0]))
                                    //if(i == 0){
                    
                                    //}
                                }
                            }
                            self.withexistingbankname.reloadAllComponents()
                            //self.view.userInteractionEnabled = true
                            //self.loadingIndicator.hidden = true
                            //self.loadingIndicator.stopAnimating()
                            //UIApplication.sharedApplication().endIgnoringInteractionEvents()
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
                            if(self.id == "NON" || self.id == ""){
                                self.performSegueWithIdentifier("BackToMain", sender: self)
                            }else{
                                self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                            }
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
                if(self.id == "NON" || self.id == ""){
                    self.performSegueWithIdentifier("BackToMain", sender: self)
                }else{
                    self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                }
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    //***********
    
    
    func loadIndustry(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        //self.view.userInteractionEnabled = false
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "CATS-BUSINDUSTRY")
        
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
                            self.bizindustry.reloadAllComponents()

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
                            if(self.id == "NON" || self.id == ""){
                                self.performSegueWithIdentifier("BackToMain", sender: self)
                            }else{
                                self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                            }
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
                if(self.id == "NON" || self.id == ""){
                    self.performSegueWithIdentifier("BackToMain", sender: self)
                }else{
                    self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                }
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }

    
    
    //******END*****
    
    func loadOccupationGroup(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        //self.view.userInteractionEnabled = false
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "CATS-OCCUGROUP")
        
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
                            self.positionGroupArr.removeAll()
                            for i in 0...str.count - 2{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[0] != ""){
                                    self.positionGroupArr.append((str2[1], str2[0]))
     
                                }
                            }
                            self.positiongroup.reloadAllComponents()

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
                            if(self.id == "NON" || self.id == ""){
                                self.performSegueWithIdentifier("BackToMain", sender: self)
                            }else{
                                self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                            }
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
                if(self.id == "NON" || self.id == ""){
                    self.performSegueWithIdentifier("BackToMain", sender: self)
                }else{
                    self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                }
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }

    
    
    func loadEmpTypePicker(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        //self.view.userInteractionEnabled = false
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "CATS-EMPSTATUS")
        
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
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[0] != ""){
                                    self.emptypeArr.append((str2[1], str2[0]))
                                    if(i == 0){
                                        //self.selectedCarBrand = self.carBrandArr[i].0
                                    }
                                }
                            }
                            self.emptype.reloadAllComponents()
                            //self.c1emptype.reloadAllComponents()
                            //self.c2emptype.reloadAllComponents()
                            //self.view.userInteractionEnabled = true
                            //self.loadingIndicator.hidden = true
                            //self.loadingIndicator.stopAnimating()
                            //UIApplication.sharedApplication().endIgnoringInteractionEvents()
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
                            if(self.id == "NON" || self.id == ""){
                                self.performSegueWithIdentifier("BackToMain", sender: self)
                            }else{
                                self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                            }
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
                if(self.id == "NON" || self.id == ""){
                    self.performSegueWithIdentifier("BackToMain", sender: self)
                }else{
                    self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                }
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func loadPositionPicker(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        //self.view.userInteractionEnabled = false
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "CATS-JOBPOS")
        
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
                                if(str2[0] != ""){
                                    self.positionArr.append((str2[1], str2[0]))
                                    if(i == 0){
                                        //self.selectedCarBrand = self.carBrandArr[i].0
                                    }
                                }
                            }
                            self.position.reloadAllComponents()
                            //self.c1position.reloadAllComponents()
                            //self.c2position.reloadAllComponents()
                            
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
                            if(self.id == "NON" || self.id == ""){
                                self.performSegueWithIdentifier("BackToMain", sender: self)
                            }else{
                                self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                            }
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
                if(self.id == "NON" || self.id == ""){
                    self.performSegueWithIdentifier("BackToMain", sender: self)
                }else{
                    self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                }
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
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[0] != ""){
                                    self.provinceArr.append((str2[1], str2[0]))
                                    
                                }
                            }
                            self.province.reloadAllComponents()
                            self.empprovince.reloadAllComponents()
                            self.permprovince.reloadAllComponents()
                            
                            
                            self.view.userInteractionEnabled = true
                            self.loadingIndicator.hidden = true
                            self.loadingIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[1] != ""){
                                    if(self.provinceArr[i].0 == self.selectedProvince){
                                        self.province.selectRow(i, inComponent: 0, animated: false)
                                        self.loadCityList(self.selectedProvince)
                                        break
                                    }
                                }
                            }
                            
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
                            if(self.id == "NON" || self.id == ""){
                                self.performSegueWithIdentifier("BackToMain", sender: self)
                            }else{
                                self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                            }
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
                if(self.id == "NON" || self.id == ""){
                    self.performSegueWithIdentifier("BackToMain", sender: self)
                }else{
                    self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                }
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
            var urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "CATS-CITY")
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
                                    if(str2[0] != ""){
                                        self.cityArr.append((str2[1], str2[0], provinceId))
                                        
                                    }
                                }
                                self.city.reloadAllComponents()
                                self.permcity.reloadAllComponents()
                                self.empcity.reloadAllComponents()
                                
                                self.view.userInteractionEnabled = true
                                self.loadingIndicator.hidden = true
                                self.loadingIndicator.stopAnimating()
                                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                                
                                for i in 0...str.count - 1{
                                    let str2 = str[i].componentsSeparatedByString("***")
                                    if(str2[0] != ""){
                                        if(self.cityArr[i].0 == self.selectedCity){
                                            self.city.selectRow(i, inComponent: 0, animated: false)
                                            break
                                        }
                                    }
                                }
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
                                if(self.id == "NON" || self.id == ""){
                                    self.performSegueWithIdentifier("BackToMain", sender: self)
                                }else{
                                    self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                                }
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
                    if(self.id == "NON" || self.id == ""){
                        self.performSegueWithIdentifier("BackToMain", sender: self)
                    }else{
                        self.performSegueWithIdentifier("BackToMainLogged", sender: self)
                    }
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func actionTogglePermAddress(sender: AnyObject) {
        if(self.withpermaddress.on == true) {
            permaddress1.enabled = true
            permcity.userInteractionEnabled = true
            permprovince.userInteractionEnabled = true
            permpostalcode.enabled = true
        
            permaddress1.alpha = 1
            permcity.alpha = 1
            permprovince.alpha = 1
            permpostalcode.alpha = 1
            
        }else{
            permaddress1.enabled = false
            permcity.userInteractionEnabled = false
            permprovince.userInteractionEnabled = false
            permpostalcode.enabled = false
            
            permaddress1.alpha = 0.6
            permcity.alpha = 0.6
            permprovince.alpha = 0.6
            permpostalcode.alpha = 0.6
            
        }
    }
    @IBAction func actionWithExistingCard(sender: AnyObject) {
        if(self.withexistingcard.on == true) {
            withexistingbankname.userInteractionEnabled = true
            withexistingcardno.enabled = true
            
            withexistingbankname.alpha = 1
            withexistingcardno.alpha = 1
        }else{
            withexistingcardno.enabled = false
            withexistingbankname.userInteractionEnabled = false
            
            withexistingbankname.alpha = 0.6
            withexistingcardno.alpha = 0.6
            
        }
    }
    
    @IBAction func actionWithC1(sender: AnyObject) {
        if(self.withc1.on == true){
            c1lastname.enabled = true
            c1firstname.enabled = true
            c1middlename.enabled = true
            c1birthday.userInteractionEnabled = true
            //c1civilstatus.userInteractionEnabled = true
            //c1gender.enabled = true
            c1phonenumber.enabled = true
            c1mobilenumber.enabled = true
            c1address1.enabled = true
            c1address2.enabled = true
            //c1emptype.userInteractionEnabled = true
            
            //c1empname.enabled = true
            //c1position.userInteractionEnabled = true
            //c1empincome.enabled = true
            //c1empyears.enabled = true
            //c1empaddress1.enabled = true
            //c1empaddress2.enabled = true
            //c1empphone.enabled = true
            withc2.enabled = true
            
            c1birthday.alpha = 1
            //c1civilstatus.alpha = 1
            //c1emptype.alpha = 1
            //c1position.alpha = 1
        }else{
            c1lastname.enabled = false
            c1firstname.enabled = false
            c1middlename.enabled = false
            c1birthday.userInteractionEnabled = false
            //c1civilstatus.userInteractionEnabled = false
            //c1gender.enabled = false
            c1phonenumber.enabled = false
            c1mobilenumber.enabled = false
            c1address1.enabled = false
            c1address2.enabled = false
            //c1emptype.userInteractionEnabled = false
            //c1empname.enabled = false
            //c1position.userInteractionEnabled = false
            //c1empincome.enabled = false
            //c1empyears.enabled = false
            //c1empaddress1.enabled = false
            //c1empaddress2.enabled = false
            //c1empphone.enabled = false
            withc2.enabled = false
            
            c1birthday.alpha = 0.6
            //c1civilstatus.alpha = 0.6
            //c1emptype.alpha = 0.6
            //c1position.alpha = 0.6
            
            withc2.on = false
            c2lastname.enabled = false
            c2firstname.enabled = false
            c2middlename.enabled = false
            c2birthday.userInteractionEnabled = false
            //c2civilstatus.userInteractionEnabled = false
            //c2gender.enabled = false
            c2phonenumber.enabled = false
            c2mobilenumber.enabled = false
            c2address1.enabled = false
            c2address2.enabled = false
            //c2emptype.userInteractionEnabled = false
            //c2empname.enabled = false
            //c2position.userInteractionEnabled = false
            //c2empincome.enabled = false
            //c2empyears.enabled = false
            //c2empaddress1.enabled = false
            //c2empaddress2.enabled = false
            //c2empphone.enabled = false
            
            c2birthday.alpha = 0.6
            //c2civilstatus.alpha = 0.6
            //c2emptype.alpha = 0.6
            //c2position.alpha = 0.6
            
        }
    }
    
    
    @IBAction func actionWithC2(sender: AnyObject) {
        if(self.withc2.on == true){
            c2lastname.enabled = true
            c2firstname.enabled = true
            c2middlename.enabled = true
            c2birthday.userInteractionEnabled = true
            //c2civilstatus.userInteractionEnabled = true
            //c2gender.enabled = true
            c2phonenumber.enabled = true
            c2mobilenumber.enabled = true
            c2address1.enabled = true
            c2address2.enabled = true
            //c2emptype.userInteractionEnabled = true
            
            //c2empname.enabled = true
            //c2position.userInteractionEnabled = true
            //c2empincome.enabled = true
            //c2empyears.enabled = true
            //c2empaddress1.enabled = true
            //c2empaddress2.enabled = true
            //c2empphone.enabled = true
            
            c2birthday.alpha = 1
            //c2civilstatus.alpha = 1
            //c2emptype.alpha = 1
            //c2position.alpha = 1
        }else{
            c2lastname.enabled = false
            c2firstname.enabled = false
            c2middlename.enabled = false
            c2birthday.userInteractionEnabled = false
            //c2civilstatus.userInteractionEnabled = false
            //c2gender.enabled = false
            c2phonenumber.enabled = false
            c2mobilenumber.enabled = false
            c2address1.enabled = false
            c2address2.enabled = false
            //c2emptype.userInteractionEnabled = false
            //c2empname.enabled = false
            //c2position.userInteractionEnabled = false
            //c2empincome.enabled = false
            //c2empyears.enabled = false
            //c2empaddress1.enabled = false
            //c2empaddress2.enabled = false
            //c2empphone.enabled = false
            
            c2birthday.alpha = 0.6
            //c2civilstatus.alpha = 0.6
            //c2emptype.alpha = 0.6
            //c2position.alpha = 0.6
        }
    }
    
    
    @IBAction func actionSubmit(sender: AnyObject) {
        let tnc = NSLocalizedString("tnc_apply", comment: "").html2String
        
        let alert = UIAlertController(title: "Acceptance of Terms & Conditions", message: tnc, preferredStyle: .ActionSheet)
        let action = UIAlertAction(title: "Yes, I accept", style: .Default, handler: { (alert) -> Void in
            self.submitApplication()
        })
        alert.addAction(action)
        let action2 = UIAlertAction(title: "No, I do not accept", style: .Default, handler: { (alert) -> Void in
            //do nothing
        })
        alert.addAction(action2)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    func submitApplication(){
        
        self.loadingIndicator.hidden = false
        self.loadingIndicator.startAnimating()
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        
        let url = NSLocalizedString("urlCATS", comment: "")
        
        var stringUrl = url
        
        var errorctr = 0;
        var errormsg = "";
        stringUrl = stringUrl + "&companyid=" + self.id;
        
        stringUrl = stringUrl + "&cardtype=" + selectedCardTypeName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&aoemail=" + ccInfo[1].stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&appsource=" + (self.id != "NON" ? "WAP" : "Online Application").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!; //CHECK WITH LIBFIELDVALUES
        stringUrl = stringUrl + "&rm=" + "";
        stringUrl = stringUrl + "&sourcearea=" + "Not Applicable".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&sourcetype=" + "Head Office".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&clientclass=" + (self.id != "NON" ? "WAP (WORKPLACE ARRANGEMENT PROGR" : "REGULAR").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!; //ADD TO LIBFIELDVALUES = REGULAR
        stringUrl = stringUrl + "&clienttype=" + "0".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        if(self.lastname.text == ""){
            errorctr += 1;
            errormsg += "Last Name\n";
        }
        if(self.firstname.text == ""){
            errorctr += 1;
            errormsg += "First Name\n";
        }
        if(self.mobilenumber.text == ""){ //CHECK IF VALID PHONE
            errorctr += 1;
            errormsg += "Mobile No\n";
        }
        if(self.emailaddress.text == "" || isValidEmail(self.emailaddress.text!) == false){ //CHECK IF VALID EMAIL
            errorctr += 1;
            errormsg += "Email Address\n";
        }
        if(self.address1.text == ""){
            errorctr += 1;
            errormsg += "Res Address\n";
        }
        
        if(emptypeArr[self.emptype.selectedRowInComponent(0)].0 != "6"){
            if(self.empname.text == ""){
                errorctr += 1;
                errormsg += "Emp/Biz Name\n";
            }
            if(self.empincome.text == ""){ //CHECK IF VALID AMOUNT
                errorctr += 1;
                errormsg += "Emp/Biz Income\n";
            }
            if(self.empaddress1.text == ""){
                errorctr += 1;
                errormsg += "Emp/Biz Address\n";
            }
            if(self.empphone.text == ""){
                errorctr += 1;
                errormsg += "Emp/Biz Phone\n";
            }
        }
        
        stringUrl = stringUrl + "&fullname=" + self.lastname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + (", " + self.firstname.text!).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + (" " + self.middlename.text!).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        
        
        stringUrl = stringUrl + "&lname=" + self.lastname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&fname=" + self.firstname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&mname=" + self.middlename.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        let bday = self.birthday.date
        let dateStr = bday.dateFormatted
        
        stringUrl = stringUrl + "&bday=" + dateStr.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        //stringUrl = stringUrl + "&gender=" + (self.gender.selectedSegmentIndex == 0 ? "0" : "1")
        
        stringUrl = stringUrl + "&salutation=" +
            (salutationArr[self.salutation.selectedRowInComponent(0)].0).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&homeownership=" + (homeownershipArr[self.homeownership.selectedRowInComponent(0)].0).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&empsourcefunds=" + (sourceFundsArr[self.empsourcefunds.selectedRowInComponent(0)].0).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&civilstat=" + (civilStatusArr[self.civilstatus.selectedRowInComponent(0)].0).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&resphone=" + self.phonenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&mobileno=" + self.mobilenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&email=" + self.emailaddress.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&resadd1=" + self.address1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&resadd2=" + self.address2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&empbiz_type=" + emptypeArr[self.emptype.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&remarks=" + bankNameArr[self.withexistingbankname.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        
        stringUrl = stringUrl + "&empbizname=" + self.empname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&jobpos=" + positionArr[self.position.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&empbiz_y=" + self.empyears.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&empbizadd1=" + self.empaddress1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&empbizadd2=" + self.empaddress2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&empbizphone=" + self.empphone.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&monthly_income=" + self.empincome.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        
        
        if(self.withc1.on == true){
            
            
            if(self.c1lastname.text == ""){
                errorctr += 1;
                errormsg += "S1 Last Name\n";
            }
            if(self.c1firstname.text == ""){
                errorctr += 1;
                errormsg += "S1 First Name\n";
            }
            if(self.c1mobilenumber.text == ""){
                errorctr += 1;
                errormsg += "S1 Mobile No\n";
            }
            if(self.c1address1.text == ""){
                errorctr += 1;
                errormsg += "S1 Res Address\n";
            }
            
            /*
            if(emptypeArr[self.c1emptype.selectedRowInComponent(0)].0 != "6"){
                if(self.c1empname.text == ""){
                    errorctr++;
                    errormsg += "S1 Emp/Biz Name\n";
                }
                if(self.c1empincome.text == ""){ //CHECK IF VALID AMOUNT
                    errorctr++;
                    errormsg += "S1 Emp/Biz Income\n";
                }
                if(self.c1empaddress1.text == ""){
                    errorctr++;
                    errormsg += "S1 Emp/Biz Address\n";
                }
                if(self.c1empphone.text == ""){
                    errorctr++;
                    errormsg += "S1 Emp/Biz Phone\n";
                }
            }
            */
            
            
            stringUrl = stringUrl + "&m1lname=" + self.c1lastname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1fname=" + self.c1firstname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1mname=" + self.c1middlename.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            let bday = self.c1birthday.date
            let dateStr = bday.dateFormatted
            stringUrl = stringUrl + "&m1bday=" + dateStr.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            //stringUrl = stringUrl + "&m1gender=" + (self.c1gender.selectedSegmentIndex == 0 ? "0" : "1")
            stringUrl = stringUrl + "&m1resphone=" + self.c1phonenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1mobileno=" + self.c1mobilenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1resadd1=" + self.c1address1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1resadd2=" + self.c1address2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            //stringUrl = stringUrl + "&m1empbiz_type=" + emptypeArr[self.c1emptype.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            //stringUrl = stringUrl + "&m1empbizname=" + self.c1empname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            //stringUrl = stringUrl + "&m1jobpos=" + positionArr[self.c1position.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            //stringUrl = stringUrl + "&m1empbiz_y=" + self.c1empyears.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m1empbizadd1=" + self.c1empaddress1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m1empbizadd2=" + self.c1empaddress2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m1empbizphone=" + self.c1empphone.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m1empbizmoincome=" + self.c1empincome.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        }
        
        if(self.withc2.on == true){
            
            
            if(self.c2lastname.text == ""){
                errorctr += 1;
                errormsg += "S2 Last Name\n";
            }
            if(self.c2firstname.text == ""){
                errorctr += 1;
                errormsg += "S2 First Name\n";
            }
            if(self.c2mobilenumber.text == ""){
                errorctr += 1;
                errormsg += "S2 Mobile No\n";
            }
            if(self.c2address1.text == ""){
                errorctr += 1;
                errormsg += "S2 Res Address\n";
            }
            
            /*
            if(emptypeArr[self.c2emptype.selectedRowInComponent(0)].0 != "6"){
                if(self.c2empname.text == ""){
                    errorctr++;
                    errormsg += "S2 Emp/Biz Name\n";
                }
                if(self.c2empincome.text == ""){ //CHECK IF VALID AMOUNT
                    errorctr++;
                    errormsg += "S2 Emp/Biz Income\n";
                }
                if(self.c2empaddress1.text == ""){
                    errorctr++;
                    errormsg += "S2 Emp/Biz Address\n";
                }
                if(self.c2empphone.text == ""){
                    errorctr++;
                    errormsg += "S2 Emp/Biz Phone\n";
                }
            }
            */
            
            
            stringUrl = stringUrl + "&m2lname=" + self.c2lastname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2fname=" + self.c2firstname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2mname=" + self.c2middlename.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            let bday = self.c2birthday.date
            let dateStr = bday.dateFormatted
            stringUrl = stringUrl + "&m2bday=" + dateStr.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m2gender=" + (self.c2gender.selectedSegmentIndex == 0 ? "0" : "1")
            stringUrl = stringUrl + "&m2resphone=" + self.c2phonenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2mobileno=" + self.c2mobilenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2resadd1=" + self.c2address1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2resadd2=" + self.c2address2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m2empbiz_type=" + emptypeArr[self.c2emptype.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m2empbizname=" + self.c2empname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m2jobpos=" + positionArr[self.c2position.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m2empbiz_y=" + self.c2empyears.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m2empbizadd1=" + self.c2empaddress1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m2empbizadd2=" + self.c2empaddress2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m2empbizphone=" + self.c2empphone.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m2empbizmoincome=" + self.c2empincome.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        }
        
        stringUrl = stringUrl + "&duid=" + UIDevice.currentDevice().identifierForVendor!.UUIDString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&dtype=ios"
        
        //stringUrl = stringUrl + "&remarks=" + self.remarks.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        //stringUrl = stringUrl + "&loggeduser=" + EncodeURLString(loggedUSRUID);
        
        
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
            NSUserDefaults.standardUserDefaults().setObject(self.birthday.date, forKey: "BIRTHDAY")
            NSUserDefaults.standardUserDefaults().setObject(self.mobilenumber.text, forKey: "MOBILENO")
            NSUserDefaults.standardUserDefaults().setObject(self.emailaddress.text, forKey: "EMAIL")
            NSUserDefaults.standardUserDefaults().setObject(self.phonenumber.text, forKey: "RESPHONE")
            NSUserDefaults.standardUserDefaults().setObject(self.empphone.text, forKey: "EMPBIZPHONE")
            NSUserDefaults.standardUserDefaults().setObject(self.address1.text, forKey: "RESADDLINE1")
            NSUserDefaults.standardUserDefaults().setObject(self.address2.text, forKey: "RESADDLINE2")
            NSUserDefaults.standardUserDefaults().setObject(self.empaddress1.text, forKey: "EMPBIZADDLINE1")
            NSUserDefaults.standardUserDefaults().setObject(self.empaddress2.text, forKey: "EMPBIZADDLINE2")
            NSUserDefaults.standardUserDefaults().setObject(self.empname.text, forKey: "EMPBIZNAME")
            
            NSLog("stringUrl: " + stringUrl)

            let entityDescription = NSEntityDescription.entityForName("UrlStrings", inManagedObjectContext: manageObjectContext)
            let url = UrlStrings(entity:entityDescription!, insertIntoManagedObjectContext: manageObjectContext)
            url.url = stringUrl
            url.datecreated = String(NSDate())
            url.refid = "CARD"
            url.datesuccess = "0"
 
            self.view.userInteractionEnabled = true
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "Application Submitted", message: "Your new credit card application has been saved for submission. Please make sure not to quit the app and to have a stable data connection for a few minutes. You will receive an alert once it has been successfully sent.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                self.performSegueWithIdentifier("BackToMain", sender: self)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        
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
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCardTypeList"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerCard{
                destinationVC.vcAction = "ShowCardTypeList"
                destinationVC.id = self.id
                destinationVC.selectedCardCategory = selectedCardCategory
                destinationVC.prevPage = "mainCard"
            }
        }
        
        if segue.identifier == "ShowCardTypeList_MC"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerCard{
                destinationVC.vcAction = "ShowCardTypeList_MC"
                destinationVC.id = self.id
                destinationVC.selectedCardCategory = selectedCardCategory
                destinationVC.prevPage = "ShowCardCategoryList"
            }
        }
        
        if segue.identifier == "ShowCardTypeList_GETGO"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerCard{
                destinationVC.vcAction = "ShowCardTypeList_GETGO"
                destinationVC.id = self.id
                destinationVC.selectedCardCategory = selectedCardCategory
                destinationVC.prevPage = "ShowCardCategoryList"
            }
        }
        
        
        
        if(segue.identifier == "ShowCardCategoryList") {
            if let destinationVC = segue.destinationViewController as? ViewControllerCard{
                destinationVC.vcAction = "ShowCardCategoryList"
                destinationVC.id = self.id
                destinationVC.selectedCardCategory = selectedCardCategory
                destinationVC.prevPage = "mainCard"
            }
        }
        
        if segue.identifier == "BackToCardMain"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerCard{
                destinationVC.vcAction = "ShowCardCategoryList"
                destinationVC.id = self.id
                destinationVC.selectedCardCategory = selectedCardCategory
                destinationVC.prevPage = "mainCard"
            }
        }
        
        if segue.identifier == "ApplyLoan"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerCard{
                destinationVC.vcAction = "apply"
                destinationVC.id = self.id
                destinationVC.prevPage = "ShowCardCategoryList"
                destinationVC.selectedCardCategory = selectedCardCategory
                destinationVC.selectedCardType = selectedCardType
                destinationVC.selectedCardTypeName = selectedCardTypeName
                
            }
        }
        if segue.identifier == "Inquiry"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerInquiry{
                destinationVC.id = self.id
                destinationVC.prevPage = "CardMain"
                destinationVC.product = "Credit Card"
                destinationVC.selectedCardCategory = selectedCardCategory
            }
        }
        
        if segue.identifier == "FAQ"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerFAQ{
                destinationVC.id = self.id
                destinationVC.prevPage = "CardMain"
            }
        }
        
        if (segue.identifier == "ShowCardPromoList") {
            
            if let destinationVC = segue.destinationViewController as? ViewControllerCard{
                destinationVC.vcAction = "ShowCardPromoList"
                destinationVC.id = self.id
                destinationVC.selectedCardCategory = selectedCardCategory
                destinationVC.prevPage = "CardMain"
                
            }
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
