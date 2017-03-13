//
//  HomeTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 03/11/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController, UITextFieldDelegate {
    
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
    var selectedTerm = ""
    var selectedDP = ""
    var selectedCivilStat = ""
    var selectedWithC1 = false
    var selectedWithC2 = false
    
    var bdaydatePickerHidden = true
    var spousebdaydatePickerHidden = true
    var c1bdaydatePickerHidden = true
    var c2bdaydatePickerHidden = true
    var carConditionFieldsHidden = true
    
    var unemployedFieldsHidden = false
    var spUnemployedFieldsHidden = false
    var c1UnemployedFieldsHidden = false
    var c2UnemployedFieldsHidden = false
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeTableViewController.DismissKeyboard))
        view.addGestureRecognizer(dismiss)
        dismiss.cancelsTouchesInView = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.keyboardWasShown(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.keyboardWasNotShown(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        datePickerChanged()
        spousedatePickerChanged()
        c1datePickerChanged()
        c2datePickerChanged()
    }
    
    override func viewDidLayoutSubviews() {
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            self.tableView.contentInset = UIEdgeInsetsMake( y, 0, 0, 0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBOutlet var propertyTypeCell: UITableViewCell!
    @IBOutlet var provinceCell: UITableViewCell!
    @IBOutlet var cityCell: UITableViewCell!
    
    override func viewDidAppear(animated: Bool) {
        if(vcAction == "ShowHomeLoanCalculator" || vcAction == "ShowHomeApplication" || vcAction == "ShowComputedHomeApp"){
            if let DPLabel = defaults.stringForKey("selectedDP") {
                self.downpaymentCell.detailTextLabel?.text = DPLabel
            }
            
            if let termLabel = defaults.stringForKey("selectedTerm") {
                self.termCell.detailTextLabel?.text = termLabel
            }
        }
        
        if(vcAction == "ShowSearchPropertyPage"){
            if let propertyTypeLabel = defaults.stringForKey("selectedPropertyType") {
                self.propertyTypeCell.detailTextLabel?.text = propertyTypeLabel
            }
            
            if let provinceLabel = defaults.stringForKey("selectedProvince") {
                self.provinceCell.detailTextLabel?.text = provinceLabel
            }
            
            if let cityLabel = defaults.stringForKey("selectedCity") {
                self.cityCell.detailTextLabel?.text = cityLabel
            }
        }
        
        if(vcAction == "ShowHomeApplication" || vcAction == "ShowComputedHomeApp"){
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: date)
            _ =  components.year
            
            if let occupationLabel = defaults.stringForKey("selectedOccupation") {
                self.occupationListCell.detailTextLabel?.text = occupationLabel
            }
            
            if let incomeTypeLabel = defaults.stringForKey("selectedIncomeType") {
                self.incomeTypeCell.detailTextLabel?.text = incomeTypeLabel
            }
            
            if let SPOccupationLabel = defaults.stringForKey("selectedSPOccupation") {
                self.SPOccupationListCell.detailTextLabel?.text = SPOccupationLabel
            }
            
            if let SPIncomeTypeLabel = defaults.stringForKey("selectedSPIncomeType") {
                self.SPIncomeTypeCell.detailTextLabel?.text = SPIncomeTypeLabel
            }
            
            if let C1OccupationLabel = defaults.stringForKey("selectedC1Occupation") {
                self.C1OccupationListCell.detailTextLabel?.text = C1OccupationLabel
            }
            
            if let C1IncomeTypeLabel = defaults.stringForKey("selectedC1IncomeType") {
                self.C1IncomeTypeCell.detailTextLabel?.text = C1IncomeTypeLabel
            }
            
            if let C2OccupationLabel = defaults.stringForKey("selectedC2Occupation") {
                self.C2OccupationListCell.detailTextLabel?.text = C2OccupationLabel
            }
            
            if let C2IncomeTypeLabel = defaults.stringForKey("selectedC2IncomeType") {
                self.C2IncomeTypeCell.detailTextLabel?.text = C2IncomeTypeLabel
            }
            
            if(self.emptype.text == "Unemployed"){
                empname.enabled = false
                position.userInteractionEnabled = false
                empincome.enabled = false
                empyears.enabled = false
                empaddress1.enabled = false
                empaddress2.enabled = false
                empphone.enabled = false
                
                if unemployedFieldsHidden == false {
                    hideFieldsUnemployed()
                }
            }
            else if(self.emptype.text == ""){
                empname.enabled = false
                position.userInteractionEnabled = false
                empincome.enabled = false
                empyears.enabled = false
                empaddress1.enabled = false
                empaddress2.enabled = false
                empphone.enabled = false
                
                hideFieldsUnemployed()
            }
            else {
                empname.enabled = true
                position.userInteractionEnabled = true
                empincome.enabled = true
                empyears.enabled = true
                empaddress1.enabled = true
                empaddress2.enabled = true
                empphone.enabled = true
                
                if unemployedFieldsHidden == true {
                    hideFieldsUnemployed()
                }
            }
            
            if(self.spemptype.text == "Unemployed"){
                spempname.enabled = false
                spposition.userInteractionEnabled = false
                spempincome.enabled = false
                spempyears.enabled = false
                spempaddress1.enabled = false
                spempaddress2.enabled = false
                spempphone.enabled = false
                
                if spUnemployedFieldsHidden == false {
                    hideFieldsSPUnemployed()
                }
            }
            else if(self.spemptype.text == ""){
                spempname.enabled = false
                spposition.userInteractionEnabled = false
                spempincome.enabled = false
                spempyears.enabled = false
                spempaddress1.enabled = false
                spempaddress2.enabled = false
                spempphone.enabled = false
                
                hideFieldsSPUnemployed()
            }
            else {
                spempname.enabled = true
                spposition.userInteractionEnabled = true
                spempincome.enabled = true
                spempyears.enabled = true
                spempaddress1.enabled = true
                spempaddress2.enabled = true
                spempphone.enabled = true
                
                if spUnemployedFieldsHidden == true {
                    hideFieldsSPUnemployed()
                }
            }
            
            if(self.c1emptype.text == "Unemployed"){
                c1empname.enabled = false
                c1position.userInteractionEnabled = false
                c1empincome.enabled = false
                c1empyears.enabled = false
                c1empaddress1.enabled = false
                c1empaddress2.enabled = false
                c1empphone.enabled = false
                
                if c1UnemployedFieldsHidden == false {
                    hideFieldsC1Unemployed()
                }
            }
            else if(self.c1emptype.text == ""){
                c1empname.enabled = false
                c1position.userInteractionEnabled = false
                c1empincome.enabled = false
                c1empyears.enabled = false
                c1empaddress1.enabled = false
                c1empaddress2.enabled = false
                c1empphone.enabled = false
                
                hideFieldsC1Unemployed()
            }
            else {
                c1empname.enabled = true
                c1position.userInteractionEnabled = true
                c1empincome.enabled = true
                c1empyears.enabled = true
                c1empaddress1.enabled = true
                c1empaddress2.enabled = true
                c1empphone.enabled = true
                
                if c1UnemployedFieldsHidden == true {
                    hideFieldsC1Unemployed()
                }
            }
            
            if(self.c2emptype.text == "Unemployed"){
                c2empname.enabled = false
                c2position.userInteractionEnabled = false
                c2empincome.enabled = false
                c2empyears.enabled = false
                c2empaddress1.enabled = false
                c2empaddress2.enabled = false
                c2empphone.enabled = false
                
                if c2UnemployedFieldsHidden == false {
                    hideFieldsC2Unemployed()
                }
            }
            else if(self.c2emptype.text == ""){
                c2empname.enabled = false
                c2position.userInteractionEnabled = false
                c2empincome.enabled = false
                c2empyears.enabled = false
                c2empaddress1.enabled = false
                c2empaddress2.enabled = false
                c2empphone.enabled = false
                
                hideFieldsC2Unemployed()
            }
            else {
                c2empname.enabled = true
                c2position.userInteractionEnabled = true
                c2empincome.enabled = true
                c2empyears.enabled = true
                c2empaddress1.enabled = true
                c2empaddress2.enabled = true
                c2empphone.enabled = true
                
                if c2UnemployedFieldsHidden == true {
                    hideFieldsC2Unemployed()
                }
            }
            
            if(self.emptype.text == "Unemployed" || self.spemptype.text == "Unemployed" || self.c1emptype.text == "Unemployed" || self.c2emptype.text == "Unemployed")
            {
                homeLoanApplicationTable.reloadData()
            }
            
            if let civilStatusLabel = defaults.stringForKey("selectedCivilStatus") {
                self.civilStatusCell.detailTextLabel?.text = civilStatusLabel
            }
            
            if let C1civilStatusLabel = defaults.stringForKey("selectedC1CivilStatus") {
                self.C1civilStatusCell.detailTextLabel?.text = C1civilStatusLabel
            }
            
            if let C2civilStatusLabel = defaults.stringForKey("selectedC2CivilStatus") {
                self.C2civilStatusCell.detailTextLabel?.text = C2civilStatusLabel
            }
            
            if(self.civilstatus.text == "Married"){
                splastname.enabled = true
                spfirstname.enabled = true
                spmiddlename.enabled = true
                spbirthday.userInteractionEnabled = true
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
                
                homeLoanApplicationTable.reloadData()
            }
            else {
                splastname.enabled = false
                spfirstname.enabled = false
                spmiddlename.enabled = false
                spbirthday.userInteractionEnabled = false
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
                
                homeLoanApplicationTable.reloadData()
            }
        }
    }
    
    func hideFieldsUnemployed() {
        unemployedFieldsHidden = !unemployedFieldsHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func hideFieldsSPUnemployed() {
        spUnemployedFieldsHidden = !spUnemployedFieldsHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func hideFieldsC1Unemployed() {
        c1UnemployedFieldsHidden = !c1UnemployedFieldsHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func hideFieldsC2Unemployed() {
        c2UnemployedFieldsHidden = !c2UnemployedFieldsHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toggleDatepicker() {
        bdaydatePickerHidden = !bdaydatePickerHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func spousebdaytoggleDatepicker() {
        spousebdaydatePickerHidden = !spousebdaydatePickerHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func c1bdaytoggleDatepicker() {
        c1bdaydatePickerHidden = !c1bdaydatePickerHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func c2bdaytoggleDatepicker() {
        c2bdaydatePickerHidden = !c2bdaydatePickerHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func togglecarConditionFields() {
        carConditionFieldsHidden = !carConditionFieldsHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func bdaydatePickerValue(sender: UIDatePicker) {
        datePickerChanged()
    }
    
    @IBAction func spousebdaydatePickerValue(sender: UIDatePicker) {
        spousedatePickerChanged()
    }
    
    @IBAction func c1bdaydatePickerValue(sender: UIDatePicker) {
        c1datePickerChanged()
    }
    
    @IBAction func c2bdaydatePickerValue(sender: UIDatePicker) {
        c2datePickerChanged()
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        
        let userInfo: [NSObject : AnyObject] = notification.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= 0
                })
            }
        } else {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    
    func keyboardWasNotShown(notification: NSNotification) {
        
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
    
    @IBOutlet var txtSellingPrice: UITextField!
    @IBOutlet var txtMonthlyAmort: UITextField!
    
    @IBAction func computeAmort(sender: AnyObject) {
        let x = calculateAmort()
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = 0;
        
        txtMonthlyAmort.text = formatter.stringFromNumber(x)!
    }
    
    func calculateAmort() -> Double{
        
        if (txtSellingPrice.text == ""){
            txtSellingPrice.text = "0.00"
        }
        
        var aor = 0.00
        let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        //NSLog((NSUserDefaults.standardUserDefaults().arrayForKey("autoInfo")?.first)! as! String)
        
        if (userDefaults.objectForKey("homeRates_standard") != nil) {
            aor = NSUserDefaults.standardUserDefaults().objectForKey("homeRates_standard") as! Double
        }
        
        if let dpLabel = defaults.stringForKey("selectedDP") {
            selectedDP = dpLabel
        }
        
        if let termLabel = defaults.stringForKey("selectedTerm") {
            selectedTerm = termLabel
        }
        
        NSLog("txtSellingPrice.text: " + String(txtSellingPrice.text))
        let rate = aor / 100;
        let dp = Double(selectedDP)
        NSLog("selectedDP: " + String(selectedDP))
        NSLog("selectedTerm: " + selectedTerm)
        var amount_financed = Double(txtSellingPrice.text!.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))
        amount_financed = amount_financed! - (amount_financed! * (dp! / 100))
        NSLog("dp = " + String(dp))
        NSLog("sellingprice = " + String(txtSellingPrice.text!.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)))
        NSLog("amount_financed = " + String(amount_financed))
        
        let term = Double(selectedTerm)!
        
        NSLog("term = " + String(term))
        NSLog("aor: " + String(aor))
        NSLog("rate: " + String(rate))
        print(amount_financed)
        print(rate)
        print(term)
        var amort = ((rate / 12) * (0 - amount_financed!))
        
        print(amort)
        
        amort = amort * (pow((1 + (rate / 12)), 12 * term) / (1 - pow((1 + (rate / 12)), 12 * term)));
        print(amort)

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

    @IBOutlet var downpayment: UILabel!
    @IBOutlet var loanterm: UILabel!
    @IBOutlet var cashprice: UITextField!
    @IBOutlet var lastname: UITextField!
    @IBOutlet var firstname: UITextField!
    @IBOutlet var middlename: UITextField!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var birthday: UILabel!
    @IBOutlet var civilstatus: UILabel!
    @IBOutlet var phonenumber: UITextField!
    @IBOutlet var mobilenumber: UITextField!
    @IBOutlet var emailaddress: UITextField!
    @IBOutlet var address1: UITextField!
    @IBOutlet var address2: UITextField!
    @IBOutlet var emptype: UILabel!
    @IBOutlet var empname: UITextField!
    @IBOutlet var position: UILabel!
    @IBOutlet var empincome: UITextField!
    @IBOutlet var empyears: UITextField!
    @IBOutlet var empaddress1: UITextField!
    @IBOutlet var empaddress2: UITextField!
    @IBOutlet var empphone: UITextField!
    
    @IBOutlet var splastname: UITextField!
    @IBOutlet var spfirstname: UITextField!
    @IBOutlet var spmiddlename: UITextField!
    @IBOutlet var spbirthday: UILabel!
    @IBOutlet var spcopycontact: UISwitch!
    @IBOutlet var spphonenumber: UITextField!
    @IBOutlet var spmobilenumber: UITextField!
    @IBOutlet var spaddress1: UITextField!
    @IBOutlet var spaddress2: UITextField!
    @IBOutlet var spemptype: UILabel!
    @IBOutlet var spempname: UITextField!
    @IBOutlet var spposition: UILabel!
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
    @IBOutlet var c1birthday: UILabel!
    @IBOutlet var c1gender: UISegmentedControl!
    @IBOutlet var c1civilstatus: UILabel!
    @IBOutlet var c1phonenumber: UITextField!
    @IBOutlet var c1mobilenumber: UITextField!
    @IBOutlet var c1address1: UITextField!
    @IBOutlet var c1address2: UITextField!
    @IBOutlet var c1emptype: UILabel!
    @IBOutlet var c1empname: UITextField!
    @IBOutlet var c1position: UILabel!
    @IBOutlet var c1empincome: UITextField!
    @IBOutlet var c1empyears: UITextField!
    @IBOutlet var c1empaddress1: UITextField!
    @IBOutlet var c1empaddress2: UITextField!
    @IBOutlet var c1empphone: UITextField!
    
    @IBOutlet var c2lastname: UITextField!
    @IBOutlet var c2firstname: UITextField!
    @IBOutlet var c2middlename: UITextField!
    @IBOutlet var c2birthday: UILabel!
    @IBOutlet var c2gender: UISegmentedControl!
    @IBOutlet var c2civilstatus: UILabel!
    @IBOutlet var c2phonenumber: UITextField!
    @IBOutlet var c2mobilenumber: UITextField!
    @IBOutlet var c2address1: UITextField!
    @IBOutlet var c2address2: UITextField!
    @IBOutlet var c2emptype: UILabel!
    @IBOutlet var c2empname: UITextField!
    @IBOutlet var c2position: UILabel!
    @IBOutlet var c2empincome: UITextField!
    @IBOutlet var c2empyears: UITextField!
    @IBOutlet var c2empaddress1: UITextField!
    @IBOutlet var c2empaddress2: UITextField!
    @IBOutlet var c2empphone: UITextField!
    
    @IBOutlet var remarks: UITextField!
    
    @IBOutlet var homeLoanApplicationTable: UITableView!
    
    @IBOutlet var c1LastnameCell: UITableViewCell!
    @IBOutlet var cashpriceCell: UITableViewCell!
    
    @IBOutlet var bdaydatePicker: UIDatePicker!
    @IBOutlet var bdaydetailLabel: UILabel!
    @IBOutlet var spousebdaydatePicker: UIDatePicker!
    @IBOutlet var spousebdaydetailLabel: UILabel!
    @IBOutlet var c1bdaydatePicker: UIDatePicker!
    @IBOutlet var c1bdaydetailLabel: UILabel!
    @IBOutlet var c2bdaydatePicker: UIDatePicker!
    @IBOutlet var c2bdaydetailLabel: UILabel!
    
    @IBOutlet var downpaymentCell: UITableViewCell!
    @IBOutlet var termCell: UITableViewCell!
    @IBOutlet var occupationListCell: UITableViewCell!
    @IBOutlet var incomeTypeCell: UITableViewCell!
    @IBOutlet var SPIncomeTypeCell: UITableViewCell!
    @IBOutlet var SPOccupationListCell: UITableViewCell!
    @IBOutlet var C1IncomeTypeCell: UITableViewCell!
    @IBOutlet var C1OccupationListCell: UITableViewCell!
    @IBOutlet var C2IncomeTypeCell: UITableViewCell!
    @IBOutlet var C2OccupationListCell: UITableViewCell!
    @IBOutlet var civilStatusCell: UITableViewCell!
    @IBOutlet var C1civilStatusCell: UITableViewCell!
    @IBOutlet var C2civilStatusCell: UITableViewCell!
    
    @IBOutlet var txtPriceFrom: UITextField!
    @IBOutlet var txtPriceTo: UITextField!
    
    @IBAction func datePickerChanged() {
        if(vcAction == "ShowHomeApplication" || vcAction == "ShowComputedAutoApp")
        {
            bdaydetailLabel.text = NSDateFormatter.localizedStringFromDate(bdaydatePicker.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        }
    }
    
    @IBAction func spousedatePickerChanged() {
        if(vcAction == "ShowHomeApplication" || vcAction == "ShowComputedHomeApp")
        {
            spousebdaydetailLabel.text = NSDateFormatter.localizedStringFromDate(spousebdaydatePicker.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        }
    }
    
    @IBAction func c1datePickerChanged() {
        if(vcAction == "ShowHomeApplication" || vcAction == "ShowComputedHomeApp")
        {
            c1bdaydetailLabel.text = NSDateFormatter.localizedStringFromDate(c1bdaydatePicker.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        }
    }
    
    @IBAction func c2datePickerChanged() {
        if(vcAction == "ShowHomeApplication" || vcAction == "ShowComputedHomeApp")
        {
            c2bdaydetailLabel.text = NSDateFormatter.localizedStringFromDate(c2bdaydatePicker.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        }
    }
    
    @IBAction func toggleWithC1(sender: UISwitch) {
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
        }
        else {
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
            
            c1lastname.text = ""
            c1firstname.text = ""
            c1middlename.text = ""
            c1birthday.text = ""
            c1civilstatus.text = ""
            c1phonenumber.text = ""
            c1mobilenumber.text = ""
            c1address1.text = ""
            c1address2.text = ""
            c1emptype.text = ""
            c1empname.text = ""
            c1position.text = ""
            c1empincome.text = ""
            c1empyears.text = ""
            c1empaddress1.text = ""
            c1empaddress2.text = ""
            c1empphone.text = ""
            
            c2lastname.text = ""
            c2firstname.text = ""
            c2middlename.text = ""
            c2birthday.text = ""
            c2civilstatus.text = ""
            c2phonenumber.text = ""
            c2mobilenumber.text = ""
            c2address1.text = ""
            c2address2.text = ""
            c2emptype.text = ""
            c2empname.text = ""
            c2position.text = ""
            c2empincome.text = ""
            c2empyears.text = ""
            c2empaddress1.text = ""
            c2empaddress2.text = ""
            c2empphone.text = ""
        }
        
        homeLoanApplicationTable.reloadData()
    }
    
    @IBAction func toggleWithC2(sender: UISwitch) {
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
        }
        else {
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
            
            c2lastname.text = ""
            c2firstname.text = ""
            c2middlename.text = ""
            c2birthday.text = ""
            c2civilstatus.text = ""
            c2phonenumber.text = ""
            c2mobilenumber.text = ""
            c2address1.text = ""
            c2address2.text = ""
            c2emptype.text = ""
            c2empname.text = ""
            c2position.text = ""
            c2empincome.text = ""
            c2empyears.text = ""
            c2empaddress1.text = ""
            c2empaddress2.text = ""
            c2empphone.text = ""
        }
        
        homeLoanApplicationTable.reloadData()
    }
    
    @IBAction func toggleCopyContacts(sender: UISwitch) {
        if(self.spcopycontact.on == true){
            spphonenumber.text = phonenumber.text
            spmobilenumber.text = mobilenumber.text
            spaddress1.text = address1.text
            spaddress2.text = address2.text
        }
        else{
            spphonenumber.text = nil
            spmobilenumber.text = nil
            spaddress1.text = nil
            spaddress2.text = nil
        }
    }
    
    @IBAction func actionSearchPropertyModel(sender: AnyObject) {
        let priceFrom = txtPriceFrom.text
        let priceTo = txtPriceTo.text
        let propertyType = propertyTypeCell.detailTextLabel?.text
        let province = provinceCell.detailTextLabel?.text
        let city = cityCell.detailTextLabel?.text
        
        defaults.setObject(propertyType, forKey: "selectedPropertyType")
        defaults.setObject(province, forKey: "selectedProvince")
        defaults.setObject(city, forKey: "selectedCity")
        defaults.setObject(priceFrom, forKey: "selectedPriceFrom")
        defaults.setObject(priceTo, forKey: "selectedPriceTo")
        
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
        
        NSLog("IBAction: actionSearchPropertyModel")
        NSLog("selectedPropertyType: " + selectedPropertyType)
        NSLog("selectedPriceFrom: " + selectedPriceFrom)
        NSLog("selectedPriceTo: " + selectedPriceTo)
        NSLog("selectedProvince: " + selectedProvince)
        NSLog("selectedCity: " + selectedCity)
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
        //self.loadingIndicator.hidden = false
        //self.loadingIndicator.startAnimating()
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
        
        stringUrl = stringUrl + "&downpaymentpct=" + self.downpayment.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&term=" + self.loanterm.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&ao=" + homeInfo[0].stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
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
        
        if(self.emptype.text! != "Unemployed"){
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
        
        stringUrl = stringUrl + "&bday=" + self.birthday.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&gender=" + (self.gender.selectedSegmentIndex == 0 ? "0" : "1")
        
        var civilstat = ""
        if let civilStatusCodeLabel = defaults.stringForKey("selectedCivilStatusCode") {
            civilstat = civilStatusCodeLabel
        }
        
        stringUrl = stringUrl + "&civilstat=" + civilstat.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&resphone=" + self.phonenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&mobileno=" + self.mobilenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&email=" + self.emailaddress.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&resadd1=" + self.address1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&resadd2=" + self.address2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        var emptype = ""
        if let empTypeIDLabel = defaults.stringForKey("selectedIncomeTypeID") {
            emptype = empTypeIDLabel
        }
        
        stringUrl = stringUrl + "&empbiz_type=" + emptype.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&empbizname=" + self.empname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        var jobposition = ""
        if let occupationIDLabel = defaults.stringForKey("selectedOccupationID") {
            jobposition = occupationIDLabel
        }
        
        stringUrl = stringUrl + "&jobpos=" + jobposition.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&empbiz_y=" + self.empyears.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&empbizadd1=" + self.empaddress1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&empbizadd2=" + self.empaddress2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&empbizphone=" + self.empphone.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&empbizmoincome=" + self.empincome.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        if(self.civilstatus.text == "Married"){
            
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
            
            if(self.spemptype.text! != "Unemployed"){
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
            
            stringUrl = stringUrl + "&spbday=" + self.spbirthday.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&spresphone=" + self.spphonenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&spmobileno=" + self.spmobilenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&spresadd1=" + self.spaddress1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&spresadd2=" + self.spaddress2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            var spemptype = ""
            if let spempTypeIDLabel = defaults.stringForKey("selectedSPIncomeTypeID") {
                spemptype = spempTypeIDLabel
            }
            
            stringUrl = stringUrl + "&spempbiz_type=" + spemptype.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&spempbizname=" + self.spempname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            var spjobposition = ""
            if let spoccupationIDLabel = defaults.stringForKey("selectedSPOccupationID") {
                spjobposition = spoccupationIDLabel
            }
            
            stringUrl = stringUrl + "&spjobpos=" + spjobposition.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
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
            
            if(self.c1emptype.text! != "Unemployed"){
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
            
            stringUrl = stringUrl + "&m1bday=" + self.c1birthday.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&m1gender=" + (self.c1gender.selectedSegmentIndex == 0 ? "0" : "1")
            stringUrl = stringUrl + "&m1resphone=" + self.c1phonenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1mobileno=" + self.c1mobilenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1resadd1=" + self.c1address1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1resadd2=" + self.c1address2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            var c1emptype = ""
            if let c1empTypeIDLabel = defaults.stringForKey("selectedC1IncomeTypeID") {
                c1emptype = c1empTypeIDLabel
            }
            
            stringUrl = stringUrl + "&m1empbiz_type=" + c1emptype.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&m1empbizname=" + self.c1empname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            var c1jobposition = ""
            if let c1occupationIDLabel = defaults.stringForKey("selectedC1OccupationID") {
                c1jobposition = c1occupationIDLabel
            }
            
            stringUrl = stringUrl + "&m1jobpos=" + c1jobposition.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
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
            
            if(self.c2emptype.text! != "Unemployed"){
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
            
            stringUrl = stringUrl + "&m2bday=" + self.c2birthday.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&m2gender=" + (self.c2gender.selectedSegmentIndex == 0 ? "0" : "1")
            stringUrl = stringUrl + "&m2resphone=" + self.c2phonenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2mobileno=" + self.c2mobilenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2resadd1=" + self.c2address1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2resadd2=" + self.c2address2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            var c2emptype = ""
            if let c2empTypeIDLabel = defaults.stringForKey("selectedC2IncomeTypeID") {
                c2emptype = c2empTypeIDLabel
            }
            
            stringUrl = stringUrl + "&m2empbiz_type=" + c2emptype.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            stringUrl = stringUrl + "&m2empbizname=" + self.c2empname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            var c2jobposition = ""
            if let c2occupationIDLabel = defaults.stringForKey("selectedC2OccupationID") {
                c2jobposition = c2occupationIDLabel
            }
            
            stringUrl = stringUrl + "&m2jobpos=" + c2jobposition.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
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
            
            //self.loadingIndicator.hidden = true
            //self.loadingIndicator.stopAnimating()
            self.view.userInteractionEnabled = true
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }else{
            NSUserDefaults.standardUserDefaults().setObject(self.lastname.text, forKey: "LASTNAME")
            NSUserDefaults.standardUserDefaults().setObject(self.firstname.text, forKey: "FIRSTNAME")
            NSUserDefaults.standardUserDefaults().setObject(self.middlename.text, forKey: "MIDDLENAME")
            NSUserDefaults.standardUserDefaults().setObject(self.birthday.text, forKey: "BIRTHDAY")
            NSUserDefaults.standardUserDefaults().setObject(self.mobilenumber.text, forKey: "MOBILENO")
            NSUserDefaults.standardUserDefaults().setObject(self.emailaddress.text, forKey: "EMAIL")
            NSUserDefaults.standardUserDefaults().setObject(self.phonenumber.text, forKey: "RESPHONE")
            NSUserDefaults.standardUserDefaults().setObject(self.empphone.text, forKey: "EMPBIZPHONE")
            NSUserDefaults.standardUserDefaults().setObject(self.address1.text, forKey: "RESADDLINE1")
            NSUserDefaults.standardUserDefaults().setObject(self.address2.text, forKey: "RESADDLINE2")
            NSUserDefaults.standardUserDefaults().setObject(self.empaddress1.text, forKey: "EMPBIZADDLINE1")
            NSUserDefaults.standardUserDefaults().setObject(self.empaddress2.text, forKey: "EMPBIZADDLINE2")
            NSUserDefaults.standardUserDefaults().setObject(self.empname.text, forKey: "EMPBIZNAME")
            
            let entityDescription = NSEntityDescription.entityForName("UrlStrings", inManagedObjectContext: self.managedObjectContext)
            let url = UrlStrings(entity:entityDescription!, insertIntoManagedObjectContext: self.managedObjectContext)
            url.url = stringUrl
            url.datecreated = String(NSDate())
            url.refid = "HOME"
            url.datesuccess = "0"
            
            self.view.userInteractionEnabled = true
            //self.loadingIndicator.hidden = true
            //self.loadingIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            let alert = UIAlertController(title: "Application Submitted", message: "Your new home loan application has been saved for submission. Please make sure not to quit the app and to have a stable data connection for a few minutes. You will receive an alert once it has been successfully sent.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                self.performSegueWithIdentifier("BackToHomeMain", sender: self)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
   
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var itemCount = 0
        if(vcAction == "ShowSearchPropertyPage"){
            if(section == 0){
                itemCount = 5
            }else if(section == 1){
                itemCount = 1
            }
        }
        
        if(vcAction == "ShowHomeLoanCalculator" || vcAction == "ShowCalculateAutoLoan"){
            if(section == 0){
                itemCount = 8
            }
        }
        
        if(vcAction == "ShowHomeApplication" || vcAction == "ShowComputedHomeApp"){
            if(section == 0){
                itemCount = 23
            } else if(section == 1){
                if(self.civilstatus.text == "Married"){
                    itemCount = 18
                }else{
                    itemCount = 0
                }
            } else if(section == 2){
                itemCount = 1
            } else if(section == 3 || section == 4 || section == 5){
                if(section == 3){
                    if(self.withc1.on){
                        itemCount = 19
                    } else{
                        itemCount = 0
                    }
                }
                
                if(section == 4){
                    if(self.withc1.on){
                        itemCount = 1
                    } else{
                        itemCount = 0
                    }
                }
                
                if(section == 5){
                    if(!self.withc1.on){
                        itemCount = 0
                    }else{
                        if(self.withc2.on){
                            itemCount = 19
                        } else{
                            itemCount = 0
                        }
                    }
                }
            } else if(section == 6){
                itemCount = 1
            } else if(section == 7){
                itemCount = 1
            }
        }
        return itemCount
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerHeight: CGFloat = 0
        
        if(vcAction == "ShowSearchPropertyPage"){
            if(section == 0 || section == 1){
                headerHeight = tableView.sectionHeaderHeight
            }
        }
        
        if(vcAction == "ShowHomeLoanCalculator" || vcAction == "ShowCalculateAutoLoan"){
            if(section == 0){
                headerHeight = tableView.sectionHeaderHeight
            }
        }
        
        if(vcAction == "ShowHomeApplication" || vcAction == "ShowComputedHomeApp"){
            if(section == 0){
                headerHeight = tableView.sectionHeaderHeight
            }
            
            if(section == 1){
                if(self.civilstatus.text == "Married"){
                    headerHeight = tableView.sectionHeaderHeight
                }
                else{
                    headerHeight = CGFloat.min
                }
            }
            
            if(section == 2){
                headerHeight = tableView.sectionHeaderHeight
            }
            
            if(section == 3){
                if(self.withc1.on){
                    headerHeight = tableView.sectionHeaderHeight
                }
                else {
                    headerHeight = CGFloat.min
                }
            }
            
            if(section == 4){
                if(self.withc1.on){
                    headerHeight = tableView.sectionHeaderHeight
                }
                else {
                    headerHeight = CGFloat.min
                }
            }
            
            if(section == 5){
                if(!self.withc1.on){
                    headerHeight = CGFloat.min
                }else{
                    if(self.withc2.on){
                        headerHeight = tableView.sectionHeaderHeight
                    }
                    else {
                        headerHeight = CGFloat.min
                    }
                }
            }
            
            if(section == 6){
                headerHeight = tableView.sectionHeaderHeight
            }
            
            if(section == 7){
                headerHeight = tableView.sectionHeaderHeight
            }
        }
        
        return headerHeight
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var footerHeight: CGFloat = 0
        
        if(vcAction == "ShowSearchPropertyPage"){
            if(section == 0 || section == 1){
                footerHeight = tableView.sectionFooterHeight
            }
        }
        
        if(vcAction == "ShowHomeLoanCalculator" || vcAction == "ShowCalculateAutoLoan"){
            if(section == 0){
                footerHeight = tableView.sectionFooterHeight
            }
        }
        
        if(vcAction == "ShowHomeApplication" || vcAction == "ShowComputedHomeApp"){
            if(section == 0){
                footerHeight = tableView.sectionFooterHeight
            }
            
            if(section == 1){
                if(self.civilstatus.text == "Married"){
                    footerHeight = tableView.sectionFooterHeight
                }
                else{
                    footerHeight = CGFloat.min
                }
            }
            
            if(section == 2){
                footerHeight = tableView.sectionFooterHeight
            }
            
            if(section == 3){
                if(self.withc1.on){
                    footerHeight = tableView.sectionFooterHeight
                }
                else {
                    footerHeight = CGFloat.min
                }
            }
            
            if(section == 4){
                if(self.withc1.on){
                    footerHeight = tableView.sectionFooterHeight
                }
                else {
                    footerHeight = CGFloat.min
                }
            }
            
            if(section == 5){
                if(self.withc2.on){
                    footerHeight = tableView.sectionFooterHeight
                }
                else {
                    footerHeight = CGFloat.min
                }
            }
            
            if(section == 6){
                footerHeight = tableView.sectionFooterHeight
            }
            
            if(section == 7){
                footerHeight = tableView.sectionFooterHeight
            }
        }
        
        return footerHeight
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionHeader = ""
        
        if(vcAction == "ShowSearchPropertyPage"){
            if(section == 0){
                sectionHeader = "Search for a property"
            }
            else if(section == 1){
                sectionHeader = ""
            }
        }
        
        if(vcAction == "ShowHomeLoanCalculator" || vcAction == "ShowCalculateAutoLoan"){
            if(section == 0){
                sectionHeader = "Home Loan Calculator"
            }
        }
        
        if(vcAction == "ShowHomeApplication" || vcAction == "ShowComputedHomeApp"){
            if(section == 0){
                sectionHeader = "New Home Loan Application"
            }
            else if(section == 1){
                if(self.civilstatus.text == "Married"){
                    sectionHeader = "Spouse Information"
                }else{
                    sectionHeader = ""
                }
            } else if(section == 2){
                sectionHeader = "Additional Co-maker"
            } else if(section == 3 || section == 4){
                if(section == 3){
                    if(self.withc1.on){
                        sectionHeader = "Co-maker 1 Information"
                    }else{
                        sectionHeader = ""
                    }
                }
                
                if(section == 4){
                    if(self.withc1.on){
                        sectionHeader = "Additional Co-maker"
                    }else{
                        sectionHeader = ""
                    }
                }
                
            } else if(section == 5){
                if(!self.withc1.on){
                    sectionHeader = ""
                }else{
                    if(self.withc2.on){
                        sectionHeader = "Co-maker 2 Information"
                    }else{
                        sectionHeader = ""
                    }
                }
            } else if(section == 6){
                sectionHeader = "Remarks"
            } else if(section == 7){
                sectionHeader = ""
            }
        }
        
        return sectionHeader
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(vcAction == "ShowHomeApplication" || vcAction == "ShowComputedHomeApp")
        {
            if indexPath.section == 0 && indexPath.row == 7 {
                toggleDatepicker()
            }
            
            if indexPath.section == 1 && indexPath.row == 3 {
                spousebdaytoggleDatepicker()
            }
            
            if indexPath.section == 3 && indexPath.row == 3 {
                c1bdaytoggleDatepicker()
            }
            
            if indexPath.section == 5 && indexPath.row == 3 {
                c2bdaytoggleDatepicker()
            }
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(vcAction == "ShowHomeApplication" || vcAction == "ShowComputedHomeApp")
        {
            if bdaydatePickerHidden && indexPath.section == 0 && indexPath.row == 8 {
                return 0
            }
            else if unemployedFieldsHidden == true && indexPath.section == 0 && indexPath.row == 16 {
                return 0
            }
            else if unemployedFieldsHidden == true && indexPath.section == 0 && indexPath.row == 17 {
                return 0
            }
            else if unemployedFieldsHidden == true && indexPath.section == 0 && indexPath.row == 18 {
                return 0
            }
            else if unemployedFieldsHidden == true && indexPath.section == 0 && indexPath.row == 19 {
                return 0
            }
            else if unemployedFieldsHidden == true && indexPath.section == 0 && indexPath.row == 20 {
                return 0
            }
            else if unemployedFieldsHidden == true && indexPath.section == 0 && indexPath.row == 21 {
                return 0
            }
            else if unemployedFieldsHidden == true && indexPath.section == 0 && indexPath.row == 22 {
                return 0
            }
            else if unemployedFieldsHidden == true && indexPath.section == 0 && indexPath.row == 23 {
                return 0
            }
            else if spousebdaydatePickerHidden && indexPath.section == 1 && indexPath.row == 4 {
                return 0
            }
            else if spUnemployedFieldsHidden == true && indexPath.section == 1 && indexPath.row == 11 {
                return 0
            }
            else if spUnemployedFieldsHidden == true && indexPath.section == 1 && indexPath.row == 12 {
                return 0
            }
            else if spUnemployedFieldsHidden == true && indexPath.section == 1 && indexPath.row == 13 {
                return 0
            }
            else if spUnemployedFieldsHidden == true && indexPath.section == 1 && indexPath.row == 14 {
                return 0
            }
            else if spUnemployedFieldsHidden == true && indexPath.section == 1 && indexPath.row == 15 {
                return 0
            }
            else if spUnemployedFieldsHidden == true && indexPath.section == 1 && indexPath.row == 16 {
                return 0
            }
            else if spUnemployedFieldsHidden == true && indexPath.section == 1 && indexPath.row == 17 {
                return 0
            }
            else if c1bdaydatePickerHidden && indexPath.section == 3 && indexPath.row == 4 {
                return 0
            }
            else if c1UnemployedFieldsHidden == true && indexPath.section == 3 && indexPath.row == 12 {
                return 0
            }
            else if c1UnemployedFieldsHidden == true && indexPath.section == 3 && indexPath.row == 13 {
                return 0
            }
            else if c1UnemployedFieldsHidden == true && indexPath.section == 3 && indexPath.row == 14 {
                return 0
            }
            else if c1UnemployedFieldsHidden == true && indexPath.section == 3 && indexPath.row == 15 {
                return 0
            }
            else if c1UnemployedFieldsHidden == true && indexPath.section == 3 && indexPath.row == 16 {
                return 0
            }
            else if c1UnemployedFieldsHidden == true && indexPath.section == 3 && indexPath.row == 17 {
                return 0
            }
            else if c1UnemployedFieldsHidden == true && indexPath.section == 3 && indexPath.row == 18 {
                return 0
            }
            else if c2bdaydatePickerHidden && indexPath.section == 5 && indexPath.row == 4 {
                return 0
            }
            else if c2UnemployedFieldsHidden == true && indexPath.section == 5 && indexPath.row == 12 {
                return 0
            }
            else if c2UnemployedFieldsHidden == true && indexPath.section == 5 && indexPath.row == 13 {
                return 0
            }
            else if c2UnemployedFieldsHidden == true && indexPath.section == 5 && indexPath.row == 14 {
                return 0
            }
            else if c2UnemployedFieldsHidden == true && indexPath.section == 5 && indexPath.row == 15 {
                return 0
            }
            else if c2UnemployedFieldsHidden == true && indexPath.section == 5 && indexPath.row == 16 {
                return 0
            }
            else if c2UnemployedFieldsHidden == true && indexPath.section == 5 && indexPath.row == 17 {
                return 0
            }
            else if c2UnemployedFieldsHidden == true && indexPath.section == 5 && indexPath.row == 18 {
                return 0
            }
            else {
                return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            }
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //SEARCH FOR A PROPERTY
        if segue.identifier == "ShowPropertyType"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowPropertyType"
            }
        }
        
        if segue.identifier == "ShowProvinceList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowProvinceList"
            }
        }
        
        if segue.identifier == "ShowCityList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowCityList"
            }
        }
        
        if segue.identifier == "ShowPropertyModelList"
        {
            if let destinationVC = segue.destinationViewController as? ListTableViewController{
                destinationVC.vcAction = "ShowPropertyModelList"
            }
        }
        
        //HOMELOANS APPLICATION
        if segue.identifier == "ShowDownpaymentPercentList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowDownpaymentPercentList"
            }
        }
        
        if segue.identifier == "ShowHomeTermList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowHomeTermList"
            }
        }
        
        if segue.identifier == "ShowIncomeType"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowIncomeType"
            }
        }
        
        if segue.identifier == "ShowOccupationList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowOccupationList"
            }
        }
        
        if segue.identifier == "ShowSPIncomeType"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowSPIncomeType"
            }
        }
        
        if segue.identifier == "ShowSPOccupationList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowSPOccupationList"
            }
        }
        
        if segue.identifier == "ShowC1IncomeType"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowC1IncomeType"
            }
        }
        
        if segue.identifier == "ShowC1OccupationList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowC1OccupationList"
            }
        }
        
        if segue.identifier == "ShowC2IncomeType"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowC2IncomeType"
            }
        }
        
        if segue.identifier == "ShowC2OccupationList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowC2OccupationList"
            }
        }
        
        if segue.identifier == "ShowRecentlyViewedCarModel"
        {
            if let destinationVC = segue.destinationViewController as? ListTableViewController{
                destinationVC.vcAction = "ShowRecentlyViewedCarModel"
            }
        }
        
        if segue.identifier == "ShowCivilStatusList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowCivilStatusList"
            }
        }
        
        if segue.identifier == "ShowC1CivilStatusList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowC1CivilStatusList"
            }
        }
        
        if segue.identifier == "ShowC2CivilStatusList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowC2CivilStatusList"
            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
}