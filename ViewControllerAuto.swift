//
//  ViewControllerAuto.swift
//  elysium
//
//  Created by Joshua Eleazar Bosinos on 08/01/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit

class ViewControllerAuto: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
    var urlLib = ""
    var withConnection = false
    var carBrandArr = [("","")]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        urlLib = NSLocalizedString("urlLib", comment: "")
        
        loadCarBrandList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    func loadCarBrandList(){
        
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
                        let str = s!.componentsSeparatedByString("<br/>")
                        self.carBrandArr.removeAll()
                        for i in 0...str.count - 1{
                            self.carBrandArr.append((str[i], str[i]))
                        }
                        
                    }else{
                        
                    }
                    self.loadingIndicator.hidden = true
                    self.loadingIndicator.stopAnimating()
                }else{
                    self.loadingIndicator.hidden = true
                    self.loadingIndicator.stopAnimating()
                    let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                        exit(1)
                    })
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
            jsonQuery.resume()
        }else{
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            let alert = UIAlertController(title: "Connection Error", message: "There seems to be a problem with your network connection. Relaunch the app once you have a stable connection.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
                exit(1)
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 5
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return carBrandArr.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return carBrandArr[row].0
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

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
