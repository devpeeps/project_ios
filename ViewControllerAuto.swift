//
//  ViewControllerAuto.swift
//  elysium
//
//  Created by Joshua Eleazar Bosinos on 08/01/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerAuto: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    var id = ""
    var name = ""
    var email = ""
    var autoInfo = ["","","",""]
    var homeInfo = ["","",""]
    var ccInfo = ["","","",""]
    var autoRates = [("",0.00)]
    var homeRates = [("",0.00)]
    
    var urlLib = ""
    var vcAction = ""
    var withConnection = false
    var carBrandArr = [("Choose Car Brand","")]
    var carModelArr = [("","","","")]
    var carTermsArr = [60,48,36,24,18,12]
    var homeTermsArr = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    var downpaymentArr2 = [10,20,30,40,50,60,70,80,90]
    var downpaymentArr = [20,30,40,50,60,70,80,90]
    var downpaymentArr_Home = [10,20,30,40,50,60,70,80,90]
    var civilStatusArr = [("S","Single"),("M","Married"),("W","Widow/er")]
    var emptypeArr = [("","")]
    var positionArr = [("","")]
    var selectedCarBrand = ""
    var selectedCarModelId = ""
    var selectedCarModelSRP = 0
    var prevPage = ""
    var selectedTerm = "60"
    var selectedDP = "20"
    var selectedCivilStat = ""
    var selectedWithC1 = false
    var selectedWithC2 = false
    
    var showRecent = false
    
    @IBOutlet var scrollview: UIScrollView!
    
    let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewControllerAuto.DismissKeyboard))
        view.addGestureRecognizer(dismiss)
        dismiss.cancelsTouchesInView = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewControllerAuto.keyboardWasShown(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewControllerAuto.keyboardWasNotShown(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        // Do any additional setup after loading the view.
        checkIfLogged()
        
        if(vcAction == ""){
            prevPage = "main"
            loadCarBrandList()
        }
        
        if(vcAction == "apply"){
            scrollview.contentSize = CGSize(width:400, height:2200)
            
            loadAppForm()
        }
        
        if(vcAction == "ShowCarModelList"){
            loadCarModels(self.selectedCarBrand)
        }
        if(vcAction == "ShowCarModelListRecent"){
            loadCarModelsRecent()
        }
        
        if(vcAction == "AutoLoanCalculator"){
            if(autoInfo[3] == "Y"){
                selectedDP = "10"
            }
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
                                    if(self.selectedCarBrand != ""){
                                        if(self.carBrandArr[i].0 == self.selectedCarBrand){
                                            //self.selectedCarBrand = self.carBrandArr[i].0
                                        }
                                    }else{
                                        if(i == 0){
                                            self.selectedCarBrand = self.carBrandArr[i].0
                                        }
                                    }
                                }
                            }
                            self.pickerCarBrand.reloadAllComponents()
                            self.view.userInteractionEnabled = true
                            self.loadingIndicator.hidden = true
                            self.loadingIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            for i in 0...str.count - 1{
                                if(str[i] != ""){
                                    if(self.selectedCarBrand != ""){
                                        if(self.carBrandArr[i].0 == self.selectedCarBrand){
                                            self.pickerCarBrand.selectRow(i, inComponent: 0, animated: false)
                                            break
                                        }
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
    
    
    @IBOutlet var txtSellingPrice: UITextField!
    @IBOutlet var txtMonthlyAmort: UITextField!
    @IBOutlet var pickerDP: UIPickerView!
    @IBOutlet var pickerTerm: UIPickerView!
    
    func loadCalculatorValues(){
        
        txtSellingPrice.text = self.selectedCarModelSRP.stringFormattedWithSepator
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

        if (userDefaults.objectForKey("autoRates_" + self.selectedTerm) != nil) {
            aor = NSUserDefaults.standardUserDefaults().objectForKey("autoRates_" + self.selectedTerm) as! Double
        }
        
        let rate = getEIR(Int(selectedTerm)!, aor: aor ,isOMA: false);
        let dp = Double(selectedDP)
        var amount_financed = Double(txtSellingPrice.text!.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))
        amount_financed = amount_financed! - (amount_financed! * (dp! / 100))
        NSLog("dp = " + String(dp))
        NSLog("sellingprice = " + String(txtSellingPrice.text!.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)))
        NSLog("amount_financed = " + String(amount_financed))
        
        let term = Double(selectedTerm)!
        
        var amort = ((rate / 1200) * (0 - amount_financed!))
        amort = amort * (pow((1 + (rate / 1200)), term) / (1 - pow((1 + (rate / 1200)), term)));
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
            i += 1;
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
            return carBrandArr.count
        }else if(tagIndex == 1){
            if(autoInfo[3] == "Y"){
                return downpaymentArr2.count
            }else{
                return downpaymentArr.count
            }
        }else if(tagIndex == 2){
            return carTermsArr.count
        }else if(tagIndex == 3){
            return carModelArr.count
        }else if(tagIndex == 4){
            return civilStatusArr.count
        }else if(tagIndex == 5){
            return emptypeArr.count
        }else if(tagIndex == 6){
            return positionArr.count
        }
        return 0
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {   var titleData = ""
        let tag = String(pickerView.tag)
        let index1 = tag.startIndex.advancedBy(1)
        let tagIndex = Int(tag.substringToIndex(index1))
        
        if(tagIndex == 0){
            titleData = carBrandArr[row].0
        }else if(tagIndex == 1){
            if(autoInfo[3] == "Y"){
                titleData = String(downpaymentArr2[row])
            }else{
                titleData = String(downpaymentArr[row])
            }
        }else if(tagIndex == 2){
            titleData = String(carTermsArr[row])
        }else if(tagIndex == 3){
            titleData = String(carModelArr[row].1)
        }else if(tagIndex == 4){
            titleData = String(civilStatusArr[row].1)
        }else if(tagIndex == 5){
            titleData = String(emptypeArr[row].1)
        }else if(tagIndex == 6){
            titleData = String(positionArr[row].1)
        }
        return titleData
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let tag = String(pickerView.tag)
        let index1 = tag.startIndex.advancedBy(1)
        let tagIndex = Int(tag.substringToIndex(index1))

        if(tagIndex == 0){ //BRAND
            selectedCarBrand = carBrandArr[row].0
            if(vcAction == "apply"){
                loadCarModelPicker(selectedCarBrand)
            }
        }else if(tagIndex == 1){ //DP
            if(autoInfo[3] == "Y"){
                selectedDP =  String(downpaymentArr2[row])
            }else{
                selectedDP =  String(downpaymentArr[row])
            }
        }else if(tagIndex == 2){ //TERM
            selectedTerm = String(carTermsArr[row])
        }else if(tagIndex == 3){ //CAR MODEL
            selectedCarModelId = String(carModelArr[row].0)
            if(vcAction == "apply"){
                cashprice.text = carModelArr[row].2
            }
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
        if(tagIndex == 0){ //BRAND
            titleData = carBrandArr[row].0
        }else if(tagIndex == 1){ //DP
            if(autoInfo[3] == "Y"){
                titleData =  String(downpaymentArr2[row])
            }else{
                titleData =  String(downpaymentArr[row])
            }
        }else if(tagIndex == 2){ //TERM
            titleData = String(carTermsArr[row])
        }else if(tagIndex == 3){ //CAR MODEL
            titleData = String(carModelArr[row].1)
        }else if(tagIndex == 4){ //CIVIL STATUS
            titleData = String(civilStatusArr[row].1)
            pickerLabel!.textAlignment = .Left
        }else if(tagIndex == 5){ //EMP TYPE
            titleData = String(emptypeArr[row].1)
            pickerLabel!.textAlignment = .Left
        }else if(tagIndex == 6){ //POSITION
            titleData = String(positionArr[row].1)
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
    
    @IBAction func actionSearchCarModel(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowCarModelList", sender: self)
    }
    
    @IBAction func actionShowRecentItems(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowCarModelListRecent", sender: self)
    }
    
    @IBOutlet var tableViewCarModels: UITableView!
    
    
    @IBAction func showRecentItems(sender: AnyObject) {
        loadCarModelsRecent()
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
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
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
    
    func loadCarModels(carBrand: String){
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        var urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "MODEL")
        
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM1", withString: carBrand.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)
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
        return carModelArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        var (_, modeldesc, srp, _) = self.carModelArr[indexPath.row]
        
        if(modeldesc != ""){
            cell.textLabel!.text = modeldesc
            if(srp == ""){
                srp = "0"
            }
            let x = Int(srp)
            cell.detailTextLabel!.text = "PHP " + x!.stringFormattedWithSepator
        }else{
            cell.textLabel!.text = ""
            cell.detailTextLabel!.text = ""
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
            
            
            self.performSegueWithIdentifier("AutoLoanCalculator", sender: self)
        })
        alert.addAction(action2)
        let action3 = UIAlertAction(title: "Apply for Auto Loan", style: .Default, handler: { (alert) -> Void in
            self.selectedCarModelId = modelid
            self.selectedCarModelSRP = Int(self.carModelArr[indexPath.row].2)!
            self.selectedCarBrand = brand
            
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
    
    
    @IBOutlet var carCondition: UISegmentedControl!
    @IBOutlet var carBrand: UIPickerView!
    @IBOutlet var carModel: UIPickerView!
    @IBOutlet var carYear: UITextField!
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
    
    @IBOutlet var remarks: UITextField!
    
    
    func loadAppForm(){
        self.loadingIndicator.hidden = false
        self.loadingIndicator.startAnimating()
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        self.loadCarBrandPicker()
        self.loadEmpTypePicker()
        self.loadPositionPicker()
        
        if(self.carCondition.selectedSegmentIndex == 0){
            self.cashprice.enabled = false
            self.carYear.enabled = false
        }
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        let year =  components.year
        self.carYear.text = String(year)
        
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
        
        remarks.delegate = self
        
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
    
    func loadCarBrandPicker(){
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
                                    if(self.selectedCarBrand == ""){
                                        if(i == 0){
                                            self.selectedCarBrand = self.carBrandArr[i].0
                                        }
                                    }
                                }
                            }
                            self.carBrand.reloadAllComponents()
                            self.view.userInteractionEnabled = true
                            self.loadingIndicator.hidden = true
                            self.loadingIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            
                            for i in 0...str.count - 1{
                                if(str[i] != ""){
                                    if(self.selectedCarBrand != ""){
                                        if(self.carBrandArr[i].0 == self.selectedCarBrand){
                                            self.carBrand.selectRow(i, inComponent: 0, animated: false)
                                            self.loadCarModelPicker(self.selectedCarBrand)
                                        }
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
    
    func loadCarModelPicker(carBrand: String){
        urlLib = NSLocalizedString("urlLib", comment: "")
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        var urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "MODEL")
        
        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM1", withString: carBrand.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)
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
                            self.carModel.reloadAllComponents()
                            self.view.userInteractionEnabled = true
                            self.loadingIndicator.hidden = true
                            self.loadingIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString(",")
                                if(str2.count >= 3){
                                    if(self.selectedCarModelId != ""){
                                        if(self.carModelArr[i].0 == self.selectedCarModelId){
                                            self.carModel.selectRow(i, inComponent: 0, animated: false)
                                            self.cashprice.text = self.carModelArr[i].2
                                            break
                                        }
                                    }else{
                                        self.cashprice.text = self.carModelArr[0].2
                                        self.selectedCarBrand = self.carModelArr[0].3
                                        self.selectedCarModelId = self.carModelArr[0].0
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
    
    @IBAction func actionCarCondition(sender: AnyObject) {
        if(self.carCondition.selectedSegmentIndex == 0){
            self.cashprice.enabled = false
            self.carYear.enabled = false
        }else{
            self.cashprice.enabled = true
            self.carYear.enabled = true
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
        
        
        let url = NSLocalizedString("urlECLIPSE", comment: "")
        
        var stringUrl = url
        
        var errorctr = 0;
        var errormsg = "";
        stringUrl = stringUrl + "&companyid=" + self.id;

        
        if(self.carCondition.selectedSegmentIndex == 1){
            if(self.cashprice.text == "" || Double(self.cashprice.text!) <= 0){
                errorctr += 1;
                errormsg += "Cash Price\n";
            }
            
            if(self.carYear.text == ""){ //CHECK IF VALID YEAR
                errorctr += 1;
                errormsg += "Vehicle Year\n";
            }
        }
        
        stringUrl = stringUrl + "&vehicle_model=" + self.selectedCarModelId.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&vehicle_lcp=" + self.cashprice.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&vehicle_brand=" + self.selectedCarBrand.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;

        stringUrl = stringUrl + "&vehicle_year=" + self.carYear.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&vehicle_type=" + (self.carCondition.selectedSegmentIndex == 0 ? "1" : "2").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        if(autoInfo[3] == "Y"){
            stringUrl = stringUrl + "&downpaymentpct=" + String(downpaymentArr2[self.downpayment.selectedRowInComponent(0)])
        }else{
            stringUrl = stringUrl + "&downpaymentpct=" + String(downpaymentArr[self.downpayment.selectedRowInComponent(0)])
        }
        
        stringUrl = stringUrl + "&term=" + String(carTermsArr[self.loanterm.selectedRowInComponent(0)]).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&ao=" + autoInfo[0].stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&appsource=" + (self.id != "NON" ? "WAP" : "Online Application").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!; //CHECK WITH LIBFIELDVALUES
        stringUrl = stringUrl + "&rm=" + "";
        stringUrl = stringUrl + "&sourcearea=" + "Not Applicable".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&sourcetype=" + "Head Office".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&clientclass=" + (self.id != "NON" ? "WAP (WORKPLACE ARRANGEMENT PROGR" : "REGULAR").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!; //ADD TO LIBFIELDVALUES = REGULAR
        stringUrl = stringUrl + "&trantype=" + "DL".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
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
                errorctr += 1;
                errormsg += "SP Last Name\n";
            }
            if(self.spfirstname.text == ""){
                errorctr += 1;
                errormsg += "SP First Name\n";
            }
            if(self.spmobilenumber.text == ""){
                errorctr += 1;
                errormsg += "SP Mobile No\n";
            }
            if(self.spaddress1.text == ""){
                errorctr += 1;
                errormsg += "SP Res Address\n";
            }
            
            if(emptypeArr[self.spemptype.selectedRowInComponent(0)].0 != "6"){
                if(self.spempname.text == ""){
                    errorctr += 1;
                    errormsg += "SP Emp/Biz Name\n";
                }
                if(self.spempincome.text == ""){ //CHECK IF VALID AMOUNT
                    errorctr += 1;
                    errormsg += "SP Emp/Biz Income\n";
                }
                if(self.spempaddress1.text == ""){
                    errorctr += 1;
                    errormsg += "SP Emp/Biz Address\n";
                }
                if(self.spempphone.text == ""){
                    errorctr += 1;
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
                errorctr += 1;
                errormsg += "C1 Last Name\n";
            }
            if(self.c1firstname.text == ""){
                errorctr += 1;
                errormsg += "C1 First Name\n";
            }
            if(self.c1mobilenumber.text == ""){
                errorctr += 1;
                errormsg += "C1 Mobile No\n";
            }
            if(self.c1address1.text == ""){
                errorctr += 1;
                errormsg += "C1 Res Address\n";
            }

            if(emptypeArr[self.c1emptype.selectedRowInComponent(0)].0 != "6"){
                if(self.c1empname.text == ""){
                    errorctr += 1;
                    errormsg += "C1 Emp/Biz Name\n";
                }
                if(self.c1empincome.text == ""){ //CHECK IF VALID AMOUNT
                    errorctr += 1;
                    errormsg += "C1 Emp/Biz Income\n";
                }
                if(self.c1empaddress1.text == ""){
                    errorctr += 1;
                    errormsg += "C1 Emp/Biz Address\n";
                }
                if(self.c1empphone.text == ""){
                    errorctr += 1;
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
                errorctr += 1;
                errormsg += "C2 Last Name\n";
            }
            if(self.c2firstname.text == ""){
                errorctr += 1;
                errormsg += "C2 First Name\n";
            }
            if(self.c2mobilenumber.text == ""){
                errorctr += 1;
                errormsg += "C2 Mobile No\n";
            }
            if(self.c2address1.text == ""){
                errorctr += 1;
                errormsg += "C2 Res Address\n";
            }
            
            if(emptypeArr[self.c2emptype.selectedRowInComponent(0)].0 != "6"){
                if(self.c2empname.text == ""){
                    errorctr += 1;
                    errormsg += "C2 Emp/Biz Name\n";
                }
                if(self.c2empincome.text == ""){ //CHECK IF VALID AMOUNT
                    errorctr += 1;
                    errormsg += "C2 Emp/Biz Income\n";
                }
                if(self.c2empaddress1.text == ""){
                    errorctr += 1;
                    errormsg += "C2 Emp/Biz Address\n";
                }
                if(self.c2empphone.text == ""){
                    errorctr += 1;
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
        
        stringUrl = stringUrl + "&remarks=" + self.remarks.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&duid=" + UIDevice.currentDevice().identifierForVendor!.UUIDString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&dtype=ios"
        
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
            url.refid = "AUTO"
            url.datesuccess = "0"
            
            self.view.userInteractionEnabled = true
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "Application Submitted", message: "Your new auto loan application has been saved for submission. Please make sure not to quit the app and to have a stable data connection for a few minutes. You will receive an alert once it has been successfully sent.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                 self.performSegueWithIdentifier("BackToAutoMain", sender: self)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        
        }
        
        
    }
    
    
    @IBAction func actionApplyDirectFromMain(sender: AnyObject) {
        self.performSegueWithIdentifier("ApplyLoanDirectFromMain", sender: self)
    }
    
    
    @IBAction func actionCalculatorDirect(sender: AnyObject) {
        self.performSegueWithIdentifier("AutoLoanCalculatorDirect", sender: self)
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
            if(self.prevPage == "mainAuto"){
                self.performSegueWithIdentifier("BackToAutoMain", sender: self)
            }
            if(self.prevPage == "carModelList"){
                self.performSegueWithIdentifier("ShowCarModelList", sender: self)
            }
            if(self.prevPage == "carModelListRecent"){
                self.performSegueWithIdentifier("ShowCarModelListRecent", sender: self)
            }
            if(self.prevPage == "autoLoanCalculator"){
                self.performSegueWithIdentifier("AutoLoanCalculator", sender: self)
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
        if (userDefaults.objectForKey("autoInfo") != nil) {
            self.autoInfo = NSUserDefaults.standardUserDefaults().valueForKey("autoInfo") as! [String]
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
        
        if segue.identifier == "ShowCarModelList"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerAuto{
                destinationVC.vcAction = "ShowCarModelList"
                destinationVC.id = self.id
                destinationVC.selectedCarBrand = self.selectedCarBrand
                destinationVC.prevPage = "main"
            }
        }
        
        if segue.identifier == "BackToAutoMain"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerAuto{
                destinationVC.vcAction = ""
                destinationVC.id = self.id
                destinationVC.selectedCarBrand = self.selectedCarBrand
            }
        }
        
        if segue.identifier == "ShowCarModelListRecent"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerAuto{
                destinationVC.vcAction = "ShowCarModelListRecent"
                destinationVC.id = self.id
                destinationVC.prevPage = "main"
                destinationVC.selectedCarBrand = self.selectedCarBrand
            }
        }
        
        if segue.identifier == "AutoLoanCalculator"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerAuto{
                destinationVC.vcAction = "AutoLoanCalculator"
                destinationVC.id = self.id
                destinationVC.selectedCarModelId = self.selectedCarModelId
                destinationVC.selectedCarModelSRP = self.selectedCarModelSRP
                destinationVC.selectedCarBrand = self.selectedCarBrand
                destinationVC.showRecent = showRecent
                if(!showRecent){
                    destinationVC.prevPage = "carModelList"
                }else{
                    destinationVC.prevPage = "carModelListRecent"
                }
            }
        }
        if segue.identifier == "AutoLoanCalculatorDirect"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerAuto{
                destinationVC.vcAction = "AutoLoanCalculator"
                destinationVC.id = self.id
                destinationVC.showRecent = showRecent
                destinationVC.prevPage = "mainAuto"
               
            }
        }
        
        if segue.identifier == "ApplyLoan"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerAuto{
                destinationVC.vcAction = "apply"
                destinationVC.id = self.id
                destinationVC.prevPage = "autoLoanCalculator"
                destinationVC.selectedCarModelId = self.selectedCarModelId
                destinationVC.selectedCarModelSRP = self.selectedCarModelSRP
                destinationVC.selectedCarBrand = self.selectedCarBrand
                destinationVC.showRecent = showRecent
                
            }
        }
        if segue.identifier == "ApplyLoanDirect"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerAuto{
                destinationVC.vcAction = "apply"
                destinationVC.id = self.id
                destinationVC.selectedCarModelId = self.selectedCarModelId
                destinationVC.selectedCarModelSRP = self.selectedCarModelSRP
                destinationVC.selectedCarBrand = self.selectedCarBrand
                destinationVC.showRecent = showRecent
                if(!showRecent){
                    destinationVC.prevPage = "carModelList"
                }else{
                    destinationVC.prevPage = "carModelListRecent"
                }
            }
        }
        if segue.identifier == "ApplyLoanDirectFromMain"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerAuto{
                destinationVC.vcAction = "apply"
                destinationVC.id = self.id
                destinationVC.showRecent = showRecent
                destinationVC.prevPage = "mainAuto"
                
            }
        }
        if segue.identifier == "Inquiry"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerInquiry{
                destinationVC.id = self.id
                destinationVC.prevPage = "AutoMain"
                destinationVC.product = "Auto Loan"
                destinationVC.selectedCarBrand = self.selectedCarBrand
                destinationVC.showRecent = showRecent
            }
        }
        if segue.identifier == "FAQ"
        {
            if let destinationVC = segue.destinationViewController as? ViewControllerFAQ{
                destinationVC.id = self.id
                destinationVC.prevPage = "AutoMain"
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



