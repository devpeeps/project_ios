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
    var carTermsArr = [60,48,36,24,18,12]
    var homeTermsArr = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    var downpaymentArr = [20,30,40,50,60,70,80,90]
    var downpaymentArr_Home = [10,20,30,40,50,60,70,80,90]
    var civilStatusArr = [("S","Single"),("M","Married"),("W","Widow/er")]
    var emptypeArr = [("","")]
    var positionArr = [("","")]
    var selectedCarBrand = ""
    var selectedCarModelId = ""
    var selectedCarModelSRP = 0
    var prevPage = ""
    var autoRates = [("",0.00)]
    var selectedTerm = "60"
    var selectedDP = "20"
    var showRecent = false
    
    @IBOutlet var scrollview: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        checkIfLogged()
        
        if(vcAction == ""){
            prevPage = "main"
            loadCarBrandList()
        }
        
        if(vcAction == "apply"){
            scrollview.contentSize = CGSize(width:400, height:2200)
            
            self.loadingIndicator.hidden = false
            self.loadingIndicator.startAnimating()
            self.view.userInteractionEnabled = false
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            self.loadCarBrandPicker()
            self.loadEmpTypePicker()
            self.loadPositionPicker()
            /*
            self.view.userInteractionEnabled = true
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            */
            
        }
        
        if(vcAction == "ShowCarModelList"){
            loadCarModels(self.selectedCarBrand)
        }
        if(vcAction == "ShowCarModelListRecent"){
            loadCarModelsRecent()
        }
        
        if(vcAction == "AutoLoanCalculator"){
            loadCalculatorValues()
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
                        self.loadingIndicator.hidden = true
                        self.loadingIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
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
            ++i;
        }
        
        NSLog(String(rate * 12.00 * 100.00));
        return rate * 12.00 * 100.00;
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 0){
            return carBrandArr.count
        }else if(pickerView.tag == 1){
            return downpaymentArr.count
        }else if(pickerView.tag == 2){
            return carTermsArr.count
        }else if(pickerView.tag == 3){
            return carModelArr.count
        }else if(pickerView.tag == 4){
            return civilStatusArr.count
        }else if(pickerView.tag == 5){
            return emptypeArr.count
        }else if(pickerView.tag == 6){
            return positionArr.count
        }
        return 0
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {   var titleData = ""
        if(pickerView.tag == 0){
            titleData = carBrandArr[row].0
        }else if(pickerView.tag == 1){
            titleData = String(downpaymentArr[row])
        }else if(pickerView.tag == 2){
            titleData = String(carTermsArr[row])
        }else if(pickerView.tag == 3){
            titleData = String(carModelArr[row].1)
        }else if(pickerView.tag == 4){
            titleData = String(civilStatusArr[row].1).capitalizedString
        }else if(pickerView.tag == 5){
            titleData = String(emptypeArr[row].1).capitalizedString
        }else if(pickerView.tag == 6){
            titleData = String(positionArr[row].1).capitalizedString
        }
        return titleData
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 0){ //BRAND
            selectedCarBrand = carBrandArr[row].0
        }else if(pickerView.tag == 1){ //DP
            selectedDP =  String(downpaymentArr[row])
        }else if(pickerView.tag == 2){ //TERM
            selectedTerm = String(carTermsArr[row])
        }else if(pickerView.tag == 3){ //CAR MODEL
            selectedCarModelId = String(carModelArr[row].0)
        }else if(pickerView.tag == 4){ //CIVIL STATUS
            selectedTerm = String(carTermsArr[row])
        }else if(pickerView.tag == 5){ //EMP TYPE
            selectedTerm = String(carTermsArr[row])
        }else if(pickerView.tag == 6){ //POSITION
            selectedTerm = String(carTermsArr[row])
        }
        
    }
    /*
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var titleData = ""
        if(pickerView.tag == 0){ //BRAND
            titleData = carBrandArr[row].0
        }else if(pickerView.tag == 1){ //DP
            titleData =  String(downpaymentArr[row])
        }else if(pickerView.tag == 2){ //TERM
            titleData = String(carTermsArr[row])
        }else if(pickerView.tag == 3){ //CAR MODEL
            titleData = String(carModelArr[row].1)
        }else if(pickerView.tag == 4){ //CIVIL STATUS
            titleData = String(civilStatusArr[row].1).capitalizedString
        }else if(pickerView.tag == 5){ //EMP TYPE
            titleData = String(emptypeArr[row].1).capitalizedString
        }else if(pickerView.tag == 6){ //POSITION
            titleData = String(positionArr[row].1).capitalizedString
        }
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 10.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        return myTitle
    }
    */
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
        }
        pickerLabel!.textAlignment = .Center
        
        var titleData = ""
        if(pickerView.tag == 0){ //BRAND
            titleData = carBrandArr[row].0
        }else if(pickerView.tag == 1){ //DP
            titleData =  String(downpaymentArr[row])
        }else if(pickerView.tag == 2){ //TERM
            titleData = String(carTermsArr[row])
        }else if(pickerView.tag == 3){ //CAR MODEL
            titleData = String(carModelArr[row].1)
        }else if(pickerView.tag == 4){ //CIVIL STATUS
            titleData = String(civilStatusArr[row].1).capitalizedString
            pickerLabel!.textAlignment = .Left
        }else if(pickerView.tag == 5){ //EMP TYPE
            titleData = String(emptypeArr[row].1).capitalizedString
            pickerLabel!.textAlignment = .Left
        }else if(pickerView.tag == 6){ //POSITION
            titleData = String(positionArr[row].1).capitalizedString
            pickerLabel!.textAlignment = .Left
        }
        
        
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Arial", size: 16.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
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
                        self.loadingIndicator.hidden = true
                        self.loadingIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
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
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loadingIndicator.hidden = true
                        self.loadingIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
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
            self.performSegueWithIdentifier("ApplyAutoLoan", sender: self)
        })
        alert.addAction(action3)
        let action4 = UIAlertAction(title: "Inquire Now", style: .Default, handler: { (alert) -> Void in
            self.selectedCarModelId = modelid
            self.performSegueWithIdentifier("Inquire", sender: self)
        })
        alert.addAction(action4)
        
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
    @IBOutlet var c1gender: UIDatePicker!
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
    
    func formatDatePickers(){
        
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
                        self.loadingIndicator.hidden = true
                        self.loadingIndicator.stopAnimating()
                        self.view.userInteractionEnabled = true
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
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
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            self.view.userInteractionEnabled = true
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)
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
                        self.loadingIndicator.hidden = true
                        self.loadingIndicator.stopAnimating()
                        self.view.userInteractionEnabled = true
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
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
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            self.view.userInteractionEnabled = true
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func loadCarBrandPicker(){
        urlLib = NSLocalizedString("urlLib", comment: "")
        //self.view.userInteractionEnabled = false
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "BRAND_SPINNER")
        
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
                            //self.view.userInteractionEnabled = true
                            //self.loadingIndicator.hidden = true
                            //self.loadingIndicator.stopAnimating()
                            //UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            
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
                        self.loadingIndicator.hidden = true
                        self.loadingIndicator.stopAnimating()
                        self.view.userInteractionEnabled = true
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
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
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            self.view.userInteractionEnabled = true
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func loadCarModelPicker(carBrand: String){
        urlLib = NSLocalizedString("urlLib", comment: "")
        //self.view.userInteractionEnabled = false
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
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
                            self.carModelArr.removeAll()
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString(",")
                                if(str2.count >= 3){
                                    self.carModelArr.append((str2[0], str2[1], str2[2], str2[3]))
                                }
                            }
                            self.carModel.reloadAllComponents()
                            //self.view.userInteractionEnabled = true
                            //self.loadingIndicator.hidden = true
                            //self.loadingIndicator.stopAnimating()
                            //UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString(",")
                                if(str2.count >= 3){
                                    if(self.selectedCarModelId != ""){
                                        if(self.carModelArr[i].0 == self.selectedCarModelId){
                                            self.carModel.selectRow(i, inComponent: 0, animated: false)
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
                        self.loadingIndicator.hidden = true
                        self.loadingIndicator.stopAnimating()
                        self.view.userInteractionEnabled = true
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
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
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            self.view.userInteractionEnabled = true
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                //exit(1)
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
