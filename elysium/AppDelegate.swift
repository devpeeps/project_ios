//
//  AppDelegate.swift
//  elysium
//
//  Created by Joshua Eleazar Bosinos on 17/12/2015.
//  Copyright © 2015 UnionBank. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //NSLog(applicationDocumentsDirectory.path!)
        
        //LaunchScreen ubp_logo.png
        //let navBackgroundImage:UIImage! = UIImage(named: "mast_head4.png")
        //UINavigationBar.appearance().setBackgroundImage(navBackgroundImage, forBarMetrics: .Default)
        //UINavigationBar.appearance().setBackgroundImage(UIImage(named: "mast_head4.png")!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .Stretch), forBarMetrics: .Default)
        UINavigationBar.appearance().backgroundColor = UIColor.orangeColor()
        UINavigationBar.appearance().barTintColor = UIColor.orangeColor()
        
        let openURLAction = UIMutableUserNotificationAction()
        openURLAction.identifier = "openURL"
        openURLAction.title = "View Details"
        openURLAction.destructive = false
        openURLAction.authenticationRequired = false
        openURLAction.activationMode = UIUserNotificationActivationMode.Background
        
        let urlOpenededCategory = UIMutableUserNotificationCategory()
        urlOpenededCategory.identifier = "WEBURLOPEN"
        
        // The Default context is the lock screen.
        urlOpenededCategory.setActions([openURLAction],
            forContext: UIUserNotificationActionContext.Default)
        
        // The Minimal context is when the user pulls down on a notification banner.
        urlOpenededCategory.setActions([openURLAction],
            forContext: UIUserNotificationActionContext.Minimal)
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: [urlOpenededCategory])
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: #selector(AppDelegate.loadBackgroundServices), userInfo: nil, repeats: true)
        
        
        _ = NSTimer.scheduledTimerWithTimeInterval(180, target: self, selector: #selector(AppDelegate.loadAdsServices), userInfo: nil, repeats: true)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // Reset the application badge to zero when the application as launched. The notification is viewed.
        if application.applicationIconBadgeNumber > 0 {
            application.applicationIconBadgeNumber = 0
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.unionbankph.elysium" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("elysium", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    func loadBackgroundServices() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            print("syncing")
            self.executeSubmitAppURL()
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //print("update some UI")
                
            })
        })
    }
    
    func loadAdsServices() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            print("syncing")
            self.executeGetAdsURL()
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //print("update some UI")
                
            })
        })
    }
    
    func executeSubmitAppURL(){
        let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("UrlStrings", inManagedObjectContext: manageObjectContext)
        let sortDescriptor = NSSortDescriptor(key: "datecreated", ascending: true)
        let request = NSFetchRequest()
        request.entity = entityDescription
        request.sortDescriptors = [sortDescriptor]
        request.fetchLimit = 1
        let pred = NSPredicate(format: "(datesuccess = %@)", "0")
        request.predicate = pred
        
        do{
            let results = try manageObjectContext.executeFetchRequest(request) as! [UrlStrings]
            for request in results
            {
                
                let stringUrl = request.valueForKey("url") as! String
                var contProc = true
                let status = Reach().connectionStatus()
                switch status {
                case .Unknown, .Offline:
                    contProc = false
                default:
                    contProc = true
                }
                
                if(contProc){
                    let managedObject = results[0]
                    managedObject.setValue("1", forKey: "datesuccess")
                    
                    let url = NSURL(string: stringUrl)!
                    //let url = NSURL(string: stringUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
                    
                    //stringUrl = stringUrl.substringFromIndex(stringUrl.startIndex.advancedBy(8))
                    //let url = NSURL(string: "https://" + stringUrl.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)!
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
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                    if((s?.containsString("SUCCESS")) == true){
                                        
                                        
                                        // create a corresponding local notification
                                        let notification = UILocalNotification()
                                        let refid = request.valueForKey("refid") as! String
                                        if(refid == "AUTO"){
                                            notification.alertBody = "Your auto loan application has been sent. " // text that will be displayed in the notification
                                        }else if(refid == "HOME"){
                                            notification.alertBody = "Your home loan application has been sent. " // text that will be displayed in the notification
                                        }else if(refid == "CARD"){
                                            notification.alertBody = "Your credit card application has been sent. " // text that will be displayed in the notification
                                        }else if(refid == "SALARY"){
                                            notification.alertBody = "Your salary loan application has been sent. " // text that will be displayed in the notification
                                        }else if(refid == "INQ"){
                                            notification.alertBody = "Your inquiry has been sent. " // text that will be displayed in the notification
                                        }
                                        if #available(iOS 8.2, *) {
                                            if(refid == "AUTO"){
                                                notification.alertTitle = "Auto Loan application sent"
                                            }else if(refid == "HOME"){
                                                notification.alertTitle = "Home Loan application sent"
                                            }else if(refid == "CARD"){
                                                notification.alertTitle = "Credit Card application sent"
                                            }else if(refid == "SALARY"){
                                                notification.alertTitle = "Salary Loan application sent"
                                            }else if(refid == "INQ"){
                                                notification.alertTitle = "Inquiry sent"
                                            }
                                        } else {
                                            // Fallback on earlier versions
                                        }
                                        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
                                        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
                                        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
                                        notification.userInfo = ["UUID": refid, ] // assign a unique identifier to the notification so that we can retrieve it later
                                        notification.category = "TODO_CATEGORY"
                                        UIApplication.sharedApplication().scheduleLocalNotification(notification)
                                        
                                        manageObjectContext.deleteObject(results[0] as NSManagedObject) //delete from core data
                                    }
                                    
                                    
                                })
                            }else{
                                dispatch_async(dispatch_get_main_queue(), {
                                    let managedObject = results[0]
                                    managedObject.setValue("0", forKey: "datesuccess")
                                })
                            }
                        }else{
                            dispatch_async(dispatch_get_main_queue(), {
                                let managedObject = results[0]
                                managedObject.setValue("0", forKey: "datesuccess")
                            })
                        }
                    })
                    jsonQuery.resume()
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        let managedObject = results[0]
                        managedObject.setValue("0", forKey: "datesuccess")
                    })
                }
                
            }
            
            
        }
        catch{
            NSLog("No match found \(error)")
        }
        
        
    }
    
    func executeGetAdsURL(){
        let urlLib = NSLocalizedString("urlLib", comment: "")
        var urlAsString = urlLib.stringByReplacingOccurrencesOfString("@@LIBTYPE", withString: "ADS")

        urlAsString = urlAsString.stringByReplacingOccurrencesOfString("@@PARAM1", withString: UIDevice.currentDevice().identifierForVendor!.UUIDString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)
        
        var contProc = true
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            contProc = false
        default:
            contProc = true
        }
        
        if(contProc){
            
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
                        dispatch_async(dispatch_get_main_queue(), {
                            let str = s!.componentsSeparatedByString("<br/>")
                            
                            for i in 0...str.count - 1{
                                let str2 = str[i].componentsSeparatedByString("***")
                                if(str2[1] != ""){
                                    // create a corresponding local notification
                                    let notification = UILocalNotification()
                                    let refid = str2[0];
                                    if #available(iOS 8.2, *) {
                                        notification.alertTitle = str2[2]
                                    } else {
                                        // Fallback on earlier versions
                                    }
                                    notification.alertBody = str2[3]
                                    notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
                                    notification.fireDate = NSDate(timeIntervalSinceNow: 5)
                                    notification.soundName = UILocalNotificationDefaultSoundName // play default sound
                                    notification.userInfo = ["UUID": refid, ] // assign a unique identifier to the notification so that we can retrieve it later
                                    notification.category = "TODO_CATEGORY"
                                    if(str2[1] == "WEBLINK"){
                                        notification.category = "WEBURLOPEN"
                                        notification.userInfo = ["UUID": refid, "WEBURL": str2[4]]
                                    }
                                    
                                    if UIApplication.sharedApplication().applicationIconBadgeNumber > 0 {
                                        notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
                                    }else{
                                        notification.applicationIconBadgeNumber = 1
                                    }
                                    
                                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
 
                                    
                                    
                                }
                            }
                        })
                    }else{
                        
                    }
                }else{
                    
                }
            })
            jsonQuery.resume()
        }else{
            
        }
        
    }
    
    func application(application: UIApplication,handleActionWithIdentifier identifier: String?,forLocalNotification notification: UILocalNotification,completionHandler: (() -> Void)){
        if(identifier == "openURL"){
            let userInfo = notification.userInfo!
            var weburl = ""
            for(key, value) in userInfo{
                if(key == "WEBURL"){
                    weburl = value as! String
                }
            }
            if let url = NSURL(string: weburl) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if(notification.category == "WEBURLOPEN"){
            let userInfo = notification.userInfo!
            var weburl = ""
            for(key, value) in userInfo{
                if(key == "WEBURL"){
                    weburl = value as! String
                }
            }
            if let url = NSURL(string: weburl) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
}


struct Number {
    static let formatterWithSepator: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .DecimalStyle
        return formatter
    }()
}
extension IntegerType {
    var stringFormattedWithSepator: String {
        return Number.formatterWithSepator.stringFromNumber(hashValue) ?? ""
    }
}

extension NSDate {
    var dateFormatted: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        return formatter.stringFromDate(self)
    }
}
