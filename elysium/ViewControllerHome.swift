//
//  ViewControllerHome.swift
//  elysium
//
//  Created by Joshua Eleazar Bosinos on 26/01/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerHome: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
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
    var propertyModelArr = [("modelid","modeldesc", "proj", "type",0.00,0.00,"areafrom","areato","developer","prov","city")]
    var carTermsArr = [60,48,36,24,18,12]
    var homeTermsArr = [20,19,18,17,16,15,14,12,11,10,9,8,7,6,5,4,3,2,1]
    var downpaymentArr = [20,30,40,50,60,70,80,90]
    var downpaymentArr_Home = [10,20,30,40,50,60,70,80,90]
    var civilStatusArr = [("S","Single"),("M","Married"),("W","Widow/er")]
    var propertytypeArr = [("","Choose Property Type")]
    var provinceArr = [("","Choose Province/Municipality")]
    var cityArr = [("","Choose City","")]
    var emptypeArr = [("","")]
    var positionArr = [("","")]
    var selectedPropertyType = ""
    var selectedProvince = ""
    var selectedCity = ""
    var selectedPriceFrom = ""
    var selectedPriceTo = ""
    var selectedPropertyModelId = ""
    var selectedPropertyProj = ""
    var selectedPropertyDeveloper = ""
    var selectedPropertyModelSRP = 0
    var prevPage = ""
    var selectedTerm = "10"
    var selectedDP = "10"
    var selectedCivilStat = ""
    var selectedWithC1 = false
    var selectedWithC2 = false
    
    var showRecent = false
    
    @IBOutlet var scrollview: UIScrollView!
    
    let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(dismiss)
        dismiss.cancelsTouchesInView = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasNotShown:"), name:UIKeyboardWillHideNotification, object: nil);
        
        // Do any additional setup after loading the view.
        checkIfLogged()
        
        if(vcAction == ""){
            prevPage = "main"
            txtPriceFrom.text = self.selectedPriceFrom
            txtPriceTo.text = self.selectedPriceTo
            loadPropertyTypeList()
            loadProvinceList()
        }
        
        if(vcAction == "apply"){
            scrollview.contentSize = CGSize(width:400, height:3970)
            
            loadAppForm()
            
            
        }
        
        if(vcAction == "ShowPropertyModelList"){
            propertyModelArr.removeAll()
            loadPropertyModels()
        }
        if(vcAction == "ShowPropertyModelListRecent"){
            propertyModelArr.removeAll()
            loadPropertyModelsRecent()
        }
        
        if(vcAction == "HomeLoanCalculator"){
            loadCalculatorValues()
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
    
    @IBOutlet var pickerPropertyType: UIPickerView!
    @IBOutlet var pickerPropertyProvince: UIPickerView!
    @IBOutlet var pickerPropertyCity: UIPickerView!
    @IBOutlet var txtPriceFrom: UITextField!
    @IBOutlet var txtPriceTo: UITextField!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var buttonLogout: UIButton!
    
    
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
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[1] != ""){
                                    self.propertytypeArr.append((str2[1], str2[0]))
                                }
                            }
                            self.pickerPropertyType.reloadAllComponents()
                            
                            self.view.userInteractionEnabled = true
                            self.loadingIndicator.hidden = true
                            self.loadingIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[1] != ""){
                                    if(self.propertytypeArr[i].0 == self.selectedPropertyType){
                                        self.pickerPropertyType.selectRow(i, inComponent: 0, animated: false)
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
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[1] != ""){
                                    self.provinceArr.append((str2[1], str2[0]))
                                }
                            }
                            self.pickerPropertyProvince.reloadAllComponents()
                            
                            self.view.userInteractionEnabled = true
                            self.loadingIndicator.hidden = true
                            self.loadingIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[1] != ""){
                                    if(self.provinceArr[i].0 == self.selectedProvince){
                                        self.pickerPropertyProvince.selectRow(i, inComponent: 0, animated: false)
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
                                self.pickerPropertyCity.reloadAllComponents()
                                
                                self.view.userInteractionEnabled = true
                                self.loadingIndicator.hidden = true
                                self.loadingIndicator.stopAnimating()
                                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                                
                                for i in 0...str.count - 1{
                                    let str2 = str[i].componentsSeparatedByString("***")
                                    if(str2[1] != ""){
                                        if(self.cityArr[i].0 == self.selectedCity){
                                            self.pickerPropertyCity.selectRow(i, inComponent: 0, animated: false)
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
    
    
    @IBOutlet var txtSellingPrice: UITextField!
    @IBOutlet var txtMonthlyAmort: UITextField!
    @IBOutlet var pickerDP: UIPickerView!
    @IBOutlet var pickerTerm: UIPickerView!
    
    func loadCalculatorValues(){
        
        txtSellingPrice.text = self.selectedPropertyModelSRP.stringFormattedWithSepator
        pickerTerm.selectRow(0, inComponent: 0, animated: false)
        pickerDP.selectRow(0, inComponent: 0, animated: false)
        
        let x = Int(calculateAmort())
        txtMonthlyAmort.text = x.stringFormattedWithSepator
    }
    
    @IBAction func computeAmort(sender: AnyObject) {
        let x = Int(calculateAmort())
        //NSLog(String(x))
        txtMonthlyAmort.text = x.stringFormattedWithSepator
    }
    func calculateAmort() -> Double{
        var aor = 0.00
        let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        //NSLog((NSUserDefaults.standardUserDefaults().arrayForKey("autoInfo")?.first)! as! String)
        
        if (userDefaults.objectForKey("homeRates_standard") != nil) {
            aor = NSUserDefaults.standardUserDefaults().objectForKey("homeRates_standard") as! Double
        }
        
        let rate = aor / 100;
        let dp = Double(selectedDP)
        var amount_financed = Double(txtSellingPrice.text!.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))
        amount_financed = amount_financed! - (amount_financed! * (dp! / 100))
        NSLog("dp = " + String(dp))
        NSLog("sellingprice = " + String(txtSellingPrice.text!.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)))
        NSLog("amount_financed = " + String(amount_financed))
        
        let term = Double(selectedTerm)!
        
        var amort = ((rate / 12) * (0 - amount_financed!))
        amort = amort * (pow((1 + (rate / 12)), 12 * term) / (1 - pow((1 + (rate / 12)), 12 * term)));
        return amort
        
        
    }
    
    func getEIR(termInMonths: Int,aor: Double,isOMA: Bool) -> Double{
        NSLog("term=" + String(termInMonths))
        NSLog("aor=" + String(aor))
        
        let nper = Double(termInMonths);
        let pmt = (Double(0) - (1 + (aor/100))) / Double(termInMonths);
        let pv = Double(1);
        let fv = 0.0;
        var type = 0.00;
        if(isOMA){
            type = 1.00;
        }else{
            type = 0.00;
        }
        let guess = 0.1;
        var rate = guess;
        var f = 0.00;
        var y = 0.00;
        var x0 = 0.00;
        var x1 = 0.00;
        var y0 = 0.00;
        var y1 = 0.00;
        if (abs(rate) < 0.00000001) {
            y = pv * (1 + nper * rate)
            y = y + pmt * (1 + rate * type)
            y = y * nper + fv;
        } else {
            f = exp(nper * log(1 + rate));
            y = pv * f + pmt * (1 / rate + type)
            y = y * (f - 1) + fv;
        }
        y0 = pv + pmt * nper + fv;
        y1 = pv * f + pmt * (1 / rate + type)
        y1 = y1 * (f - 1) + fv;
        
        // find root by secant method
        var i = 0.0;
        x1 = rate;
        while ((abs(y0 - y1) > 0.00000001) && (i < 128)) {
            rate = (y1 * x0 - y0 * x1) / (y1 - y0);
            x0 = x1;
            x1 = rate;
            
            if (abs(rate) < 0.00000001) {
                y = pv * (1 + nper * rate) + pmt * (1 + rate * type) * nper + fv;
            } else {
                f = exp(nper * log(1 + rate));
                y = pv * f + pmt * (1 / rate + type) * (f - 1) + fv;
            }
            
            y0 = y1;
            y1 = y;
            ++i;
        }
        
        NSLog(String(rate * 12.00 * 100.00));
        return rate * 12.00 * 100.00;
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let tag = String(pickerView.tag)
        let index1 = tag.startIndex.advancedBy(1)
        let tagIndex = Int(tag.substringToIndex(index1))
        
        if(tagIndex == 0){
            return propertytypeArr.count
        }else if(tagIndex == 1){
            return downpaymentArr_Home.count
        }else if(tagIndex == 2){
            return homeTermsArr.count
        }else if(tagIndex == 3){
            return provinceArr.count
        }else if(tagIndex == 4){
            return civilStatusArr.count
        }else if(tagIndex == 5){
            return emptypeArr.count
        }else if(tagIndex == 6){
            return positionArr.count
        }else if(tagIndex == 7){
            return cityArr.count
        }
        return 0
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {   var titleData = ""
        let tag = String(pickerView.tag)
        let index1 = tag.startIndex.advancedBy(1)
        let tagIndex = Int(tag.substringToIndex(index1))
        
        if(tagIndex == 0){
            titleData = propertytypeArr[row].1
        }else if(tagIndex == 1){
            titleData = String(downpaymentArr_Home[row])
        }else if(tagIndex == 2){
            titleData = String(homeTermsArr[row])
        }else if(tagIndex == 3){
            titleData = String(provinceArr[row].1)
        }else if(tagIndex == 4){
            titleData = String(civilStatusArr[row].1)
        }else if(tagIndex == 5){
            titleData = String(emptypeArr[row].1)
        }else if(tagIndex == 6){
            titleData = String(positionArr[row].1)
        }else if(tagIndex == 7){
            titleData = String(cityArr[row].1)
        }
        return titleData
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let tag = String(pickerView.tag)
        let index1 = tag.startIndex.advancedBy(1)
        let tagIndex = Int(tag.substringToIndex(index1))
        
        if(tagIndex == 0){ //PROPERTY TYPE
            selectedPropertyType = propertytypeArr[row].0
        }else if(tagIndex == 1){ //DP
            selectedDP =  String(downpaymentArr_Home[row])
        }else if(tagIndex == 2){ //TERM
            selectedTerm = String(homeTermsArr[row])
        }else if(tagIndex == 3){ //PROVINCE
            selectedProvince = String(provinceArr[row].0)
            loadCityList(selectedProvince)
        }else if(tagIndex == 4){ //CIVIL STATUS
            if(pickerView.tag == 4){ //FOR CLIENT
                switch(civilStatusArr[row].0){
                case "S" :
                    splastname.enabled = false
                    spfirstname.enabled = false
                    spmiddlename.enabled = false
                    spbirthday.userInteractionEnabled = false
                    spcopycontact.enabled = false
                    spphonenumber.enabled = false
                    spmobilenumber.enabled = false
                    spaddress1.enabled = false
                    spaddress2.enabled = false
                    spemptype.userInteractionEnabled = false
                    spempname.enabled = false
                    spposition.userInteractionEnabled = false
                    spempincome.enabled = false
                    spempyears.enabled = false
                    spempaddress1.enabled = false
                    spempaddress2.enabled = false
                    spempphone.enabled = false
                    
                    spbirthday.alpha = 0.6
                    spemptype.alpha = 0.6
                    spposition.alpha = 0.6
                    
                    break
                case "M":
                    splastname.enabled = true
                    spfirstname.enabled = true
                    spmiddlename.enabled = true
                    spbirthday.userInteractionEnabled = true
                    spcopycontact.enabled = true
                    spphonenumber.enabled = true
                    spmobilenumber.enabled = true
                    spaddress1.enabled = true
                    spaddress2.enabled = true
                    spemptype.userInteractionEnabled = true
                    spempname.enabled = true
                    spposition.userInteractionEnabled = true
                    spempincome.enabled = true
                    spempyears.enabled = true
                    spempaddress1.enabled = true
                    spempaddress2.enabled = true
                    spempphone.enabled = true
                    
                    spbirthday.alpha = 1
                    spemptype.alpha = 1
                    spposition.alpha = 1
                    
                    break
                case "W":
                    splastname.enabled = false
                    spfirstname.enabled = false
                    spmiddlename.enabled = false
                    spbirthday.userInteractionEnabled = false
                    spcopycontact.enabled = false
                    spphonenumber.enabled = false
                    spmobilenumber.enabled = false
                    spaddress1.enabled = false
                    spaddress2.enabled = false
                    spemptype.userInteractionEnabled = false
                    spempname.enabled = false
                    spposition.userInteractionEnabled = false
                    spempincome.enabled = false
                    spempyears.enabled = false
                    spempaddress1.enabled = false
                    spempaddress2.enabled = false
                    spempphone.enabled = false
                    
                    spbirthday.alpha = 0.6
                    spemptype.alpha = 0.6
                    spposition.alpha = 0.6
                    
                    break
                default: break //do nothing
                }
            }
        }else if(tagIndex == 5){ //EMP TYPE
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
            }else if(pickerView.tag == 55){ //FOR SPOUSE
                switch(emptypeArr[row].0){
                case "6" :
                    spempname.enabled = false
                    spposition.userInteractionEnabled = false
                    spempincome.enabled = false
                    spempyears.enabled = false
                    spempaddress1.enabled = false
                    spempaddress2.enabled = false
                    spempphone.enabled = false
                    spposition.alpha = 0.6
                    
                    break
                case "0","1","2","3","4","5":
                    spempname.enabled = true
                    spposition.userInteractionEnabled = true
                    spempincome.enabled = true
                    spempyears.enabled = true
                    spempaddress1.enabled = true
                    spempaddress2.enabled = true
                    spempphone.enabled = true
                    spposition.alpha = 1
                    
                    break
                default: break //do nothing
                }
            }else if(pickerView.tag == 555){ //FOR C1
                switch(emptypeArr[row].0){
                case "6" :
                    c1empname.enabled = false
                    c1position.userInteractionEnabled = false
                    c1empincome.enabled = false
                    c1empyears.enabled = false
                    c1empaddress1.enabled = false
                    c1empaddress2.enabled = false
                    c1empphone.enabled = false
                    c1position.alpha = 0.6
                    
                    break
                case "0","1","2","3","4","5":
                    c1empname.enabled = true
                    c1position.userInteractionEnabled = true
                    c1empincome.enabled = true
                    c1empyears.enabled = true
                    c1empaddress1.enabled = true
                    c1empaddress2.enabled = true
                    c1empphone.enabled = true
                    c1position.alpha = 1
                    
                    break
                default: break //do nothing
                }
            }else if(pickerView.tag == 5555){ //FOR C2
                switch(emptypeArr[row].0){
                case "6" :
                    c2empname.enabled = false
                    c2position.userInteractionEnabled = false
                    c2empincome.enabled = false
                    c2empyears.enabled = false
                    c2empaddress1.enabled = false
                    c2empaddress2.enabled = false
                    c2empphone.enabled = false
                    c2position.alpha = 0.6
                    
                    break
                case "0","1","2","3","4","5":
                    c2empname.enabled = true
                    c2position.userInteractionEnabled = true
                    c2empincome.enabled = true
                    c2empyears.enabled = true
                    c2empaddress1.enabled = true
                    c2empaddress2.enabled = true
                    c2empphone.enabled = true
                    c2position.alpha = 1
                    
                    break
                default: break //do nothing
                }
            }
            
            
            
        }else if(tagIndex == 6){ //POSITION
            //selectedTerm = String(carTermsArr[row])
        }else if(tagIndex == 7){ //CITY
            selectedCity = String(cityArr[row].0)
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
        if(tagIndex == 0){ //PROPERTY TYPE
            titleData = propertytypeArr[row].1
            pickerLabel!.textAlignment = .Left
        }else if(tagIndex == 1){ //DP
            titleData =  String(downpaymentArr_Home[row])
        }else if(tagIndex == 2){ //TERM
            titleData = String(homeTermsArr[row])
        }else if(tagIndex == 3){ //PROVINCE
            titleData = String(provinceArr[row].1)
            pickerLabel!.textAlignment = .Left
        }else if(tagIndex == 4){ //CIVIL STATUS
            titleData = String(civilStatusArr[row].1)
            pickerLabel!.textAlignment = .Left
        }else if(tagIndex == 5){ //EMP TYPE
            titleData = String(emptypeArr[row].1)
            pickerLabel!.textAlignment = .Left
        }else if(tagIndex == 6){ //POSITION
            titleData = String(positionArr[row].1)
            pickerLabel!.textAlignment = .Left
        }else if(tagIndex == 7){ //CITY
            titleData = String(cityArr[row].1)
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
    @IBAction func actionSearchPropertyModel(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowPropertyModelList", sender: self)
    }
    
    @IBAction func actionShowRecentItems(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowPropertyModelListRecent", sender: self)
    }
    
    @IBOutlet var tableViewPropertyModels: UITableView!
    
    
    @IBAction func showRecentItems(sender: AnyObject) {
        loadPropertyModelsRecent()
    }
    
    func loadPropertyModelsRecent(){
        showRecent = true
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        var urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "HOMEMODELS")
        
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM1", withString: "HISTORY")
        
        var s = ""
        if (NSUserDefaults.standardUserDefaults().valueForKey("viewedProperties") != nil) {
            s = NSUserDefaults.standardUserDefaults().valueForKey("viewedProperties") as! String
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
                            self.view.userInteractionEnabled = true
                            self.loadingIndicator.hidden = true
                            self.loadingIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            let alert = UIAlertController(title: "Recently Viewed Properties Empty", message: "You have not recently viewed any property.", preferredStyle: .Alert)
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
    
    func loadPropertyModels(){
        
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        var urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "HOMEMODELS")
        
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
                                self.performSegueWithIdentifier("BackToHomeMain", sender: self)
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertyModelArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PropertyModelTableViewCell
        let (_, modeldesc, proj, _, _, srpto, areafrom, areato, _, prov, city) = self.propertyModelArr[indexPath.row]
        
        if(modeldesc != ""){
            cell.lblFirstRow.text = modeldesc.capitalizedString + " - " + proj.capitalizedString
            cell.lblThirdRow.text = city + ", " + prov
            let x = Int(srpto)
            cell.lblSecondRow.text = "PHP " + x.stringFormattedWithSepator + "(From " + areafrom + "sqm to " + areato + "sqm)"
        }
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let (modelid, modeldesc, proj, type, _, srpto, areafrom, areato, developer, prov, city) = self.propertyModelArr[indexPath.row]
        
        
        let alert = UIAlertController(title: "Options for", message: modeldesc.capitalizedString + " - " + proj.capitalizedString, preferredStyle: .ActionSheet)
        let action = UIAlertAction(title: "View Model Details", style: .Default, handler: { (alert) -> Void in
            //self.selectedCarModelId = modelid
            //self.performSegueWithIdentifier("ViewCarDetails", sender: self)
            let x = Int(srpto).stringFormattedWithSepator
            let alert_ = UIAlertController(title: "Model Details", message: "Type : " + type + "\r\n" + "Model : " + modeldesc + "\r\n" + "Project Name : " + proj + "\r\n" + "Developer : " + developer + "\r\n" + "SRP : PHP " + x + "\r\nArea (sqm) : " + areafrom + " - " + areato + "\r\nLocation : " + city + ", " + prov + "\r\n", preferredStyle: .Alert)
            let action_ = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
            })
            alert_.addAction(action_)
            self.presentViewController(alert_, animated: true, completion: nil)
            
            //SAVE SELECTED TO RECENTLY VIEWED ITEM
            let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
            if (userDefaults.objectForKey("viewedProperties") != nil) {
                let s = NSUserDefaults.standardUserDefaults().valueForKey("viewedProperties") as! String
                
                let arr = s.characters.split{$0 == ","}.map(String.init)
                var selectedModelId_viewed = false
                for(mId) in arr{
                    if(mId == modelid){
                        selectedModelId_viewed = true
                    }
                }
                if(!selectedModelId_viewed){
                    NSUserDefaults.standardUserDefaults().setObject(s + "," + modelid, forKey: "viewedProperties")
                }
            }else{
                NSUserDefaults.standardUserDefaults().setObject(modelid, forKey: "viewedProperties")
            }
            
            
            
        })
        alert.addAction(action)
        let action2 = UIAlertAction(title: "Home Loan Calculator", style: .Default, handler: { (alert) -> Void in
            self.selectedPropertyModelId = modelid
            self.selectedPropertyModelSRP = Int(self.propertyModelArr[indexPath.row].5)
            self.selectedPropertyProj = proj
            self.selectedPropertyDeveloper = developer
            
            //SAVE SELECTED TO RECENTLY VIEWED ITEM
            let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
            if (userDefaults.objectForKey("viewedProperties") != nil) {
                let s = NSUserDefaults.standardUserDefaults().valueForKey("viewedProperties") as! String
                
                let arr = s.characters.split{$0 == ","}.map(String.init)
                var selectedModelId_viewed = false
                for(mId) in arr{
                    if(mId == modelid){
                        selectedModelId_viewed = true
                    }
                }
                if(!selectedModelId_viewed){
                    NSUserDefaults.standardUserDefaults().setObject(s + "," + modelid, forKey: "viewedProperties")
                }
            }else{
                NSUserDefaults.standardUserDefaults().setObject(modelid, forKey: "viewedProperties")
            }
            
            
            self.performSegueWithIdentifier("HomeLoanCalculator", sender: self)
        })
        alert.addAction(action2)
        let action3 = UIAlertAction(title: "Apply for Home Loan", style: .Default, handler: { (alert) -> Void in
            self.selectedPropertyModelId = modelid
            self.selectedPropertyModelSRP = Int(self.propertyModelArr[indexPath.row].5)
            self.selectedPropertyProj = proj
            self.selectedPropertyDeveloper = developer
            
            //SAVE SELECTED TO RECENTLY VIEWED ITEM
            let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
            if (userDefaults.objectForKey("viewedVehicles") != nil) {
                let s = NSUserDefaults.standardUserDefaults().valueForKey("viewedProperties") as! String
                
                let arr = s.characters.split{$0 == ","}.map(String.init)
                var selectedModelId_viewed = false
                for(mId) in arr{
                    if(mId == modelid){
                        selectedModelId_viewed = true
                    }
                }
                if(!selectedModelId_viewed){
                    NSUserDefaults.standardUserDefaults().setObject(s + "," + modelid, forKey: "viewedProperties")
                }
            }else{
                NSUserDefaults.standardUserDefaults().setObject(modelid, forKey: "viewedProperties")
            }
            
            
            self.performSegueWithIdentifier("ApplyLoanDirect", sender: self)
            
        })
        alert.addAction(action3)
        
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
    
    
    @IBAction func actionApplyLoan(sender: AnyObject) {
        self.performSegueWithIdentifier("ApplyLoan", sender: self)
    }
    
    
    @IBOutlet var downpayment: UIPickerView!
    @IBOutlet var loanterm: UIPickerView!
    @IBOutlet var cashprice: UITextField!
    @IBOutlet var lastname: UITextField!
    @IBOutlet var firstname: UITextField!
    @IBOutlet var middlename: UITextField!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var birthday: UIDatePicker!
    @IBOutlet var civilstatus: UIPickerView!
    @IBOutlet var phonenumber: UITextField!
    @IBOutlet var mobilenumber: UITextField!
    @IBOutlet var emailaddress: UITextField!
    @IBOutlet var address1: UITextField!
    @IBOutlet var address2: UITextField!
    @IBOutlet var emptype: UIPickerView!
    @IBOutlet var empname: UITextField!
    @IBOutlet var position: UIPickerView!
    @IBOutlet var empincome: UITextField!
    @IBOutlet var empyears: UITextField!
    @IBOutlet var empaddress1: UITextField!
    @IBOutlet var empaddress2: UITextField!
    @IBOutlet var empphone: UITextField!
    
    @IBOutlet var splastname: UITextField!
    @IBOutlet var spfirstname: UITextField!
    @IBOutlet var spmiddlename: UITextField!
    @IBOutlet var spbirthday: UIDatePicker!
    @IBOutlet var spcopycontact: UISwitch!
    @IBOutlet var spphonenumber: UITextField!
    @IBOutlet var spmobilenumber: UITextField!
    @IBOutlet var spaddress1: UITextField!
    @IBOutlet var spaddress2: UITextField!
    @IBOutlet var spemptype: UIPickerView!
    @IBOutlet var spempname: UITextField!
    @IBOutlet var spposition: UIPickerView!
    @IBOutlet var spempincome: UITextField!
    @IBOutlet var spempyears: UITextField!
    @IBOutlet var spempaddress1: UITextField!
    @IBOutlet var spempaddress2: UITextField!
    @IBOutlet var spempphone: UITextField!
    
    @IBOutlet var withc1: UISwitch!
    @IBOutlet var withc2: UISwitch!
    
    @IBOutlet var c1lastname: UITextField!
    @IBOutlet var c1firstname: UITextField!
    @IBOutlet var c1middlename: UITextField!
    @IBOutlet var c1birthday: UIDatePicker!
    @IBOutlet var c1gender: UISegmentedControl!
    @IBOutlet var c1civilstatus: UIPickerView!
    @IBOutlet var c1phonenumber: UITextField!
    @IBOutlet var c1mobilenumber: UITextField!
    @IBOutlet var c1address1: UITextField!
    @IBOutlet var c1address2: UITextField!
    @IBOutlet var c1emptype: UIPickerView!
    @IBOutlet var c1empname: UITextField!
    @IBOutlet var c1position: UIPickerView!
    @IBOutlet var c1empincome: UITextField!
    @IBOutlet var c1empyears: UITextField!
    @IBOutlet var c1empaddress1: UITextField!
    @IBOutlet var c1empaddress2: UITextField!
    @IBOutlet var c1empphone: UITextField!
    
    @IBOutlet var c2lastname: UITextField!
    @IBOutlet var c2firstname: UITextField!
    @IBOutlet var c2middlename: UITextField!
    @IBOutlet var c2birthday: UIDatePicker!
    @IBOutlet var c2gender: UISegmentedControl!
    @IBOutlet var c2civilstatus: UIPickerView!
    @IBOutlet var c2phonenumber: UITextField!
    @IBOutlet var c2mobilenumber: UITextField!
    @IBOutlet var c2address1: UITextField!
    @IBOutlet var c2address2: UITextField!
    @IBOutlet var c2emptype: UIPickerView!
    @IBOutlet var c2empname: UITextField!
    @IBOutlet var c2position: UIPickerView!
    @IBOutlet var c2empincome: UITextField!
    @IBOutlet var c2empyears: UITextField!
    @IBOutlet var c2empaddress1: UITextField!
    @IBOutlet var c2empaddress2: UITextField!
    @IBOutlet var c2empphone: UITextField!
    
    func loadAppForm(){
        self.loadingIndicator.hidden = false
        self.loadingIndicator.startAnimating()
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        self.loadEmpTypePicker()
        self.loadPositionPicker()
    
        
        splastname.enabled = false
        spfirstname.enabled = false
        spmiddlename.enabled = false
        spbirthday.userInteractionEnabled = false
        spcopycontact.enabled = false
        spphonenumber.enabled = false
        spmobilenumber.enabled = false
        spaddress1.enabled = false
        spaddress2.enabled = false
        spemptype.userInteractionEnabled = false
        spempname.enabled = false
        spposition.userInteractionEnabled = false
        spempincome.enabled = false
        spempyears.enabled = false
        spempaddress1.enabled = false
        spempaddress2.enabled = false
        spempphone.enabled = false
        
        spbirthday.alpha = 0.6
        spemptype.alpha = 0.6
        spposition.alpha = 0.6
        
        c1lastname.enabled = false
        c1firstname.enabled = false
        c1middlename.enabled = false
        c1birthday.userInteractionEnabled = false
        c1civilstatus.userInteractionEnabled = false
        c1gender.enabled = false
        c1phonenumber.enabled = false
        c1mobilenumber.enabled = false
        c1address1.enabled = false
        c1address2.enabled = false
        c1emptype.userInteractionEnabled = false
        c1empname.enabled = false
        c1position.userInteractionEnabled = false
        c1empincome.enabled = false
        c1empyears.enabled = false
        c1empaddress1.enabled = false
        c1empaddress2.enabled = false
        c1empphone.enabled = false
        
        c1birthday.alpha = 0.6
        c1civilstatus.alpha = 0.6
        c1emptype.alpha = 0.6
        c1position.alpha = 0.6
        
        withc2.enabled = false
        c2lastname.enabled = false
        c2firstname.enabled = false
        c2middlename.enabled = false
        c2birthday.userInteractionEnabled = false
        c2civilstatus.userInteractionEnabled = false
        c2gender.enabled = false
        c2phonenumber.enabled = false
        c2mobilenumber.enabled = false
        c2address1.enabled = false
        c2address2.enabled = false
        c2emptype.userInteractionEnabled = false
        c2empname.enabled = false
        c2position.userInteractionEnabled = false
        c2empincome.enabled = false
        c2empyears.enabled = false
        c2empaddress1.enabled = false
        c2empaddress2.enabled = false
        c2empphone.enabled = false
        
        c2birthday.alpha = 0.6
        c2civilstatus.alpha = 0.6
        c2emptype.alpha = 0.6
        c2position.alpha = 0.6
        
        
        
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
        
        splastname.delegate = self
        spfirstname.delegate = self
        spmiddlename.delegate = self
        spphonenumber.delegate = self
        spmobilenumber.delegate = self
        spaddress1.delegate = self
        spaddress2.delegate = self
        spempname.delegate = self
        spempincome.delegate = self
        spempyears.delegate = self
        spempaddress1.delegate = self
        spempaddress2.delegate = self
        spempphone.delegate = self
        
        c1lastname.delegate = self
        c1firstname.delegate = self
        c1middlename.delegate = self
        c1phonenumber.delegate = self
        c1mobilenumber.delegate = self
        c1address1.delegate = self
        c1address2.delegate = self
        c1empname.delegate = self
        c1empincome.delegate = self
        c1empyears.delegate = self
        c1empaddress1.delegate = self
        c1empaddress2.delegate = self
        c1empphone.delegate = self
        
        c2lastname.delegate = self
        c2firstname.delegate = self
        c2middlename.delegate = self
        c2phonenumber.delegate = self
        c2mobilenumber.delegate = self
        c2address1.delegate = self
        c2address2.delegate = self
        c2empname.delegate = self
        c2empincome.delegate = self
        c2empyears.delegate = self
        c2empaddress1.delegate = self
        c2empaddress2.delegate = self
        c2empphone.delegate = self
        
    }
    
    func loadEmpTypePicker(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        //self.view.userInteractionEnabled = false
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "EMPTYPE")
        
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
                                if(str2[1] != ""){
                                    self.emptypeArr.append((str2[1], str2[0]))
                                    if(i == 0){
                                        //self.selectedCarBrand = self.carBrandArr[i].0
                                    }
                                }
                            }
                            self.emptype.reloadAllComponents()
                            self.spemptype.reloadAllComponents()
                            self.c1emptype.reloadAllComponents()
                            self.c2emptype.reloadAllComponents()
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
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "JOBPOS")
        
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
                                if(str2[1] != ""){
                                    self.positionArr.append((str2[1], str2[0]))
                                    if(i == 0){
                                        //self.selectedCarBrand = self.carBrandArr[i].0
                                    }
                                }
                            }
                            self.position.reloadAllComponents()
                            self.spposition.reloadAllComponents()
                            self.c1position.reloadAllComponents()
                            self.c2position.reloadAllComponents()
                            
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
    
    @IBAction func actionCopyContacts(sender: AnyObject) {
        spphonenumber.text = phonenumber.text
        spmobilenumber.text = mobilenumber.text
        spaddress1.text = address1.text
        spaddress2.text = address2.text
    }
    
    @IBAction func actionWithC1(sender: AnyObject) {
        if(self.withc1.on == true){
            c1lastname.enabled = true
            c1firstname.enabled = true
            c1middlename.enabled = true
            c1birthday.userInteractionEnabled = true
            c1civilstatus.userInteractionEnabled = true
            c1gender.enabled = true
            c1phonenumber.enabled = true
            c1mobilenumber.enabled = true
            c1address1.enabled = true
            c1address2.enabled = true
            c1emptype.userInteractionEnabled = true
            
            c1empname.enabled = true
            c1position.userInteractionEnabled = true
            c1empincome.enabled = true
            c1empyears.enabled = true
            c1empaddress1.enabled = true
            c1empaddress2.enabled = true
            c1empphone.enabled = true
            withc2.enabled = true
            
            c1birthday.alpha = 1
            c1civilstatus.alpha = 1
            c1emptype.alpha = 1
            c1position.alpha = 1
        }else{
            c1lastname.enabled = false
            c1firstname.enabled = false
            c1middlename.enabled = false
            c1birthday.userInteractionEnabled = false
            c1civilstatus.userInteractionEnabled = false
            c1gender.enabled = false
            c1phonenumber.enabled = false
            c1mobilenumber.enabled = false
            c1address1.enabled = false
            c1address2.enabled = false
            c1emptype.userInteractionEnabled = false
            c1empname.enabled = false
            c1position.userInteractionEnabled = false
            c1empincome.enabled = false
            c1empyears.enabled = false
            c1empaddress1.enabled = false
            c1empaddress2.enabled = false
            c1empphone.enabled = false
            withc2.enabled = false
            
            c1birthday.alpha = 0.6
            c1civilstatus.alpha = 0.6
            c1emptype.alpha = 0.6
            c1position.alpha = 0.6
            
            withc2.on = false
            c2lastname.enabled = false
            c2firstname.enabled = false
            c2middlename.enabled = false
            c2birthday.userInteractionEnabled = false
            c2civilstatus.userInteractionEnabled = false
            c2gender.enabled = false
            c2phonenumber.enabled = false
            c2mobilenumber.enabled = false
            c2address1.enabled = false
            c2address2.enabled = false
            c2emptype.userInteractionEnabled = false
            c2empname.enabled = false
            c2position.userInteractionEnabled = false
            c2empincome.enabled = false
            c2empyears.enabled = false
            c2empaddress1.enabled = false
            c2empaddress2.enabled = false
            c2empphone.enabled = false
            
            c2birthday.alpha = 0.6
            c2civilstatus.alpha = 0.6
            c2emptype.alpha = 0.6
            c2position.alpha = 0.6
            
        }
    }
    
    
    @IBAction func actionWithC2(sender: AnyObject) {
        if(self.withc2.on == true){
            c2lastname.enabled = true
            c2firstname.enabled = true
            c2middlename.enabled = true
            c2birthday.userInteractionEnabled = true
            c2civilstatus.userInteractionEnabled = true
            c2gender.enabled = true
            c2phonenumber.enabled = true
            c2mobilenumber.enabled = true
            c2address1.enabled = true
            c2address2.enabled = true
            c2emptype.userInteractionEnabled = true
            
            c2empname.enabled = true
            c2position.userInteractionEnabled = true
            c2empincome.enabled = true
            c2empyears.enabled = true
            c2empaddress1.enabled = true
            c2empaddress2.enabled = true
            c2empphone.enabled = true
            
            c2birthday.alpha = 1
            c2civilstatus.alpha = 1
            c2emptype.alpha = 1
            c2position.alpha = 1
        }else{
            c2lastname.enabled = false
            c2firstname.enabled = false
            c2middlename.enabled = false
            c2birthday.userInteractionEnabled = false
            c2civilstatus.userInteractionEnabled = false
            c2gender.enabled = false
            c2phonenumber.enabled = false
            c2mobilenumber.enabled = false
            c2address1.enabled = false
            c2address2.enabled = false
            c2emptype.userInteractionEnabled = false
            c2empname.enabled = false
            c2position.userInteractionEnabled = false
            c2empincome.enabled = false
            c2empyears.enabled = false
            c2empaddress1.enabled = false
            c2empaddress2.enabled = false
            c2empphone.enabled = false
            
            c2birthday.alpha = 0.6
            c2civilstatus.alpha = 0.6
            c2emptype.alpha = 0.6
            c2position.alpha = 0.6
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
        
        
        let url = NSLocalizedString("urlCREST", comment: "")
        
        var stringUrl = url
        
        var errorctr = 0;
        var errormsg = "";
        stringUrl = stringUrl + "&companyid=" + self.id;
        
        
        stringUrl = stringUrl + "&model=" + self.selectedPropertyModelId.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&selling_price=" + self.cashprice.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&project=" + self.selectedPropertyProj.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&developer=" + self.selectedPropertyDeveloper.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&downpaymentpct=" + String(downpaymentArr[self.downpayment.selectedRowInComponent(0)])
        stringUrl = stringUrl + "&term=" + String(homeTermsArr[self.loanterm.selectedRowInComponent(0)]).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&ao=" + homeInfo[0].stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&appsource=" + (self.id != "NON" ? "WAP" : "Online Application").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!; //CHECK WITH LIBFIELDVALUES
        stringUrl = stringUrl + "&rm=" + "";
        stringUrl = stringUrl + "&sourcearea=" + "Not Applicable".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&sourcetype=" + "Head Office".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&clientclass=" + (self.id != "NON" ? "WAP (WORKPLACE ARRANGEMENT PROGR" : "REGULAR").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!; //ADD TO LIBFIELDVALUES = REGULAR
        stringUrl = stringUrl + "&clienttype=" + "0".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        if(self.lastname.text == ""){
            errorctr++;
            errormsg += "Last Name\n";
        }
        if(self.firstname.text == ""){
            errorctr++;
            errormsg += "First Name\n";
        }
        if(self.mobilenumber.text == ""){ //CHECK IF VALID PHONE
            errorctr++;
            errormsg += "Mobile No\n";
        }
        if(self.emailaddress.text == "" || isValidEmail(self.emailaddress.text!) == false){ //CHECK IF VALID EMAIL
            errorctr++;
            errormsg += "Email Address\n";
        }
        if(self.address1.text == ""){
            errorctr++;
            errormsg += "Res Address\n";
        }
        
        if(emptypeArr[self.emptype.selectedRowInComponent(0)].0 != "6"){
            if(self.empname.text == ""){
                errorctr++;
                errormsg += "Emp/Biz Name\n";
            }
            if(self.empincome.text == ""){ //CHECK IF VALID AMOUNT
                errorctr++;
                errormsg += "Emp/Biz Income\n";
            }
            if(self.empaddress1.text == ""){
                errorctr++;
                errormsg += "Emp/Biz Address\n";
            }
            if(self.empphone.text == ""){
                errorctr++;
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
        
        stringUrl = stringUrl + "&gender=" + (self.gender.selectedSegmentIndex == 0 ? "0" : "1")
        
        stringUrl = stringUrl + "&civilstat=" + (civilStatusArr[self.civilstatus.selectedRowInComponent(0)].0).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&resphone=" + self.phonenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&mobileno=" + self.mobilenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&email=" + self.emailaddress.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&resadd1=" + self.address1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&resadd2=" + self.address2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&empbiz_type=" + emptypeArr[self.emptype.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&empbizname=" + self.empname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&jobpos=" + positionArr[self.position.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&empbiz_y=" + self.empyears.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&empbizadd1=" + self.empaddress1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&empbizadd2=" + self.empaddress2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&empbizphone=" + self.empphone.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&empbizmoincome=" + self.empincome.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        if(civilStatusArr[self.civilstatus.selectedRowInComponent(0)].0 == "M"){
            
            if(self.splastname.text == ""){
                errorctr++;
                errormsg += "SP Last Name\n";
            }
            if(self.spfirstname.text == ""){
                errorctr++;
                errormsg += "SP First Name\n";
            }
            if(self.spmobilenumber.text == ""){
                errorctr++;
                errormsg += "SP Mobile No\n";
            }
            if(self.spaddress1.text == ""){
                errorctr++;
                errormsg += "SP Res Address\n";
            }
            
            if(emptypeArr[self.spemptype.selectedRowInComponent(0)].0 != "6"){
                if(self.spempname.text == ""){
                    errorctr++;
                    errormsg += "SP Emp/Biz Name\n";
                }
                if(self.spempincome.text == ""){ //CHECK IF VALID AMOUNT
                    errorctr++;
                    errormsg += "SP Emp/Biz Income\n";
                }
                if(self.spempaddress1.text == ""){
                    errorctr++;
                    errormsg += "SP Emp/Biz Address\n";
                }
                if(self.spempphone.text == ""){
                    errorctr++;
                    errormsg += "SP Emp/Biz Phone\n";
                }
            }
            
            stringUrl = stringUrl + "&splname=" + self.splastname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&spfname=" + self.spfirstname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&spmname=" + self.spmiddlename.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            let bday = self.spbirthday.date
            let dateStr = bday.dateFormatted
            stringUrl = stringUrl + "&spbday=" + dateStr.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&spresphone=" + self.spphonenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&spmobileno=" + self.spmobilenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&spresadd1=" + self.spaddress1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&spresadd2=" + self.spaddress2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&spempbiz_type=" + emptypeArr[self.spemptype.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&spempbizname=" + self.spempname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&spjobpos=" + positionArr[self.spposition.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&spempbiz_y=" + self.spempyears.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&spempbizadd1=" + self.spempaddress1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&spempbizadd2=" + self.spempaddress2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&spempbizphone=" + self.spempphone.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&spempbizmoincome=" + self.spempincome.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        }
        
        if(self.withc1.on == true){
            
            
            if(self.c1lastname.text == ""){
                errorctr++;
                errormsg += "C1 Last Name\n";
            }
            if(self.c1firstname.text == ""){
                errorctr++;
                errormsg += "C1 First Name\n";
            }
            if(self.c1mobilenumber.text == ""){
                errorctr++;
                errormsg += "C1 Mobile No\n";
            }
            if(self.c1address1.text == ""){
                errorctr++;
                errormsg += "C1 Res Address\n";
            }
            
            if(emptypeArr[self.c1emptype.selectedRowInComponent(0)].0 != "6"){
                if(self.c1empname.text == ""){
                    errorctr++;
                    errormsg += "C1 Emp/Biz Name\n";
                }
                if(self.c1empincome.text == ""){ //CHECK IF VALID AMOUNT
                    errorctr++;
                    errormsg += "C1 Emp/Biz Income\n";
                }
                if(self.c1empaddress1.text == ""){
                    errorctr++;
                    errormsg += "C1 Emp/Biz Address\n";
                }
                if(self.c1empphone.text == ""){
                    errorctr++;
                    errormsg += "C1 Emp/Biz Phone\n";
                }
            }
            
            
            stringUrl = stringUrl + "&m1lname=" + self.c1lastname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1fname=" + self.c1firstname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1mname=" + self.c1middlename.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            let bday = self.c1birthday.date
            let dateStr = bday.dateFormatted
            stringUrl = stringUrl + "&m1bday=" + dateStr.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&m1gender=" + (self.c1gender.selectedSegmentIndex == 0 ? "0" : "1")
            stringUrl = stringUrl + "&m1resphone=" + self.c1phonenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1mobileno=" + self.c1mobilenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1resadd1=" + self.c1address1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1resadd2=" + self.c1address2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&m1empbiz_type=" + emptypeArr[self.c1emptype.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&m1empbizname=" + self.c1empname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&m1jobpos=" + positionArr[self.c1position.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&m1empbiz_y=" + self.c1empyears.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1empbizadd1=" + self.c1empaddress1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1empbizadd2=" + self.c1empaddress2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1empbizphone=" + self.c1empphone.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1empbizmoincome=" + self.c1empincome.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        }
        
        if(self.withc2.on == true){
            
            
            if(self.c2lastname.text == ""){
                errorctr++;
                errormsg += "C2 Last Name\n";
            }
            if(self.c2firstname.text == ""){
                errorctr++;
                errormsg += "C2 First Name\n";
            }
            if(self.c2mobilenumber.text == ""){
                errorctr++;
                errormsg += "C2 Mobile No\n";
            }
            if(self.c2address1.text == ""){
                errorctr++;
                errormsg += "C2 Res Address\n";
            }
            
            if(emptypeArr[self.c2emptype.selectedRowInComponent(0)].0 != "6"){
                if(self.c2empname.text == ""){
                    errorctr++;
                    errormsg += "C2 Emp/Biz Name\n";
                }
                if(self.c2empincome.text == ""){ //CHECK IF VALID AMOUNT
                    errorctr++;
                    errormsg += "C2 Emp/Biz Income\n";
                }
                if(self.c2empaddress1.text == ""){
                    errorctr++;
                    errormsg += "C2 Emp/Biz Address\n";
                }
                if(self.c2empphone.text == ""){
                    errorctr++;
                    errormsg += "C2 Emp/Biz Phone\n";
                }
            }
            
            
            stringUrl = stringUrl + "&m2lname=" + self.c2lastname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2fname=" + self.c2firstname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2mname=" + self.c2middlename.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            let bday = self.c2birthday.date
            let dateStr = bday.dateFormatted
            stringUrl = stringUrl + "&m2bday=" + dateStr.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&m2gender=" + (self.c2gender.selectedSegmentIndex == 0 ? "0" : "1")
            stringUrl = stringUrl + "&m2resphone=" + self.c2phonenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2mobileno=" + self.c2mobilenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2resadd1=" + self.c2address1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2resadd2=" + self.c2address2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&m2empbiz_type=" + emptypeArr[self.c2emptype.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&m2empbizname=" + self.c2empname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&m2jobpos=" + positionArr[self.c2position.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&m2empbiz_y=" + self.c2empyears.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2empbizadd1=" + self.c2empaddress1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2empbizadd2=" + self.c2empaddress2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2empbizphone=" + self.c2empphone.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2empbizmoincome=" + self.c2empincome.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
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
            
            
            let entityDescription = NSEntityDescription.entityForName("UrlStrings", inManagedObjectContext: manageObjectContext)
            let url = UrlStrings(entity:entityDescription!, insertIntoManagedObjectContext: manageObjectContext)
            url.url = stringUrl
            url.datecreated = String(NSDate())
            url.refid = "HOME"
            url.datesuccess = "0"
            
            self.view.userInteractionEnabled = true
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "Application Submitted", message: "Your new home loan application has been saved for submission. Please make sure not to quit the app and to have a stable data connection for a few minutes. You will receive an alert once it has been successfully sent.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                self.performSegueWithIdentifier("BackToHomeMain", sender: self)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    @IBAction func actionApplyDirectFromMain(sender: AnyObject) {
        self.performSegueWithIdentifier("ApplyLoanDirectFromMain", sender: self)
    }
    
    
    @IBAction func actionCalculatorDirect(sender: AnyObject) {
        self.performSegueWithIdentifier("HomeLoanCalculatorDirect", sender: self)
    }
    
    
    @IBAction func actionInquiry(sender: AnyObject) {
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
            if(self.prevPage == "mainHome"){
                self.performSegueWithIdentifier("BackToHomeMain", sender: self)
            }
            if(self.prevPage == "propertyModelList"){
                self.performSegueWithIdentifier("ShowPropertyModelList", sender: self)
            }
            if(self.prevPage == "propertyModelListRecent"){
                self.performSegueWithIdentifier("ShowPropertyModelListRecent", sender: self)
            }
            if(self.prevPage == "homeLoanCalculator"){
                self.performSegueWithIdentifier("HomeLoanCalculator", sender: self)
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
        if (userDefaults.objectForKey("homeInfo") != nil) {
            self.homeInfo = NSUserDefaults.standardUserDefaults().valueForKey("homeInfo") as! [String]
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
        if segue.identifier == "ShowPropertyModelList"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerHome{
                destinationVC.vcAction = "ShowPropertyModelList"
                destinationVC.id = self.id
                destinationVC.selectedPropertyType = selectedPropertyType
                destinationVC.selectedPriceFrom = selectedPriceFrom
                destinationVC.selectedPriceTo = selectedPriceTo
                destinationVC.selectedPriceFrom = selectedPriceFrom
                destinationVC.selectedPriceTo = selectedPriceTo
                destinationVC.selectedProvince = selectedProvince
                destinationVC.selectedCity = selectedCity
                destinationVC.prevPage = "main"
            }
        }
        
        if segue.identifier == "BackToHomeMain"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerHome{
                destinationVC.vcAction = ""
                destinationVC.id = self.id
                destinationVC.selectedPropertyType = selectedPropertyType
                destinationVC.selectedPriceFrom = selectedPriceFrom
                destinationVC.selectedPriceTo = selectedPriceTo
                destinationVC.selectedProvince = selectedProvince
                destinationVC.selectedCity = selectedCity
            }
        }
        
        if segue.identifier == "ShowPropertyModelListRecent"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerHome{
                destinationVC.vcAction = "ShowPropertyModelListRecent"
                destinationVC.id = self.id
                destinationVC.prevPage = "main"
                destinationVC.selectedPropertyType = selectedPropertyType
                destinationVC.selectedPriceFrom = selectedPriceFrom
                destinationVC.selectedPriceTo = selectedPriceTo
                destinationVC.selectedProvince = selectedProvince
                destinationVC.selectedCity = selectedCity
            }
        }
        if segue.identifier == "HomeLoanCalculator"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerHome{
                destinationVC.vcAction = "HomeLoanCalculator"
                destinationVC.id = self.id
                destinationVC.selectedPropertyModelId = selectedPropertyModelId
                destinationVC.selectedPropertyModelSRP = selectedPropertyModelSRP
                destinationVC.selectedPropertyType = selectedPropertyType
                destinationVC.selectedPriceFrom = selectedPriceFrom
                destinationVC.selectedPriceTo = selectedPriceTo
                destinationVC.selectedProvince = selectedProvince
                destinationVC.selectedCity = selectedCity
                destinationVC.showRecent = showRecent
                if(!showRecent){
                    destinationVC.prevPage = "propertyModelList"
                }else{
                    destinationVC.prevPage = "propertyModelListRecent"
                }
            }
        }
        if segue.identifier == "HomeLoanCalculatorDirect"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerHome{
                destinationVC.vcAction = "HomeLoanCalculator"
                destinationVC.id = self.id
                destinationVC.showRecent = showRecent
                destinationVC.prevPage = "mainHome"
                
            }
        }
        
        if segue.identifier == "ApplyLoan"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerHome{
                destinationVC.vcAction = "apply"
                destinationVC.id = self.id
                destinationVC.prevPage = "homeLoanCalculator"
                destinationVC.selectedPropertyModelId = selectedPropertyModelId
                destinationVC.selectedPropertyModelSRP = selectedPropertyModelSRP
                destinationVC.selectedPropertyType = selectedPropertyType
                destinationVC.selectedPriceFrom = selectedPriceFrom
                destinationVC.selectedPriceTo = selectedPriceTo
                destinationVC.selectedProvince = selectedProvince
                destinationVC.selectedCity = selectedCity
                destinationVC.showRecent = showRecent
                
            }
        }
        if segue.identifier == "ApplyLoanDirect"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerHome{
                destinationVC.vcAction = "apply"
                destinationVC.id = self.id
                destinationVC.selectedPropertyModelId = selectedPropertyModelId
                destinationVC.selectedPropertyModelSRP = selectedPropertyModelSRP
                destinationVC.selectedPropertyType = selectedPropertyType
                destinationVC.selectedPriceFrom = selectedPriceFrom
                destinationVC.selectedPriceTo = selectedPriceTo
                destinationVC.selectedProvince = selectedProvince
                destinationVC.selectedCity = selectedCity
                destinationVC.showRecent = showRecent
                if(!showRecent){
                    destinationVC.prevPage = "propertyModelList"
                }else{
                    destinationVC.prevPage = "propertyModelListRecent"
                }
            }
        }
        if segue.identifier == "ApplyLoanDirectFromMain"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerHome{
                destinationVC.vcAction = "apply"
                destinationVC.id = self.id
                destinationVC.showRecent = showRecent
                destinationVC.prevPage = "mainHome"
                
            }
        }
        if segue.identifier == "Inquiry"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerInquiry{
                destinationVC.id = self.id
                destinationVC.prevPage = "HomeMain"
                destinationVC.product = "Home Loan"
                destinationVC.selectedPropertyType = selectedPropertyType
                destinationVC.selectedPriceFrom = selectedPriceFrom
                destinationVC.selectedPriceTo = selectedPriceTo
                destinationVC.selectedProvince = selectedProvince
                destinationVC.selectedCity = selectedCity
                destinationVC.showRecent = showRecent
            }
        }
        if segue.identifier == "FAQ"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerFAQ{
                destinationVC.id = self.id
                destinationVC.prevPage = "HomeMain"
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
    
    struct PropertyModelData {
        var firstRowLabel:String
        var secondRowLabel:String
        var thirdRowLabel:String
    }
}

