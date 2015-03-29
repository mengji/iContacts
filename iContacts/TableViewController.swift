//
//  TableViewController.swift
//  iContacts
//
//  Created by Xiangrui on 3/26/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController,EventsViewRefreshReminder {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var events:[Events] = [Events]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        refresh()
    }
    
    func tableNeedReload() {
        refresh()
    }
    
    func refresh(){
        fetch()
        self.tableView.reloadData()
    }
    
    func fetch(){
        let fetchRequest = NSFetchRequest(entityName: "Events")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var fetchResults = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [Events]
        events = fetchResults!
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return events.count
    }
    
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eCell", forIndexPath: indexPath) as EventCell

        cell.name.text = events[indexPath.row].name
        cell.thumbnail.image = UIImage(data: events[indexPath.row].thumbnail)
        cell.date.text = formatDate(events[indexPath.row].date)
        cell.reason.text = events[indexPath.row].reason
        cell.thumbnail.layer.masksToBounds = true
        cell.thumbnail.layer.cornerRadius = cell.thumbnail.bounds.size.width / 2
        cell.thumbnail.layer.borderWidth = 2
        cell.thumbnail.layer.borderColor = UIColor.grayColor().CGColor
        cell.thumbnail.highlighted = true
        return cell
    }
    
    func formatDate(date:NSDate) ->String{
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .LongStyle
        let dateString = formatter.stringFromDate(date)
        return dateString
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            managedObjectContext?.deleteObject(events[indexPath.row])
            managedObjectContext?.save(nil)
            fetch()
            var notifications = UIApplication.sharedApplication().scheduledLocalNotifications as[UILocalNotification]
            for notification in notifications{
                if let info = notification.userInfo{
                    var id = info["id"] as String
                    if id == events[indexPath.row].id{
                        UIApplication.sharedApplication().cancelLocalNotification(notification)
                        println("delete one")
                    }
                }
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toNewEvent" {
            let destinationViewController:ViewController = segue.destinationViewController as ViewController
            destinationViewController.delegate = self
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
