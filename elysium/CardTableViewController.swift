//
//  CardTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 03/11/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit
import CoreData

class CardTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var withConnection = false
    var urlIMG = ""
    var id = ""
    var name = ""
    var email = ""
    var autoInfo = ["","","",""]
    var homeInfo = ["","",""]
    var ccInfo = ["","","",""]
    var autoRates = [("",0.00)]
    var homeRates = [("",0.00)]
    
    var salutationArr = [("MR","Mr"),("MRS","Mrs"),("MS","Ms")]
    
    var selectedSalutation = ""
    var selectedCivilStatusCode = ""
    var selectedC1Salutation = ""
    var selectedC2Salutation = ""
    var selectedProvince = ""
    var selectedBizProvince = ""
    var vcAction = ""
    var selectedCity = ""
    var selectedBizCity = ""
    var selectedIncomeType = ""
    var selectedIncomeTypeID = ""
    var selectedOccupation = ""
    var selectedOccupationGroup = ""
    var selectedIndustry = ""
    var selectedIndustryCode = ""
    var selectedBank = ""
    var selectedBankCode = ""
    var selectedOccupationID = ""
    var selectedImage = ""
    var selectedSourceOfImage = ""
    
    var imagePath_1 = ""
    var imagePath_2 = ""
    var imagePath_3 = ""
    
    var submittedApplicationID = ""
    
    var bdaydatePickerHidden = true
    var c1bdaydatePickerHidden = true
    var c2bdaydatePickerHidden = true
    
    var targetURL1 = ""
    var targetURL2 = ""
    var targetURL3 = ""
    
    var filename = ""
    
    var uploadedPhotosDets = [String: String]()
    
    @IBOutlet var creditCardApplicationTable: UITableView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfLogged()
        
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AutoTableViewController.DismissKeyboard))
        view.addGestureRecognizer(dismiss)
        dismiss.cancelsTouchesInView = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AutoTableViewController.keyboardWasShown(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AutoTableViewController.keyboardWasNotShown(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        datePickerChanged()
        c1datePickerChanged()
        c2datePickerChanged()

        btnDeleteImage1.hidden = true
        btnDeleteImage2.hidden = true
        btnDeleteImage3.hidden = true
        
        self.defaults.setObject("", forKey: "selectedSourceOfImage")
        self.defaults.setObject("", forKey: "imagePath_1")
        self.defaults.setObject("", forKey: "imagePath_2")
        self.defaults.setObject("", forKey: "imagePath_3")
        self.defaults.setObject("", forKey: "submittedApplicationID")
    }
    
    override func viewDidLayoutSubviews() {
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            self.tableView.contentInset = UIEdgeInsetsMake( y, 0, 0, 0)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        if(vcAction == "ShowApplyCard" || vcAction == "ApplyCreditCard"){

            if let salutationLabel = defaults.stringForKey("selectedSalutation") {
                self.salutationCell.detailTextLabel?.text = salutationLabel
            }
            
            if let C1salutationLabel = defaults.stringForKey("selectedC1Salutation") {
                self.C1salutationCell.detailTextLabel?.text = C1salutationLabel
            }
            
            if let C2salutationLabel = defaults.stringForKey("selectedC2Salutation") {
                self.C2salutationCell.detailTextLabel?.text = C2salutationLabel
            }
            
            if let civilStatusLabel = defaults.stringForKey("selectedCivilStatus") {
                self.civilStatusCell.detailTextLabel?.text = civilStatusLabel
            }
            
            if let provinceLabel = defaults.stringForKey("selectedProvince_present") {
                self.provinceCell.detailTextLabel?.text = provinceLabel
            }
            
            if let cityLabel = defaults.stringForKey("selectedCity_present") {
                self.cityCell.detailTextLabel?.text = cityLabel
            }
            
            if let permprovinceLabel = defaults.stringForKey("selectedProvince_permanent") {
                self.permprovinceCell.detailTextLabel?.text = permprovinceLabel
            }
            
            if let permcityLabel = defaults.stringForKey("selectedCity_permanent") {
                self.permcityCell.detailTextLabel?.text = permcityLabel
            }
            
            if let provinceBizLabel = defaults.stringForKey("selectedProvinceBiz") {
                self.provinceBizCell.detailTextLabel?.text = provinceBizLabel
            }
            
            if let cityBizLabel = defaults.stringForKey("selectedCityBiz") {
                self.cityBizCell.detailTextLabel?.text = cityBizLabel
            }
            
            if let occupationLabel = defaults.stringForKey("selectedOccupation") {
                self.occupationCell.detailTextLabel?.text = occupationLabel
            }
            
            if let occupationGroupLabel = defaults.stringForKey("selectedOccupationGroup") {
                self.occupationGroupCell.detailTextLabel?.text = occupationGroupLabel
            }
            
            if let industryLabel = defaults.stringForKey("selectedIndustry") {
                self.industryCell.detailTextLabel?.text = industryLabel
            }
            
            if let bankLabel = defaults.stringForKey("selectedBank") {
                self.bankCell.detailTextLabel?.text = bankLabel
            }
            
            if let incomeTypeLabel = defaults.stringForKey("selectedIncomeType") {
                self.incomeTypeCell.detailTextLabel?.text = incomeTypeLabel
            }
            
            if let homeOwnershipLabel = defaults.stringForKey("selectedHomeOwnership") {
                self.homeownershipCell.detailTextLabel?.text = homeOwnershipLabel
            }
            
            if let sourceOfFundLabel = defaults.stringForKey("selectedSourceOfFund") {
                self.empsourcefundsCell.detailTextLabel?.text = sourceOfFundLabel
            }
            
            if let cardTypeNameLabel = defaults.stringForKey("selectedCardTypeName") {
                self.cardTypeCell.detailTextLabel?.text = cardTypeNameLabel
            }
            
            if let billingAddressLabel = defaults.stringForKey("selectedBillingAddress") {
                self.billingAddressCell.detailTextLabel?.text = billingAddressLabel
            }
            
            if let deliveryAddressLabel = defaults.stringForKey("selectedDeliveryAddress") {
                self.deliveryAddressCell.detailTextLabel?.text = deliveryAddressLabel
            }
        }
        
        creditCardApplicationTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkIfLogged(){
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
        
        if(self.id != ""){
            if (userDefaults.objectForKey("ccInfo") != nil) {
                self.ccInfo = NSUserDefaults.standardUserDefaults().valueForKey("ccInfo") as! [String]
            }
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
        //self.loadingIndicator.hidden = false
        //self.loadingIndicator.startAnimating()
        self.view.userInteractionEnabled = false
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let url = NSLocalizedString("urlCATS", comment: "")
        
        var stringUrl = url
        
        var cardtypecode = ""
        if let cardTypeLabel = defaults.stringForKey("selectedCardType") {
            cardtypecode = cardTypeLabel
        }
        
        var errorctr = 0;
        var errormsg = "";
        stringUrl = stringUrl + "&companyid=" + self.id
        
        stringUrl = stringUrl + "&cardproduct=" + cardtypecode.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&aoemail=" + ccInfo[1].stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&appsource=" + (self.id != "NON" ? "WAP" : "Online Application").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!; //CHECK WITH LIBFIELDVALUES
        stringUrl = stringUrl + "&rm=" + "";
        stringUrl = stringUrl + "&sourcearea=" + "Not Applicable".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&sourcetype=" + "Head Office".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        //stringUrl = stringUrl + "&clientclass=" + (self.id != "NON" ? "WAP (WORKPLACE ARRANGEMENT PROGR" : "REGULAR").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!; //ADD TO LIBFIELDVALUES = REGULAR
        //stringUrl = stringUrl + "&clienttype=" + "0".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        if(self.lastname.text == ""){
            errorctr += 1;
            errormsg += "Last Name\n";
        }
        if(self.firstname.text == ""){
            errorctr += 1;
            errormsg += "First Name\n";
        }
        if(self.mobilenumber.text == ""){
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
        
        var incomeTypeID = ""
        if let incomeTypeIDLabel = defaults.stringForKey("selectedIncomeTypeID") {
            incomeTypeID = incomeTypeIDLabel
        }
        if(incomeTypeID != "6"){
            if(self.empname.text == ""){
                errorctr += 1;
                errormsg += "Emp/Biz Name\n";
            }
            if(self.empincome.text == ""){
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
        
        stringUrl = stringUrl + "&bPlace=" + self.bPlace.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&mothermaidenname=" + self.mothermaidenname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&gender=" + (self.salutation.text! == "Mr" ? "0" : "1")
        
        stringUrl = stringUrl + "&title=" +
            self.salutation.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&res_ownership=" + self.homeownership.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        //stringUrl = stringUrl + "&empsourcefunds=" + self.empsourcefunds.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        var civilstat = ""
        if let civilStatusCodeLabel = defaults.stringForKey("selectedCivilStatusCode") {
            civilstat = civilStatusCodeLabel
        }
        
        stringUrl = stringUrl + "&civilstat=" + civilstat.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&resphone=" + self.phonenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&mobileno=" + self.mobilenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&email=" + self.emailaddress.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&resadd1=" + self.address1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        //stringUrl = stringUrl + "&resadd2=" + self.address2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&empbizstatus=" + incomeTypeID.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        //stringUrl = stringUrl + "&remarks=" + self.bank.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        
        stringUrl = stringUrl + "&empbizname=" + self.empname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        var jobposition = ""
        if let occupationIDLabel = defaults.stringForKey("selectedOccupationID") {
            jobposition = occupationIDLabel
            print("jobposition" + jobposition)
        }
        
        stringUrl = stringUrl + "&jobpos=" + jobposition.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        stringUrl = stringUrl + "&empbiz_y=" + self.empyears.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&empbizaddress=" + self.empaddress1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        //stringUrl = stringUrl + "&empbizadd2=" + self.empaddress2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&empbizphone=" + self.empphone.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        stringUrl = stringUrl + "&empbizannualincome=" + self.empincome.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
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
            
            stringUrl = stringUrl + "&m1bday=" + self.c1birthday.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            //stringUrl = stringUrl + "&m1gender=" + (self.c1gender.selectedSegmentIndex == 0 ? "0" : "1")
            stringUrl = stringUrl + "&m1resphone=" + self.c1phonenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1mobileno=" + self.c1mobilenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m1resadd1=" + self.c1address1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m1resadd2=" + self.c1address2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
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
            
            stringUrl = stringUrl + "&m2bday=" + self.c2birthday.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            //stringUrl = stringUrl + "&m2gender=" + (self.c2gender.selectedSegmentIndex == 0 ? "0" : "1")
            stringUrl = stringUrl + "&m2resphone=" + self.c2phonenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2mobileno=" + self.c2mobilenumber.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            stringUrl = stringUrl + "&m2resadd1=" + self.c2address1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m2resadd2=" + self.c2address2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            //stringUrl = stringUrl + "&m2empbiz_type=" + emptypeArr[self.c2emptype.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            //stringUrl = stringUrl + "&m2empbizname=" + self.c2empname.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            //stringUrl = stringUrl + "&m2jobpos=" + positionArr[self.c2position.selectedRowInComponent(0)].0.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            
            //stringUrl = stringUrl + "&m2empbiz_y=" + self.c2empyears.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m2empbizadd1=" + self.c2empaddress1.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m2empbizadd2=" + self.c2empaddress2.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m2empbizphone=" + self.c2empphone.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
            //stringUrl = stringUrl + "&m2empbizmoincome=" + self.c2empincome.text!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        }
        
        let mReqId = UIDevice.currentDevice().identifierForVendor!.UUIDString + "-" + cardtypecode + "-" + self.lastname.text! + "-" + self.firstname.text! + "-" + self.birthday.text!
        
        defaults.setObject(mReqId, forKey: "submittedApplicationID")
        
        if let path1 = defaults.stringForKey("imagePath_1") {
            imagePath_1 = path1
        }
        
        if let path2 = defaults.stringForKey("imagePath_2") {
            imagePath_2 = path2
        }
        
        if let path3 = defaults.stringForKey("imagePath_3") {
            imagePath_3 = path3
        }
        
        stringUrl = stringUrl + "&applicationId=" + mReqId.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
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

            if(imagePath_1 != "") {
                imageUploadRequest(imageView: image1)
            }
            if(imagePath_2 != "") {
                imageUploadRequest(imageView: image2)
            }
            if(imagePath_3 != "") {
                imageUploadRequest(imageView: image3)
            }
            NSLog("MREQID: " + mReqId)
            let entityDescription = NSEntityDescription.entityForName("UrlStrings", inManagedObjectContext: managedObjectContext)
            let url = UrlStrings(entity:entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
            url.url = stringUrl
            url.datecreated = String(NSDate())
            url.refid = "CARD"
            url.datesuccess = "0"
 
            NSLog("stringUrl: " + stringUrl)
            
            self.view.userInteractionEnabled = true
            //self.loadingIndicator.hidden = true
            //self.loadingIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()

            let alert = UIAlertController(title: "Application Submitted", message: "Your new credit card application has been saved for submission. Please make sure not to quit the app and to have a stable data connection for a few minutes. You will receive an alert once it has been successfully sent.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                self.performSegueWithIdentifier("BackToCardMain", sender: self)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet var cardTypeCell: UITableViewCell!
    @IBOutlet var salutationCell: UITableViewCell!
    @IBOutlet var civilStatusCell: UITableViewCell!
    @IBOutlet var provinceCell: UITableViewCell!
    @IBOutlet var cityCell: UITableViewCell!
    
    @IBOutlet var permprovinceCell: UITableViewCell!
    @IBOutlet var permcityCell: UITableViewCell!
    @IBOutlet var homeownershipCell: UITableViewCell!
    
    @IBOutlet var incomeTypeCell: UITableViewCell!
    @IBOutlet var occupationCell: UITableViewCell!
    @IBOutlet var occupationGroupCell: UITableViewCell!
    @IBOutlet var industryCell: UITableViewCell!
    @IBOutlet var bankCell: UITableViewCell!
    @IBOutlet var provinceBizCell: UITableViewCell!
    @IBOutlet var cityBizCell: UITableViewCell!
    @IBOutlet var empsourcefundsCell: UITableViewCell!
    
    @IBOutlet var C1salutationCell: UITableViewCell!
    @IBOutlet var C2salutationCell: UITableViewCell!
    
    @IBOutlet var billingAddressCell: UITableViewCell!
    @IBOutlet var deliveryAddressCell: UITableViewCell!
    
    @IBOutlet var cardtype: UILabel!
    
    @IBOutlet var salutation: UILabel!
    @IBOutlet var lastname: UITextField!
    @IBOutlet var firstname: UITextField!
    @IBOutlet var middlename: UITextField!
    
    @IBOutlet var birthday: UILabel!
    @IBOutlet var bPlace: UITextField!
    @IBOutlet var mothermaidenname: UITextField!
    @IBOutlet var civilstatus: UILabel!
    @IBOutlet var phonenumber: UITextField!
    @IBOutlet var mobilenumber: UITextField!
    @IBOutlet var emailaddress: UITextField!
    
    @IBOutlet var address1: UITextField!
    @IBOutlet var address2: UITextField!
    @IBOutlet var province: UILabel!
    @IBOutlet var city: UILabel!
    @IBOutlet var postalcode: UITextField!
    
    @IBOutlet var withpermaddress: UISwitch!
    @IBOutlet var permaddress1: UITextField!
    @IBOutlet var permaddress2: UITextField!
    @IBOutlet var permprovince: UILabel!
    @IBOutlet var permcity: UILabel!
    @IBOutlet var permpostalcode: UITextField!
    @IBOutlet var homeownership: UILabel!
    //yearsofstay
    @IBOutlet var industry: UILabel!
    @IBOutlet var bank: UILabel!
    
    @IBOutlet var emptype: UILabel!
    @IBOutlet var empname: UITextField!
    @IBOutlet var position: UILabel!
    @IBOutlet var positiongroup: UILabel!
    @IBOutlet var bizindustry: UILabel!
    @IBOutlet var empyears: UITextField!
    @IBOutlet var empaddress1: UITextField!
    @IBOutlet var empaddress2: UITextField!
    @IBOutlet var empprovince: UILabel!
    @IBOutlet var empcity: UILabel!
    @IBOutlet var emppostalcode: UITextField!
    @IBOutlet var empphone: UITextField!
    @IBOutlet var tin: UITextField!
    @IBOutlet var sss: UITextField!
    @IBOutlet var gsis: UITextField!
    @IBOutlet var empincome: UITextField!
    @IBOutlet var empsourcefunds: UILabel!
    
    @IBOutlet var withexistingcard: UISwitch!
    @IBOutlet var withexistingbankname: UILabel!
    @IBOutlet var withexistingcardno: UITextField!
    
    @IBOutlet var withc1: UISwitch!
    
    @IBOutlet var c1salutation: UILabel!
    @IBOutlet var c1lastname: UITextField!
    @IBOutlet var c1firstname: UITextField!
    @IBOutlet var c1middlename: UITextField!
    @IBOutlet var c1birthday: UILabel!
    @IBOutlet var c1phonenumber: UITextField!
    @IBOutlet var c1mobilenumber: UITextField!
    @IBOutlet var c1address1: UITextField!
    /*
    @IBOutlet var c1address2: UITextField!
    */
    @IBOutlet var withc2: UISwitch!
    
    @IBOutlet var c2salutation: UILabel!
    @IBOutlet var c2lastname: UITextField!
    @IBOutlet var c2firstname: UITextField!
    @IBOutlet var c2middlename: UITextField!
    @IBOutlet var c2birthday: UILabel!
    @IBOutlet var c2phonenumber: UITextField!
    @IBOutlet var c2mobilenumber: UITextField!
    @IBOutlet var c2address1: UITextField!
    /*
    @IBOutlet var c2address2: UITextField!
    */
    //@IBOutlet var c2permaddress: UITextField!
    @IBOutlet var billingaddress: UILabel!
    @IBOutlet var deliveryaddress: UILabel!
    
    @IBOutlet var bdaydatePicker: UIDatePicker!
    @IBOutlet var bdaydetailLabel: UILabel!
    @IBOutlet var c1bdaydatePicker: UIDatePicker!
    @IBOutlet var c1bdaydetailLabel: UILabel!
    @IBOutlet var c2bdaydatePicker: UIDatePicker!
    @IBOutlet var c2bdaydetailLabel: UILabel!
    
    @IBAction func datePickerChanged() {
        if(vcAction == "ShowApplyCard" || vcAction == "ApplyCreditCard")
        {
            bdaydetailLabel.text = NSDateFormatter.localizedStringFromDate(bdaydatePicker.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        }
    }
    
    @IBAction func c1datePickerChanged() {
        if(vcAction == "ShowApplyCard" || vcAction == "ApplyCreditCard")
        {
            c1bdaydetailLabel.text = NSDateFormatter.localizedStringFromDate(c1bdaydatePicker.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        }
    }
    
    @IBAction func c2datePickerChanged() {
        if(vcAction == "ShowApplyCard" || vcAction == "ApplyCreditCard")
        {
            c2bdaydetailLabel.text = NSDateFormatter.localizedStringFromDate(c2bdaydatePicker.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        }
    }
    
    func toggleDatepicker() {
        bdaydatePickerHidden = !bdaydatePickerHidden
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
    
    @IBAction func actionTogglePermAddress(sender: AnyObject) {
        if(self.withpermaddress.on == true) {
            permaddress1.text = address1.text
            permaddress2.text = address2.text
            defaults.setObject(province.text, forKey: "selectedProvince_permanent")
            if let permprovinceLabel = defaults.stringForKey("selectedProvince_permanent") {
                self.permprovinceCell.detailTextLabel?.text = permprovinceLabel
            }
            defaults.setObject(city.text, forKey: "selectedCity_permanent")
            if let permcityLabel = defaults.stringForKey("selectedCity_permanent") {
                self.permcityCell.detailTextLabel?.text = permcityLabel
            }
            permpostalcode.text = postalcode.text
            
            creditCardApplicationTable.reloadData()
        }else{
            permaddress1.text = ""
            permaddress2.text = ""
            defaults.setObject("", forKey: "selectedProvince_permanent")
            self.permprovinceCell.detailTextLabel?.text = ""
            defaults.setObject("", forKey: "selectedCity_permanent")
            self.permcityCell.detailTextLabel?.text = ""
            permpostalcode.text = ""
            
            creditCardApplicationTable.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(vcAction == "ShowApplyCard" || vcAction == "ApplyCreditCard")
        {
            if indexPath.section == 1 && indexPath.row == 8 {
                toggleDatepicker()
            }
            
            if indexPath.section == 7 && indexPath.row == 4 {
                c1bdaytoggleDatepicker()
            }
            
            if indexPath.section == 9 && indexPath.row == 4 {
                c2bdaytoggleDatepicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(vcAction == "ShowApplyCard" || vcAction == "ApplyCreditCard")
        {
            if bdaydatePickerHidden && indexPath.section == 1 && indexPath.row == 9 {
                return 0
            }
            else if c1bdaydatePickerHidden && indexPath.section == 7 && indexPath.row == 5 {
                return 0
            }
            else if c2bdaydatePickerHidden && indexPath.section == 9 && indexPath.row == 5 {
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var itemCount = 0
        
        if(vcAction == "ShowApplyCard" || vcAction == "ApplyCreditCard"){
            if(section == 0){
                itemCount = 1
            }
            if(section == 1){
                itemCount = 14
            }
            else if(section == 2){
                itemCount = 5
            }
            else if(section == 3){
                itemCount = 8
            }
            else if(section == 4){
                itemCount = 17
            }
            else if(section == 5){
                itemCount = 3
            }
            else if(section == 6){
                itemCount = 1
            }
            else if(section == 7 || section == 8 || section == 9){
                if(section == 7){
                    if(self.withc1.on){
                        itemCount = 18
                    }
                    else {
                        itemCount = 0
                    }
                }
                
                if(section == 8){
                    if(self.withc1.on){
                        itemCount = 1
                    }
                    else {
                        itemCount = 0
                    }
                }
                
                if(section == 9){
                    if(!self.withc1.on){
                        itemCount = 0
                    }else{
                        if(self.withc2.on){
                            itemCount = 18
                        }
                        else {
                            itemCount = 0
                        }
                    }
                }
            }
            else if(section == 10){
                itemCount = 2
            }
            else if(section == 11){
                itemCount = 3
            }
            else if(section == 12){
                itemCount = 1
            }
        }
        return itemCount
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerHeight: CGFloat = 0
        
        if(vcAction == "ShowApplyCard" || vcAction == "ApplyCreditCard"){
            
            if(section == 0){
                headerHeight = tableView.sectionHeaderHeight
            }
            
            if(section == 1){
                headerHeight = tableView.sectionHeaderHeight
            }
            
            if(section == 2){
                headerHeight = tableView.sectionHeaderHeight
            }
            
            if(section == 3){
                headerHeight = tableView.sectionHeaderHeight
            }
            
            if(section == 4){
                headerHeight = tableView.sectionHeaderHeight
            }
            
            if(section == 5){
                headerHeight = tableView.sectionHeaderHeight
            }
            
            if(section == 6){
                headerHeight = tableView.sectionHeaderHeight
            }
            
            if(section == 7){
                if(self.withc1.on){
                    headerHeight = tableView.sectionHeaderHeight
                }
                else {
                    headerHeight = CGFloat.min
                }
            }
            
            if(section == 8){
                if(self.withc1.on){
                    headerHeight = tableView.sectionHeaderHeight
                }
                else {
                    headerHeight = CGFloat.min
                }
            }
            
            if(section == 9){
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
            
            if(section == 10){
                headerHeight = tableView.sectionHeaderHeight
            }
            
            if(section == 11){
                headerHeight = tableView.sectionHeaderHeight
            }
            
            if(section == 12){
                headerHeight = tableView.sectionHeaderHeight
            }
        }
        
        return headerHeight
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var footerHeight: CGFloat = 0
        
        if(vcAction == "ShowApplyCard" || vcAction == "ApplyCreditCard"){
            
            if(section == 0){
                footerHeight = tableView.sectionFooterHeight
            }
            
            if(section == 1){
               footerHeight = tableView.sectionFooterHeight
            }
            
            if(section == 2){
                footerHeight = tableView.sectionFooterHeight
            }
            
            if(section == 3){
                footerHeight = tableView.sectionFooterHeight
            }
            
            if(section == 4){
                footerHeight = tableView.sectionFooterHeight
            }
            
            if(section == 5){
                footerHeight = tableView.sectionFooterHeight
            }
            
            if(section == 6){
                footerHeight = tableView.sectionFooterHeight
            }
            
            if(section == 7){
                if(self.withc1.on){
                    footerHeight = tableView.sectionFooterHeight
                }
                else {
                    footerHeight = CGFloat.min
                }
            }
            
            if(section == 8){
                if(self.withc1.on){
                    footerHeight = tableView.sectionFooterHeight
                }
                else {
                    footerHeight = CGFloat.min
                }
            }
            
            if(section == 9){
                if(!self.withc1.on){
                    footerHeight = CGFloat.min
                }else{
                    if(self.withc2.on){
                        footerHeight = tableView.sectionFooterHeight
                    }
                    else {
                        footerHeight = CGFloat.min
                    }
                }
            }
            
            if(section == 10){
                footerHeight = tableView.sectionFooterHeight
            }
            
            if(section == 11){
                footerHeight = tableView.sectionFooterHeight
            }
            
            if(section == 12){
                footerHeight = tableView.sectionFooterHeight
            }
        }

        return footerHeight
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionHeader = ""
        
        if(vcAction == "ShowApplyCard" || vcAction == "ApplyCreditCard"){
            if(section == 0){
                sectionHeader = "New Credit Card Application"
            }
            else if(section == 1){
                sectionHeader = "Personal Information"
            }
            else if(section == 2){
                sectionHeader = "Present Address"
            }
            else if(section == 3){
                sectionHeader = "Permanent Address"
            }
            else if(section == 4){
                sectionHeader = "Financial Information"
            }
            else if(section == 5){
                sectionHeader = "Credit Card Information"
            }
            else if(section == 6){
                sectionHeader = "Additional Supplementary"
            }
            else if(section == 7){
                if(self.withc1.on){
                    sectionHeader = "Supplementary 1 Information"
                }
                else {
                    sectionHeader = ""
                }
            }
            else if(section == 8){
                if(self.withc1.on){
                    sectionHeader = "Additional Supplementary"
                }
                else {
                    sectionHeader = ""
                }
            }
            else if(section == 9){
                if(!self.withc1.on){
                    sectionHeader = ""
                }else{
                    if(self.withc2.on){
                        sectionHeader = "Supplementary 2 Information"
                    }
                    else {
                        sectionHeader = ""
                    }
                }
            }
            else if(section == 10){
                sectionHeader = "Other Instructions"
            }
            else if(section == 11){
                sectionHeader = "Upload Requirements"
            }
            else if(section == 12){
                sectionHeader = ""
            }
        }
        
        return sectionHeader
    }
    
    
    @IBAction func toggleWithC1(sender: AnyObject) {
        if(self.withc1.on == true){
            c1lastname.enabled = true
            c1firstname.enabled = true
            c1middlename.enabled = true
            c1birthday.userInteractionEnabled = true
            //c1civilstatus.userInteractionEnabled = true
            //c1gender.enabled = true
            //c1phonenumber.enabled = true
            //c1mobilenumber.enabled = true
            //c1address1.enabled = true
            //c1address2.enabled = true

            withc2.enabled = true
            
        }else{
            c1lastname.enabled = false
            c1firstname.enabled = false
            c1middlename.enabled = false
            c1birthday.userInteractionEnabled = false
            //c1civilstatus.userInteractionEnabled = false
            //c1gender.enabled = false
            //c1phonenumber.enabled = false
            //c1mobilenumber.enabled = false
            //c1address1.enabled = false
            //c1address2.enabled = false
            
            withc2.enabled = false
            
            withc2.on = false
            c2lastname.enabled = false
            c2firstname.enabled = false
            c2middlename.enabled = false
            c2birthday.userInteractionEnabled = false
            //c2civilstatus.userInteractionEnabled = false
            //c2gender.enabled = false
            //c2phonenumber.enabled = false
            //c2mobilenumber.enabled = false
            //c2address1.enabled = false
            //c2address2.enabled = false
        }
        
        creditCardApplicationTable.reloadData()
    }
    
    @IBAction func toggleWithC2(sender: AnyObject) {
        if(self.withc2.on == true){
            c2lastname.enabled = true
            c2firstname.enabled = true
            c2middlename.enabled = true
            //c2gender.enabled = true
            //c2phonenumber.enabled = true
            //c2mobilenumber.enabled = true
            //c2address1.enabled = true
            //c2address2.enabled = true
        }else{
            c2lastname.enabled = false
            c2firstname.enabled = false
            c2middlename.enabled = false
            //c2gender.enabled = false
            //c2phonenumber.enabled = false
            //c2mobilenumber.enabled = false
            //c2address1.enabled = false
            //c2address2.enabled = false
        }
        
        creditCardApplicationTable.reloadData()
    }
    
    @IBOutlet var image1: UIImageView!
    @IBOutlet weak var filename1: UILabel!
    @IBOutlet weak var filedetails1: UILabel!
    @IBOutlet weak var btnAddImage1: UIButton!
    @IBOutlet weak var btnDeleteImage1: UIButton!
    
    @IBOutlet var image2: UIImageView!
    @IBOutlet weak var filename2: UILabel!
    @IBOutlet weak var filedetails2: UILabel!
    @IBOutlet weak var btnAddImage2: UIButton!
    @IBOutlet weak var btnDeleteImage2: UIButton!
    
    @IBOutlet var image3: UIImageView!
    @IBOutlet weak var filename3: UILabel!
    @IBOutlet weak var filedetails3: UILabel!
    @IBOutlet weak var btnAddImage3: UIButton!
    @IBOutlet weak var btnDeleteImage3: UIButton!
    
    @IBAction func btnAddImage1(sender: AnyObject) {
        defaults.setObject("image1", forKey: "selectedImage")
        
        let alert = UIAlertController(title: "Upload Photo", message: "Choose", preferredStyle: .ActionSheet)
        let action = UIAlertAction(title: "Take Photo", style: .Default, handler: { (alert) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            self.defaults.setObject("takePhoto", forKey: "selectedSourceOfImage")
        })
        alert.addAction(action)
        let action2 = UIAlertAction(title: "Choose from Camera Roll", style: .Default, handler: { (alert) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            self.defaults.setObject("cameraRoll", forKey: "selectedSourceOfImage")
        })
        alert.addAction(action2)
        let action3 = UIAlertAction(title: "Cancel", style: .Default, handler: { (alert) -> Void in
            self.defaults.setObject("", forKey: "selectedSourceOfImage")
        })
        alert.addAction(action3)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnAddImage2(sender: AnyObject) {
        defaults.setObject("image2", forKey: "selectedImage")
        
        let alert = UIAlertController(title: "Upload Photo", message: "Choose", preferredStyle: .ActionSheet)
        let action = UIAlertAction(title: "Take Photo", style: .Default, handler: { (alert) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            self.defaults.setObject("takePhoto", forKey: "selectedSourceOfImage")
        })
        alert.addAction(action)
        let action2 = UIAlertAction(title: "Choose from Camera Roll", style: .Default, handler: { (alert) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            self.defaults.setObject("cameraRoll", forKey: "selectedSourceOfImage")
        })
        alert.addAction(action2)
        let action3 = UIAlertAction(title: "Cancel", style: .Default, handler: { (alert) -> Void in
            self.defaults.setObject("", forKey: "selectedSourceOfImage")
        })
        alert.addAction(action3)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnAddImage3(sender: AnyObject) {
        defaults.setObject("image3", forKey: "selectedImage")
        
        let alert = UIAlertController(title: "Upload Photo", message: "Choose", preferredStyle: .ActionSheet)
        let action = UIAlertAction(title: "Take Photo", style: .Default, handler: { (alert) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            self.defaults.setObject("takePhoto", forKey: "selectedSourceOfImage")
        })
        alert.addAction(action)
        let action2 = UIAlertAction(title: "Choose from Camera Roll", style: .Default, handler: { (alert) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            self.defaults.setObject("cameraRoll", forKey: "selectedSourceOfImage")
        })
        alert.addAction(action2)
        let action3 = UIAlertAction(title: "Cancel", style: .Default, handler: { (alert) -> Void in
            self.defaults.setObject("", forKey: "selectedSourceOfImage")
        })
        alert.addAction(action3)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteImage1(sender: AnyObject) {
        btnAddImage1.enabled = true
        btnAddImage1.hidden = false
        image1.hidden = true
        btnDeleteImage1.hidden = true
        
        defaults.setObject("", forKey: "selectedImage")
    }
    
    @IBAction func btnDeleteImage2(sender: AnyObject) {
        btnAddImage2.enabled = true
        btnAddImage2.hidden = false
        image2.hidden = true
        btnDeleteImage2.hidden = true
        
        defaults.setObject("", forKey: "selectedImage")
    }
    
    @IBAction func btnDeleteImage3(sender: AnyObject) {
        btnAddImage3.enabled = true
        btnAddImage3.hidden = false
        image3.hidden = true
        btnDeleteImage3.hidden = true
        
        defaults.setObject("", forKey: "selectedImage")
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        if let sourceOfImage = defaults.stringForKey("selectedSourceOfImage") {
            selectedSourceOfImage = sourceOfImage
        }

        if let imageNum = defaults.stringForKey("selectedImage") {
            selectedImage = imageNum
        }
        
        if(selectedImage == "image1"){
            image1.image = image
            btnAddImage1.enabled = false
            btnAddImage1.hidden = true
            image1.hidden = false
            btnDeleteImage1.hidden = false
            
        }else if(selectedImage == "image2"){
            image2.image = image
            btnAddImage2.enabled = false
            btnAddImage2.hidden = true
            image2.hidden = false
            btnDeleteImage2.hidden = false
        }else if(selectedImage == "image3"){
            image3.image = image
            btnAddImage3.enabled = false
            btnAddImage3.hidden = true
            image3.hidden = false
            btnDeleteImage3.hidden = false
        }
        
        NSLog("selectedSourceOfImage: " + selectedSourceOfImage)
        if(selectedSourceOfImage == "cameraRoll"){
            let imageURL = editingInfo[UIImagePickerControllerReferenceURL] as! NSURL
            let imagePath =  imageURL.path!
            
            NSLog("IMAGEURL" + String(imageURL))
            if(selectedImage == "image1"){
                if let data = UIImageJPEGRepresentation((self.image1?.image)!, 1) {
                    let tempDirectoryURL = NSURL.fileURLWithPath(NSTemporaryDirectory(), isDirectory: true)
                    let targetURL1 = tempDirectoryURL.URLByAppendingPathComponent("image1").URLByAppendingPathExtension("JPG").path!
                    print("TARGET: \(targetURL1)")
                    uploadedPhotosDets["image1"] = targetURL1
                    data.writeToFile(targetURL1, atomically: true)
                }
                NSLog("imagePath: " + imagePath)
            }else if(selectedImage == "image2"){
                if let data = UIImageJPEGRepresentation((self.image2?.image)!, 1) {
                    let tempDirectoryURL = NSURL.fileURLWithPath(NSTemporaryDirectory(), isDirectory: true)
                    let targetURL2 = tempDirectoryURL.URLByAppendingPathComponent("image2").URLByAppendingPathExtension("JPG").path!
                    print("TARGET: \(targetURL2)")
                    uploadedPhotosDets["image2"] = targetURL2
                    data.writeToFile(targetURL2, atomically: true)
                }
                NSLog("imagePath: " + imagePath)
            }else if(selectedImage == "image3"){
                if let data = UIImageJPEGRepresentation((self.image3?.image)!, 1) {
                    let tempDirectoryURL = NSURL.fileURLWithPath(NSTemporaryDirectory(), isDirectory: true)
                    let targetURL3 = tempDirectoryURL.URLByAppendingPathComponent("image3").URLByAppendingPathExtension("JPG").path!
                    print("TARGET: \(targetURL3)")
                    uploadedPhotosDets["image3"] = targetURL3
                    data.writeToFile(targetURL3, atomically: true)
                }
                NSLog("imagePath: " + imagePath)
            }
        }
        else if(selectedSourceOfImage == "takePhoto"){
            
            let alert = UIAlertController(title: "Do you want to save the picture", message: nil, preferredStyle: .Alert)
            let okButton = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default){
                UIAlertAction in
                NSLog("ok pressed")
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive)
            {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            alert.addAction(okButton)
            alert.addAction(cancelButton)
            presentViewController(alert, animated: true, completion: nil)
            
            if(selectedImage == "image1"){
                if let imageData1 = UIImageJPEGRepresentation((self.image1?.image)!, 1) {
                    let tempDirectoryURL = NSURL.fileURLWithPath(NSTemporaryDirectory(), isDirectory: true)
                    targetURL1 = tempDirectoryURL.URLByAppendingPathComponent("image1").URLByAppendingPathExtension("JPG").path!
                    print("TARGET: \(targetURL1)")
                    uploadedPhotosDets["image1"] = targetURL1
                    imageData1.writeToFile(targetURL1, atomically: true)
                }
            }else if(selectedImage == "image2"){
                if let imageData2 = UIImageJPEGRepresentation((self.image2?.image)!, 1) {
                    let tempDirectoryURL = NSURL.fileURLWithPath(NSTemporaryDirectory(), isDirectory: true)
                    targetURL2 = tempDirectoryURL.URLByAppendingPathComponent("image2").URLByAppendingPathExtension("JPG").path!
                    print("TARGET: \(targetURL2)")
                    uploadedPhotosDets["image2"] = targetURL2
                    imageData2.writeToFile(targetURL2, atomically: true)
                }
            }else if(selectedImage == "image3"){
                if let imageData3 = UIImageJPEGRepresentation((self.image3?.image)!, 1) {
                    let tempDirectoryURL = NSURL.fileURLWithPath(NSTemporaryDirectory(), isDirectory: true)
                    targetURL3 = tempDirectoryURL.URLByAppendingPathComponent("image3").URLByAppendingPathExtension("JPG").path!
                    print("TARGET: \(targetURL3)")
                    uploadedPhotosDets["image3"] = targetURL3
                    imageData3.writeToFile(targetURL3, atomically: true)
                }
            }
        }
        
        NSLog("uploadedPhotosDets: " + String(uploadedPhotosDets))
        
        for (key, value) in uploadedPhotosDets {
            if(key == "image1") {
                self.defaults.setObject(value, forKey: "imagePath_1")
            }else if(key == "image2") {
                self.defaults.setObject(value, forKey: "imagePath_2")
            }else if(key == "image3") {
                self.defaults.setObject(value, forKey: "imagePath_3")
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let sourceOfImage = defaults.stringForKey("selectedSourceOfImage") {
            selectedSourceOfImage = sourceOfImage
        }
        
        if let imageNum = defaults.stringForKey("selectedImage") {
            selectedImage = imageNum
        }
        
        if(selectedSourceOfImage == "takePhoto"){
            let alert = UIAlertController(title: "Do you want to save the picture", message: nil, preferredStyle: .Alert)
            let okButton = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default){
                UIAlertAction in
                NSLog("ok pressed")

                if(self.selectedImage == "image1"){
                    let imageData1 = UIImageJPEGRepresentation((self.image1?.image)!, 0.6)
                    let compressedJPGImage1 = UIImage(data: imageData1!)
                    UIImageWriteToSavedPhotosAlbum(compressedJPGImage1!, nil, nil, nil)
                }else if(self.selectedImage == "image2"){
                    let imageData2 = UIImageJPEGRepresentation((self.image2?.image)!, 0.6)
                    let compressedJPGImage2 = UIImage(data: imageData2!)
                    UIImageWriteToSavedPhotosAlbum(compressedJPGImage2!, nil, nil, nil)
                }else if(self.selectedImage == "image3"){
                    let imageData3 = UIImageJPEGRepresentation((self.image3?.image)!, 0.6)
                    let compressedJPGImage3 = UIImage(data: imageData3!)
                    UIImageWriteToSavedPhotosAlbum(compressedJPGImage3!, nil, nil, nil)
                }
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive)
            {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            alert.addAction(okButton)
            alert.addAction(cancelButton)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /*
    var url = "http://andreid.imcserver.ro/test/service.php"
    var nsURL = NSURL(string: url)
    var request = NSURLRequest(URL: nsURL!)
    var data: NSData
    var response: NSURLResponse?
    var error: NSErrorPointer?
     
    var jsonTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
        (data, response, error) -> Void in
     
        println("\(data)")
        println("\(response)")
        println("\(error)")
     
        if error == nil
        {
            var jsonError: NSError?
            var jsonResponse: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &jsonError) as! NSDictionary
            println("\(jsonResponse)")
        }
        else
        {
            println("JSON PARse error")
        }
    })
    jsonTask.resume()
    */
    
    
    ////UPLOAD TASK////
    func imageUploadRequest(imageView imageView: UIImageView) {
        
        if let appID = defaults.stringForKey("submittedApplicationID") {
            submittedApplicationID = appID
        }
        
        urlIMG = NSLocalizedString("urlCATS_IMAGE", comment: "")
        let urlAsString = urlIMG.stringByReplacingOccurrencesOfString("@@ID", withString: submittedApplicationID)
        let uploadUrl = NSURL(string: urlAsString)
        let request = NSMutableURLRequest(URL:uploadUrl!);
        request.HTTPMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
        
        let filename = String(imageView) + ".JPG"
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters("uploaded_file", imageDataKey: imageData!, boundary: boundary, filename: filename)
        
        let task =  NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            if let data = data {
                
                // You can print out response object
                print("******* response = \(response)")
                
                print(data.length)
                //you can use data here
                
                // Print out reponse body
                let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                print("****** response data = \(responseString!)")
                
                //let json = try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
                let json = try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
                
                print("json value \(json)")
                
                //var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err)
                
                dispatch_async(dispatch_get_main_queue(),{
                    //self.myActivityIndicator.stopAnimating()
                    //self.imageView.image = nil;
                });
            } else if let error = error {
                print(error.description)
            }
        })
        task.resume()
    }
    
    func createBodyWithParameters(filePathKey: String?, imageDataKey: NSData, boundary: String, filename: String) -> NSData {
        let body = NSMutableData();
        /*
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        */
        
        NSLog("FILENAME: " + filename)
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    ///////////////////
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowCardNetworkList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowCardNetworkList"
            }
        }
        
        if segue.identifier == "ShowAutoFAQ"
        {
            if let destinationVC = segue.destinationViewController as? FAQViewController{
                destinationVC.vcAction = "ShowAutoFAQ"
            }
        }
        
        if segue.identifier == "ShowBDayDatePicker"
        {
            if let destinationVC = segue.destinationViewController as? DateTableViewController{
                destinationVC.vcAction = "ShowBDayDatePicker"
            }
        }
        
        if segue.identifier == "ShowIncomeType"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowIncomeType"
            }
        }
        
        if segue.identifier == "ShowBankList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowBankList"
            }
        }
        
        if segue.identifier == "ShowOccupationList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowOccupationList"
            }
        }
        
        if segue.identifier == "ShowOccupationGroupList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowOccupationGroupList"
            }
        }
        
        if segue.identifier == "ShowSPIncomeType"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowSPIncomeType"
            }
        }
        
        
        if segue.identifier == "ShowCivilStatusList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowCivilStatusList"
            }
        }
        
        if segue.identifier == "ShowSalutationList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowSalutationList"
            }
        }
        
        if segue.identifier == "ShowC1SalutationList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowC1SalutationList"
            }
        }
        
        if segue.identifier == "ShowC2SalutationList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowC2SalutationList"
            }
        }
        
        if segue.identifier == "ShowProvinceList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowProvinceList"
            }
        }
        
        if segue.identifier == "ShowBizProvinceList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowBizProvinceList"
            }
        }
        
        if segue.identifier == "ShowProvinceList_present"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowProvinceList_present"
            }
        }
        
        if segue.identifier == "ShowProvinceList_permanent"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowProvinceList_permanent"
            }
        }
        
        if segue.identifier == "ShowCityList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowCityList"
            }
        }
        
        if segue.identifier == "ShowCityList_present"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowCityList_present"
            }
        }
        
        if segue.identifier == "ShowCityList_permanent"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowCityList_permanent"
            }
        }
        
        if segue.identifier == "ShowBizCityList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowBizCityList"
            }
        }
        
        if segue.identifier == "ShowIndustryList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowIndustryList"
            }
        }
        
        if segue.identifier == "ShowIncomeType"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowIncomeType"
            }
        }
        
        if segue.identifier == "ShowHomeOwnershipList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowHomeOwnershipList"
            }
        }
        
        if segue.identifier == "ShowSourceOfFundList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowSourceOfFundList"
            }
        }
        
        if segue.identifier == "ShowBDayDatePicker"
        {
            if let destinationVC = segue.destinationViewController as? DateTableViewController{
                destinationVC.vcAction = "ShowBDayDatePicker"
            }
        }
        
        if segue.identifier == "ShowBillingAddressOption"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowBillingAddressOption"
            }
        }
        
        if segue.identifier == "ShowDeliveryAddressOption"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowDeliveryAddressOption"
            }
        }
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
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}