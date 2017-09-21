//
//  MyApplicationTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 07/11/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit
import CoreData

class MainPageViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    
    var id = ""
    var name = ""
    var email = ""
    var autoInfo = ["","",""]
    var homeInfo = ["","",""]
    var ccInfo = ["","","",""]
    
    var urlLib = ""
    var vcAction = ""
    var withConnection = false
    var myAppArr = [("type","id","name","status","datesubmitted","datelastupdate")]
    
    var showRecent = false
    
    let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 68, height: 58))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "ubp_logo.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 280
            //menuButton.target = revealViewController()
            //menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

