//
//  DateTableViewController.swift
//  elysium
//
//  Created by TMS-ADS on 05/12/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit

class DateTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var vcAction = ""
    var urlIMG = ""
    var selectedImage = ""
    var selectedSourceOfImage = ""
    
    var imagePath_1 = ""
    var imagePath_2 = ""
    var imagePath_3 = ""
    
    var submittedApplicationID = ""
    
    var targetURL1 = ""
    var targetURL2 = ""
    var targetURL3 = ""
    
    var filename = ""
    
    var uploadedPhotosDets = [String: String]()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet var creditCardApplicationTable: UITableView!
    
    //@IBOutlet var datePicker:UIDatePicker!
    //@IBOutlet var detailLabel:UILabel!
    //@IBOutlet var lbldate: UILabel!
    
    let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //datePickerChanged()
        /*
        if(vcAction == "ShowBDayDatePicker"){
            lbldate.text = "Birthday"
        }
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    
    @IBAction func btnSubmitImage(sender: AnyObject) {
        
        //let mReqId = "1E3EF1AF-B28B-49A9-AC16-15571803A55A-1003-MOBILE-APP-6/7/17"
        //let mReqId = "510107D4-5798-4CEA-B762-591636A50D79-1005-MOBILE-APP-6/7/17"
        //let mReqId = "AF68B257-492D-4AE4-B566-352A0C1C2F5B-1003-MOBILE-APP-6/7/17"
        //let mReqId = "D73EDF90-B752-4FFC-8050-F60A10E56B6F-1002-MOBILE-APP-6/7/17"
        let mReqId = "F8DDC87F-CCD8-428A-82D0-1A953A43C5A5-MOBILE-APP-03/30/2017"
        
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
        
        if let appID = defaults.stringForKey("submittedApplicationID") {
            submittedApplicationID = appID
        }
        
        uploadedPhotosDets = ["id": submittedApplicationID]
        NSLog("uploadedPhotosDets: " + String(uploadedPhotosDets))
        
        if(imagePath_1 != "") {
            urlIMG = NSLocalizedString("urlCREST_IMAGE", comment: "")
            let urlAsString = urlIMG.stringByReplacingOccurrencesOfString("@@REQID", withString: submittedApplicationID)
            let uploadUrl = NSURL(string: urlAsString)
            NSLog("NSURL: " + String(uploadUrl))
            let r = NSMutableURLRequest(URL:(uploadUrl)!);
            r.HTTPMethod = "POST"
            
            let boundary = "Boundary-\(NSUUID().UUIDString)"
            
            r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let imageData = UIImageJPEGRepresentation((self.image1?.image)!, 1)
            
            if(imageData==nil)  { return; }
            
            r.HTTPBody = createBody(uploadedPhotosDets, boundary: boundary, data: imageData!, mimeType: "multipart/form-data", filename: "image1.JPG")
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(r) {
                data, response, error in
                if error != nil {
                    print("error=\(error)")
                    return
                }
                print("******* response = \(response)")
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("****** response data = \(responseString!)")
                dispatch_async(dispatch_get_main_queue(),{
                    //CODE
                });
            }
            
            task.resume()
        }
        
        if(imagePath_2 != "") {
            urlIMG = NSLocalizedString("urlCREST_IMAGE", comment: "")
            let urlAsString = urlIMG.stringByReplacingOccurrencesOfString("@@REQID", withString: submittedApplicationID)
            let uploadUrl = NSURL(string: urlAsString)
            NSLog("NSURL: " + String(uploadUrl))
            let r = NSMutableURLRequest(URL:(uploadUrl)!);
            r.HTTPMethod = "POST"
            
            let boundary = "Boundary-\(NSUUID().UUIDString)"
            
            r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let imageData = UIImageJPEGRepresentation((self.image2?.image)!, 1)
            
            if(imageData==nil)  { return; }
            
            r.HTTPBody = createBody(uploadedPhotosDets, boundary: boundary, data: imageData!, mimeType: "multipart/form-data", filename: "image2.JPG")
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(r) {
                data, response, error in
                if error != nil {
                    print("error=\(error)")
                    return
                }
                print("******* response = \(response)")
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("****** response data = \(responseString!)")
                dispatch_async(dispatch_get_main_queue(),{
                    //CODE
                });
            }
            
            task.resume()
        }
        
        if(imagePath_3 != "") {
            urlIMG = NSLocalizedString("urlCREST_IMAGE", comment: "")
            let urlAsString = urlIMG.stringByReplacingOccurrencesOfString("@@REQID", withString: submittedApplicationID)
            let uploadUrl = NSURL(string: urlAsString)
            NSLog("NSURL: " + String(uploadUrl))
            let r = NSMutableURLRequest(URL:(uploadUrl)!);
            r.HTTPMethod = "POST"
            
            let boundary = "Boundary-\(NSUUID().UUIDString)"
            
            r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let imageData = UIImageJPEGRepresentation((self.image3?.image)!, 1)
            
            if(imageData==nil)  { return; }
            
            r.HTTPBody = createBody(uploadedPhotosDets, boundary: boundary, data: imageData!, mimeType: "multipart/form-data", filename: "image3.JPG")
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(r) {
                data, response, error in
                if error != nil {
                    print("error=\(error)")
                    return
                }
                print("******* response = \(response)")
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("****** response data = \(responseString!)")
                dispatch_async(dispatch_get_main_queue(),{
                    //CODE
                });
            }
            
            task.resume()
        }
        NSLog("MREQID: " + mReqId)
        
        let alert = UIAlertController(title: "UPLOADED", message: "SUCCESS", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert) -> Void in
            //self.performSegueWithIdentifier("BackToCardMain", sender: self)
        })
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
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
    
    func createBody(parameters: [String: String], boundary: String, data: NSData, mimeType: String, filename: String) -> NSData {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        NSLog("FILENAME: " + filename)
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"uploaded_file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.appendData(data)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        
        return body as NSData
    }
    
    /*
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
    */
}