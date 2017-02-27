//
//  ViewControllerTerms.swift
//  elysium
//
//  Created by erick apostol on 29/07/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit

class ViewControllerTerms: UIViewController {

    
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let str = NSLocalizedString("salary_terms", comment: "").html2String
        
        let attributedString = NSAttributedString(string: str)
        textTermsCondition.attributedText = attributedString
        
        let appver = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        labelAppVersion.text = appver
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var labelTitleTerms: UILabel!

    @IBOutlet var labelAppVersion: UILabel!
    @IBOutlet var buttonLogout: UIButton!
    
    @IBOutlet var textTermsCondition: UITextView!
    @IBAction func backToMain(sender: AnyObject) {
        
        if(self.id == "NON" || self.id == ""){
            self.performSegueWithIdentifier("BackToMain", sender: self)
        }else{
            self.performSegueWithIdentifier("BackToMainLogged", sender: self)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    var html2String:String {
        return try! NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil).string
    }
}
