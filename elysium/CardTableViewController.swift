//
//  CardTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 03/11/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit

class CardTableViewController: UITableViewController {
    @IBOutlet var menuButton: UIBarButtonItem!
    
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
    var selectedOccupation = ""
    var selectedOccupationGroup = ""
    var selectedIndustry = ""
    var selectedIndustryCode = ""
    var selectedBank = ""
    var selectedBankCode = ""
    
    var bdaydatePickerHidden = true
    var c1bdaydatePickerHidden = true
    var c2bdaydatePickerHidden = true
    
    @IBOutlet var creditCardApplicationTable: UITableView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AutoTableViewController.DismissKeyboard))
        view.addGestureRecognizer(dismiss)
        dismiss.cancelsTouchesInView = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AutoTableViewController.keyboardWasShown(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AutoTableViewController.keyboardWasNotShown(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        datePickerChanged()
        c1datePickerChanged()
        c2datePickerChanged()
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
        /*
        if let civilStatusLabel = defaults.stringForKey("selectedCivilStatus") {
            self.civilStatusCell.detailTextLabel?.text = civilStatusLabel
        }
        
        if let salutationLabel = defaults.stringForKey("selectedSalutation") {
            self.salutationCell.detailTextLabel?.text = salutationLabel
        }
        
        if let C1salutationLabel = defaults.stringForKey("selectedC1Salutation") {
            self.C1salutationCell.detailTextLabel?.text = C1salutationLabel
        }
        
        if let C2salutationLabel = defaults.stringForKey("selectedC2Salutation") {
            self.C2salutationCell.detailTextLabel?.text = C2salutationLabel
        }
        
        if let provinceLabel = defaults.stringForKey("selectedProvince") {
            self.provinceCell.detailTextLabel?.text = provinceLabel
        }
        
        if let provinceBizLabel = defaults.stringForKey("selectedProvinceBiz") {
            self.provinceBizCell.detailTextLabel?.text = provinceBizLabel
        }
        
        if let cityLabel = defaults.stringForKey("selectedCity") {
            self.cityCell.detailTextLabel?.text = cityLabel
        }
        
        if let cityBizLabel = defaults.stringForKey("selectedCityBiz") {
            self.cityBizCell.detailTextLabel?.text = cityBizLabel
        }
        
        if let incomeLabel = defaults.stringForKey("selectedIncomeType") {
            self.incomeTypeCell.detailTextLabel?.text = incomeLabel
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
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    
    
    @IBOutlet var C1salutationCell: UITableViewCell!
    
    
    @IBOutlet var C2salutationCell: UITableViewCell!
    
    
    
    
    
    @IBOutlet var bankCell: UITableViewCell!
    
    @IBOutlet var incometype: UILabel!
    @IBOutlet var occupation: UILabel!
    @IBOutlet var occupationgroup: UILabel!
    @IBOutlet var cityBiz: UILabel!
    @IBOutlet var provincebiz: UILabel!
    @IBOutlet var industry: UILabel!
    @IBOutlet var bank: UILabel!
    
    @IBOutlet var toggleCard: UISwitch!
    */
    
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
    @IBOutlet var provinceBizCell: UITableViewCell!
    @IBOutlet var cityBizCell: UITableViewCell!
    @IBOutlet var empsourcefundsCell: UITableViewCell!
    
    @IBOutlet var salutation: UILabel!
    @IBOutlet var lastname: UITextField!
    @IBOutlet var firstname: UITextField!
    @IBOutlet var middlename: UITextField!
    
    @IBOutlet var birthday: UILabel!
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
    /*@IBOutlet var c1phonenumber: UITextField!
    @IBOutlet var c1mobilenumber: UITextField!
    @IBOutlet var c1address1: UITextField!
    @IBOutlet var c1address2: UITextField!
    */
    @IBOutlet var withc2: UISwitch!
    
    @IBOutlet var c2salutation: UILabel!
    @IBOutlet var c2lastname: UITextField!
    @IBOutlet var c2firstname: UITextField!
    @IBOutlet var c2middlename: UITextField!
    @IBOutlet var c2birthday: UILabel!
    /*@IBOutlet var c2phonenumber: UITextField!
    @IBOutlet var c2mobilenumber: UITextField!
    @IBOutlet var c2address1: UITextField!
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
        if(vcAction == "ShowApplyCard")
        {
            bdaydetailLabel.text = NSDateFormatter.localizedStringFromDate(bdaydatePicker.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        }
    }
    
    @IBAction func c1datePickerChanged() {
        if(vcAction == "ShowApplyCard")
        {
            c1bdaydetailLabel.text = NSDateFormatter.localizedStringFromDate(c1bdaydatePicker.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        }
    }
    
    @IBAction func c2datePickerChanged() {
        if(vcAction == "ShowApplyCard")
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(vcAction == "ShowApplyCard")
        {
            if indexPath.section == 0 && indexPath.row == 8 {
                toggleDatepicker()
            }
            
            if indexPath.section == 6 && indexPath.row == 4 {
                c1bdaytoggleDatepicker()
            }
            
            if indexPath.section == 8 && indexPath.row == 4 {
                c2bdaytoggleDatepicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(vcAction == "ShowApplyCard")
        {
            if bdaydatePickerHidden && indexPath.section == 0 && indexPath.row == 9 {
                return 0
            }
            else if c1bdaydatePickerHidden && indexPath.section == 6 && indexPath.row == 5 {
                return 0
            }
            else if c2bdaydatePickerHidden && indexPath.section == 8 && indexPath.row == 5 {
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
        
        if(vcAction == "ShowApplyCard" ){
            if(section == 0){
                itemCount = 14
            }
            else if(section == 1){
                itemCount = 5
            }
            else if(section == 2){
                itemCount = 8
            }
            else if(section == 3){
                itemCount = 17
            }
            else if(section == 4){
                itemCount = 3
            }
            else if(section == 5){
                itemCount = 1
            }
            else if(section == 6 || section == 7 || section == 8){
                if(section == 6){
                    if(self.withc1.on){
                        itemCount = 18
                    }
                    else {
                        itemCount = 0
                    }
                }
                
                if(section == 7){
                    if(self.withc1.on){
                        itemCount = 1
                    }
                    else {
                        itemCount = 0
                    }
                }
                
                if(section == 8){
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
            else if(section == 9){
                itemCount = 2
            }
            else if(section == 10){
                itemCount = 1
            }
        }
        return itemCount
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerHeight: CGFloat = 0
        
        if(vcAction == "ShowApplyCard"){
            
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
                if(self.withc1.on){
                    headerHeight = tableView.sectionHeaderHeight
                }
                else {
                    headerHeight = CGFloat.min
                }
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
            
            if(section == 9){
                headerHeight = tableView.sectionHeaderHeight
            }
            
            if(section == 10){
                headerHeight = tableView.sectionHeaderHeight
            }
        }
        
        return headerHeight
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var footerHeight: CGFloat = 0
        
        if(vcAction == "ShowApplyCard"){
            
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
                if(self.withc1.on){
                    footerHeight = tableView.sectionFooterHeight
                }
                else {
                    footerHeight = CGFloat.min
                }
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
            
            if(section == 9){
                footerHeight = tableView.sectionFooterHeight
            }
            
            if(section == 10){
                footerHeight = tableView.sectionFooterHeight
            }
        }

        return footerHeight
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionHeader = ""
        
        if(vcAction == "ShowApplyCard"){
            if(section == 0){
                sectionHeader = "Personal Information"
            }
            else if(section == 1){
                sectionHeader = "Present Address"
            }
            else if(section == 2){
                sectionHeader = "Permanent Address"
            }
            else if(section == 3){
                sectionHeader = "Financial Information"
            }
            else if(section == 4){
                sectionHeader = "Credit Card Information"
            }
            else if(section == 5){
                sectionHeader = "Additional Supplementary"
            }
            else if(section == 6){
                if(self.withc1.on){
                    sectionHeader = "Supplementary 1 Information"
                }
                else {
                    sectionHeader = ""
                }
            }
            else if(section == 7){
                if(self.withc1.on){
                    sectionHeader = "Additional Supplementary"
                }
                else {
                    sectionHeader = ""
                }
            }
            else if(section == 8){
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
            else if(section == 9){
                sectionHeader = "Other Instructions"
            }
            else if(section == 10){
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
    
    /*
    @IBAction func toggleSwitchCard(sender: UISwitch) {
        if(self.toggleCard.on == true) {
            bank.enabled = true
            
        }else{
            bank.enabled = false
            
        }
    }
    */
    
    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var itemCount = 0
        
        if(vcAction == "ShowApplyCard" ){
            if(section == 0){
                itemCount = 20
            } else if(section == 1){
                if(self.civilstatus.text == "Married"){
                    itemCount = 18
                }else{
                    itemCount = 0
                }
            } else if(section == 2){
                itemCount = 1
            } else if(section == 3 || section == 4 || section == 5){
                /*
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
                 */
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
        
        if(vcAction == "ShowApplyCard" ){
            if(section == 0){
                headerHeight = tableView.sectionHeaderHeight
            }
        }
        

        if(vcAction == "ApplyLoanDirect" || vcAction == "ShowComputedAutoApp"){
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
                //if(self.withc1.on){
                //    headerHeight = tableView.sectionHeaderHeight
                //}
                //else {
                //headerHeight = CGFloat.min
                //}
            }
            
            if(section == 4){
                //if(self.withc1.on){
                 //   headerHeight = tableView.sectionHeaderHeight
                //}
                //else {
                //    headerHeight = CGFloat.min
                //}
            }
            
            if(section == 5){
                //if(!self.withc1.on){
                 //   headerHeight = CGFloat.min
                //}else{
                 //   if(self.withc2.on){
                        headerHeight = tableView.sectionHeaderHeight
                 //   }
                  //  else {
                        headerHeight = CGFloat.min
                   // }
                //}
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
        
        if(vcAction == "ShowApplyCard"){
            if(section == 0){
                footerHeight = tableView.sectionFooterHeight
            }
        }
        
        /*
        if(vcAction == "ApplyLoanDirect" || vcAction == "ShowComputedAutoApp"){
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
    */
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionHeader = ""
        
        if(vcAction == "ShowApplyCard"){
            if(section == 0){
                sectionHeader = "Personal Information"
            }
            else if(section == 1){
                sectionHeader = "Present Address"
            }
            else if(section == 2){
                sectionHeader = "Permanent Address"
            }
            else if(section == 3){
                sectionHeader = "Financial Information"
            }
            else if(section == 4){
                sectionHeader = "Credit Card Information"
            }
            else if(section == 5){
                sectionHeader = "Additional Supplementary"
            }
            else if(section == 6){
                sectionHeader = "Supplementary 1 Information"
            }
            else if(section == 7){
                sectionHeader = "Additional Supplementary"
            }
            else if(section == 8){
                sectionHeader = "Supplementary 2 Information"
            }
            else if(section == 9){
                sectionHeader = "Other Instructions"
            }
            else if(section == 10){
                sectionHeader = ""
            }
        }
        
        if(vcAction == "ApplyLoanDirect" || vcAction == "ShowComputedAutoApp"){
            if(section == 0){
                var promoLabel = ""
                
                sectionHeader = "New Auto Laon Application"
                
                if let promoStatusLabel = defaults.stringForKey("promoStatus") {
                    promoStatus = promoStatusLabel
                }
                
                if(promoStatus == "OptIn"){
                    promoLabel = "\n(You are currently subscribed to FREE GAS Promo)"
                    sectionHeader += promoLabel
                }
                
            } else if(section == 1){
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
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
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
        
        if segue.identifier == "ShowCityList"
        {
            if let destinationVC = segue.destinationViewController as? DropdownTableViewController{
                destinationVC.vcAction = "ShowCityList"
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
        
        if segue.identifier == "ShowBDayDatePicker"
        {
            if let destinationVC = segue.destinationViewController as? DateTableViewController{
                destinationVC.vcAction = "ShowBDayDatePicker"
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