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
    //HELLO
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
    
    
    
    @IBOutlet var bdaydatePicker: UIDatePicker!
    @IBOutlet var bday: UILabel!
    
    
    @IBOutlet var city: UILabel!
    @IBOutlet var C2salutation: UILabel!
    @IBOutlet var salutation: UILabel!
    @IBOutlet var civilstatus: UILabel!
    @IBOutlet var C1salutation: UILabel!
    @IBOutlet var province: UILabel!
    @IBOutlet var incometype: UILabel!
    @IBOutlet var occupation: UILabel!
    @IBOutlet var occupationgroup: UILabel!
    @IBOutlet var cityBiz: UILabel!
    @IBOutlet var provincebiz: UILabel!
    @IBOutlet var industry: UILabel!
    @IBOutlet var bank: UILabel!
    
    
    @IBOutlet var toggleCard: UISwitch!
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 280
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
         */
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AutoTableViewController.DismissKeyboard))
        view.addGestureRecognizer(dismiss)
        dismiss.cancelsTouchesInView = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AutoTableViewController.keyboardWasShown(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AutoTableViewController.keyboardWasNotShown(_:)), name:UIKeyboardWillHideNotification, object: nil);

        datePickerChangedCard()
        
        
    }
    
    
    @IBOutlet var cityCell: UITableViewCell!
    @IBOutlet var provinceCell: UITableViewCell!
    @IBOutlet var C1salutationCell: UITableViewCell!
    @IBOutlet var salutationCell: UITableViewCell!
    @IBOutlet var civilStatusCell: UITableViewCell!
    @IBOutlet var C2salutationCell: UITableViewCell!
    @IBOutlet var incomeTypeCell: UITableViewCell!
    @IBOutlet var occupationCell: UITableViewCell!
    @IBOutlet var industryCell: UITableViewCell!
    @IBOutlet var occupationGroupCell: UITableViewCell!
    @IBOutlet var provinceBizCell: UITableViewCell!
    @IBOutlet var cityBizCell: UITableViewCell!
    
    @IBOutlet var bankCell: UITableViewCell!
    
    
    @IBAction func datePickerChangedCard() {
        if(vcAction == "ShowApplyCard")
        {
            bday.text = NSDateFormatter.localizedStringFromDate(bdaydatePicker.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        }
    }
    
    
    
    @IBAction func bdaydatePickerValue(sender: UIDatePicker) {
        
         datePickerChangedCard()
    }
    
    
    @IBAction func toggleSwitchCard(sender: UISwitch) {
        if(self.toggleCard.on == true) {
            bank.enabled = true
            
        }else{
            bank.enabled = false
            
        }
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
    
    func toggleDatepicker() {
        bdaydatePickerHidden = !bdaydatePickerHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
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
    }
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
        
        /*
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
 */
        
        
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
                /*
                if(self.withc1.on){
                    footerHeight = tableView.sectionFooterHeight
                }
                else {
                    footerHeight = CGFloat.min
                }
 */
            }
            
            if(section == 4){
                /*
                if(self.withc1.on){
                    footerHeight = tableView.sectionFooterHeight
                }
                else {
                    footerHeight = CGFloat.min
                }
 */
            }
            
            if(section == 5){
                /*
                if(self.withc2.on){
                    footerHeight = tableView.sectionFooterHeight
                }
                else {
                    footerHeight = CGFloat.min
                }
 */
                
            }
            
            if(section == 6){
                footerHeight = tableView.sectionFooterHeight
            }
            
            if(section == 7){
                footerHeight = tableView.sectionFooterHeight
            }
        }
 */
        
        return footerHeight
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionHeader = ""
        
        if(vcAction == "ShowApplyCard"){
            if(section == 0){
                sectionHeader = "Personal Information"
            }
        }
        
        /*
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
 */
        
        
        return sectionHeader
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(vcAction == "ApplyLoanDirect" || vcAction == "ShowComputedAutoApp")
        {
            if indexPath.section == 0 && indexPath.row == 10 {
                toggleDatepicker()
            }
            
            if indexPath.section == 1 && indexPath.row == 3 {
                //spousebdaytoggleDatepicker()
            }
            
            if indexPath.section == 3 && indexPath.row == 3 {
                //c1bdaytoggleDatepicker()
            }
            
            if indexPath.section == 5 && indexPath.row == 3 {
                //c2bdaytoggleDatepicker()
            }
        }
    }
    
/*
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(vcAction == "ShowApplyCard")
        {
            if bdaydatePickerHidden && indexPath.section == 0 && indexPath.row == 11 {
                return 0
            }
            
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
*/
    
    
    
}