//
//  HomeTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 03/11/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit

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
    var selectedTerm = "10"
    var selectedDP = "10"
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
    
    override func viewDidAppear(animated: Bool) {
        if(vcAction == "ShowHomeLoanCalculator" || vcAction == "ShowHomeApplication" || vcAction == "ShowComputedHomeApp"){
            if let DPLabel = defaults.stringForKey("selectedDP") {
                self.downpaymentCell.detailTextLabel?.text = DPLabel
            }
            
            if let termLabel = defaults.stringForKey("selectedTerm") {
                self.termCell.detailTextLabel?.text = termLabel
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
}