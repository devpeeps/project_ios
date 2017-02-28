//
//  AboutTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 08/11/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var labelAppVersion: UILabel!
    @IBOutlet var textAbout: UITextView!
    
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sample code
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 280
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let str = NSLocalizedString("about_text", comment: "").html2String
        
        let attributedString = NSAttributedString(string: str)
        textAbout.attributedText = attributedString
        
        let appver = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        labelAppVersion.text = appver
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
