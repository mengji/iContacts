//
//  AppDelegate.swift
//  iContacts
//
//  Created by Xiangrui on 3/20/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        /*application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))*/
        let notificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
        let acceptAction = UIMutableUserNotificationAction()
        acceptAction.identifier = "Call"
        acceptAction.title = "Make a Call"
        acceptAction.activationMode = UIUserNotificationActivationMode.Background
        acceptAction.destructive = false
        acceptAction.authenticationRequired = false
        
        let declineAction = UIMutableUserNotificationAction()
        declineAction.identifier = "Decline"
        declineAction.title = "Cancel"
        declineAction.activationMode = UIUserNotificationActivationMode.Background
        declineAction.destructive = false
        declineAction.authenticationRequired = false
        
        
        let category = UIMutableUserNotificationCategory()
        category.identifier = "invite"
        category.setActions([acceptAction, declineAction], forContext: UIUserNotificationActionContext.Default)
        //category.setActions([acceptAction], forContext: UIUserNotificationActionContext.Default)
        let categories = NSSet(array: [category])
        let settings = UIUserNotificationSettings(forTypes: notificationType, categories: categories)
        application.registerUserNotificationSettings(settings)
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack
    

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Xiangrui.iContacts" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("iContacts", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("iContacts.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if application.applicationState == .Active{
            var id = ""
            var reason = ""
            var name = ""
            var phone = ""
            if let info = notification.userInfo{
                id = info["id"] as String
                reason = info["reason"] as String
                name = info["name"] as String
                phone = info["phone"] as String
            }
            
            let alert = UIAlertController(title: name, message: reason, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {_ in
                self.deleteNotification(id)}))
            alert.addAction(UIAlertAction(title: "Call", style: UIAlertActionStyle.Default, handler: {_ in self.call(phone)
                self.deleteNotification(id)
            }))
            
            window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)        }
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        var id = ""
        var phone = ""
        if let info = notification.userInfo {
            id = info["id"] as String
            phone = info["phone"] as String
        }
        if identifier == "Call" {
            call(phone)
            deleteNotification(id)
        } else if identifier == "Decline" {
            deleteNotification(id)
        }
    }
    
    func deleteNotification(id:String){
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Events")
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        var fetchResults = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as [Events]
        println(fetchResults.count)
        for event in fetchResults{
            managedObjectContext?.deleteObject(event)
        }
        managedObjectContext?.save(nil)

        
        
    }
    



   
    
    
    func call(phoneNumber:String){
        //UIApplication.sharedApplication().openURL(NSURL(string: "tel://9809088798")!)
        window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel://\(phoneNumber)")!){
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNumber)")!)
        } else {
            println("fail")
        }
    }
    


}

