//
//  SelectGroupMemberController.swift
//  iContacts
//
//  Created by Xiangrui on 4/5/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit
import CoreData
class SelectGroupMemberController: UITableViewController {
    
    var information:(String, Array<MyGroup>)?
    var groupData = Array<MyGroup>()
    var groupName = String()
    var addressBook = APAddressBook()
    var contacts = Array<APContact>()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addressBook.fieldsMask = APContactField.Default | APContactField.Thumbnail | APContactField.CompositeName | APContactField.Emails | APContactField.RecordID
        self.addressBook.sortDescriptors = [NSSortDescriptor(key: "compositeName", ascending: true)]
        
        self.addressBook.loadContacts(
            { (contacts: [AnyObject]!, error: NSError!) in
                if contacts != nil{
                    self.contacts = contacts as [APContact]
                    self.tableView.reloadData()
                }
                else if error != nil {
                    // show error
                }
        })
        if information != nil{
            (groupName,groupData) = information!
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillDisappear(animated: Bool) {
        let fetchRequest = NSFetchRequest(entityName: "Groups")
        let predicate = NSPredicate(format: "name == %@", groupName)
        fetchRequest.predicate = predicate
        var fetchResults = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as [Groups]
        println(fetchResults.count)
        for event in fetchResults{
            event.groupmember = groupData
        }
        managedObjectContext?.save(nil)
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
        return contacts.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        if checkContactIncluded(contacts[indexPath.row]) == false{
            groupData.append(MyGroup(contact: contacts[indexPath.row]))
        } else {
            deleteContact(contacts[indexPath.row])
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)

    }
    
    func checkContactIncluded(contact:APContact) -> Bool{
        for data in groupData {
            if data.record == contact.recordID {
                return true
            }
        }
        return false
    }
    
    func deleteContact(contact:APContact){
        for var index = 0; index < groupData.count ; index++ {
            if contact.recordID == groupData[index].record{
                groupData.removeAtIndex(index)
            }
        }
            
            
        

    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectGroupCell", forIndexPath: indexPath) as contact
        let contactForRow = contacts[indexPath.row]
        if let thumbnail = contactForRow.thumbnail {
            cell.myimage.image = thumbnail
        } else {
            cell.myimage.image = UIImage(named: "placeholder")
        }
        cell.name.text = contactForRow.compositeName
        if checkContactIncluded(contacts[indexPath.row]) == true{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }


        // Configure the cell...

        return cell
    }
    

    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
