//
//  ViewController.swift
//  iContacts
//
//  Created by Xiangrui on 3/20/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit
import CoreData

protocol EventsViewRefreshReminder:class {
    func tableNeedReload()
}

class ViewController: UIViewController, ViewControllerDataSource, IGLDropDownMenuDelegate{
    
    var seletedPhone = "No Seleted"
    @IBOutlet var dropDown: IGLDropDownMenu!
        
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var dateSeleted: NSDate = NSDate()
    var id:String = String()
    var local:APContact? = nil {
        didSet{
            if local != nil{
                if local?.thumbnail != nil{
                    thumbnail.image = local?.thumbnail
                } else {
                    thumbnail.image = UIImage(named: "placeholder")
                }
                dropDown.menuText = "Choose Phone Number"
                var items:[IGLDropDownItem] = [IGLDropDownItem]()
                for (var i = 0;i < local?.phones.count;i++) {
                    var item = IGLDropDownItem()
                    item.text = local?.phones[i] as NSString
                    items.append(item)
                }
                dropDown.dropDownItems = items
                dropDown.gutterY = 5;
                dropDown.type = IGLDropDownMenuType.SlidingInBoth
                dropDown.itemAnimationDelay = 0.1;
                dropDown.delegate = self
                dropDown.reloadView()
                //phone.text = String(local?.phones[0] as NSString)
                name.text = local?.compositeName
            }
        }
    }
    
    func dropDownMenu(dropDownMenu: IGLDropDownMenu!, selectedItemAtIndex index: Int) {
        var item:IGLDropDownItem = dropDown.dropDownItems[index] as IGLDropDownItem
        seletedPhone = item.text
    }
    
    
    var delegate:EventsViewRefreshReminder?
    

    func userSelectedContact(contact: APContact) {
        self.local = contact
        self.view.setNeedsDisplay()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.thumbnail.layer.masksToBounds = true
        self.thumbnail.layer.cornerRadius = self.thumbnail.bounds.size.width / 2
        self.thumbnail.layer.borderWidth = 2
        self.thumbnail.layer.borderColor = UIColor.grayColor().CGColor
        self.thumbnail.highlighted = true
    }



    @IBAction func dateChanged(sender: UIDatePicker) {
        let seconds:NSTimeInterval = floor(sender.date.timeIntervalSinceReferenceDate / 60.0)*60.0
        let rounded = NSDate(timeIntervalSinceReferenceDate: seconds)
        self.dateSeleted = rounded
    }
    
    @IBOutlet weak var name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        


        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    @IBAction func createNewEvents(sender: UIButton) {
        if local != nil && seletedPhone != "No Seleted"{
            if let moc = self.managedObjectContext{
                id = "\(NSDate())"
                Events.createInManagedObjectContext(moc, contact: local!, date: dateSeleted, phone: seletedPhone/*phone.text!*/,id: id,reason:reason.text)
                
            }
            if notification.on {
                createNotification()
            }
            /*let fetchRequest = NSFetchRequest(entityName: "Events")
            //let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            //fetchRequest.sortDescriptors = [sortDescriptor]
            var fetchResults = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [Events]*/
            delegate?.tableNeedReload()

            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func createNotification(){
        var notification = UILocalNotification()
        notification.fireDate = dateSeleted
        notification.userInfo = ["id": id]
        //notification.applicationIconBadgeNumber = 1
        notification.alertBody = "Call \(local?.compositeName!) for \(reason.text)"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.category = "invite"

        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        println("success")

    }

    @IBOutlet weak var thumbnail: UIImageView!

    

    @IBOutlet weak var notification: UISwitch!
    @IBOutlet weak var reason: UITextField!
    //@IBOutlet weak var phone: UILabel!

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectPerson" {
            let destinationViewController:selectPersonViewController = segue.destinationViewController as selectPersonViewController
            destinationViewController.delegate = self
        }
    }
    
}

