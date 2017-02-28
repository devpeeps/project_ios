//
//  DateTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 05/12/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit

class DateTableViewController: UITableViewController {
    
    var vcAction = ""
    
    @IBOutlet var datePicker:UIDatePicker!
    @IBOutlet var detailLabel:UILabel!
    @IBOutlet var lbldate: UILabel!
    
    let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerChanged()
        
        if(vcAction == "ShowBDayDatePicker"){
            lbldate.text = "Birthday"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func datePickerChanged() {
        detailLabel.text = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            toggleDatepicker()
        }
    }
    
    var datePickerHidden = true

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if datePickerHidden && indexPath.section == 0 && indexPath.row == 1 {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    func toggleDatepicker() {
        
        datePickerHidden = !datePickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    @IBAction func datePickerValue(sender: UIDatePicker) {
        datePickerChanged()
    }
}