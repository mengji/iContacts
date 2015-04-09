//
//  GroupTableViewController.swift
//  iContacts
//
//  Created by Xiangrui on 4/2/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit
import CoreData


class GroupTableViewController: UITableViewController, GroupTableViewRefreshReminder, UITextFieldDelegate{
    var seleted:NSIndexPath? = nil
    var seletedSection:Int? = nil
    var groups = Array<(String, Array<MyGroup>)>()
    var openedGroup = Array<String>()
    let addressBook = APAddressBook()
    var contacts = Array<APContact>()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    

    func tableNeedReload() {
        fetch()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addGroup(sender: UIBarButtonItem) {
        showAlert("What is the Name of the New Group?")
    }
    
    func showAlert(message:String){
        var alert = UIAlertController(title: "Add New Group", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: {_ in self.checkIfNewGroupNameValid(alert)}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addTextFieldWithConfigurationHandler({
            (textfield) in
            textfield.placeholder = "New Group Name"
            textfield.delegate = self
        
        })
        
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func checkIfNewGroupNameValid(alert:UIAlertController){
        let textField = alert.textFields as [UITextField]
        if textField.count > 0{
            if textField[0].text == "" {
                self.showAlert("Group Name Cannot Be Empty")
            } else if (self.checkGroupNameDup(textField[0].text) == false){
                self.showAlert("Group Name Already Exist")
            } else {
                self.createNewGroup(textField[0].text)
                self.fetch()
            }
        }
    }
    
    func createNewGroup(groupName:String){
        Groups.createInManagedObjectContext(managedObjectContext!, name: groupName, people: [MyGroup]())
    }
    
    func checkGroupNameDup(groupName:String) -> Bool{
        for (existName,_) in groups{
            if existName == groupName{
                return false
            }
        }
        return true
    }
    
    
    
    
    
    
    func fetch(){
        let fetchRequest = NSFetchRequest(entityName: "Groups")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var fetchResults = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [Groups]
        groups.removeAll(keepCapacity: true)
        if let result = fetchResults{
            for g in result{
                let member = (g.name,g.groupmember as Array<MyGroup>)
                self.groups.append(member)
            }
        }
        tableView.reloadData()

    }
    
    func addBackGround(){
        var background = UIImageView(image: UIImage(named:"background"))
        background.frame = UIScreen.mainScreen().bounds
        var blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = background.frame
        background.addSubview(effectView)
        self.tableView.backgroundView = background
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackGround()

        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        

        
        

        
        

        
        

        fetch()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return groups.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let (groupname,grouper) = groups[section]
        if let index = find(openedGroup, groupname){
            return grouper.count
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath == seleted && seleted != nil{
            let cell = tableView.dequeueReusableCellWithIdentifier("clicked", forIndexPath: indexPath) as ClickedTableViewCell
            let (_,groupers) = groups[indexPath.section]
            cell.makeCell(groupers[indexPath.row])
            cell.backgroundColor = UIColor.clearColor()
            
            let seperator = UIView()
            seperator.frame = CGRectMake(0, 64.5, UIScreen.mainScreen().bounds.width, 0.5)
            seperator.backgroundColor = tableView.separatorColor
            cell.contentView.addSubview(seperator)
            
            let background = UIImageView()
            background.frame = CGRectMake(0, 65, UIScreen.mainScreen().bounds.width, 49)
            //background.image = UIImage(named: "arrawBg.png")
            background.backgroundColor = UIColor.grayColor()
            cell.addSubview(background)
            cell.sendSubviewToBack(background)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("notClicked", forIndexPath: indexPath) as NotClickedCell
            let (_,groupers) = groups[indexPath.section]
            cell.makeCell(groupers[indexPath.row])
            cell.backgroundColor = UIColor.clearColor()
            

            return cell
        }
        

        

        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if seleted == nil {
            self.seleted = indexPath
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        } else {
            if seleted == indexPath{
                seleted = nil
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            } else {
                var tmp:NSIndexPath = seleted!
                seleted = nil
                tableView.reloadRowsAtIndexPaths([tmp], withRowAnimation:UITableViewRowAnimation.Automatic )
                self.seleted = indexPath
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.None, animated: true)

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if seleted != nil && seleted == indexPath{
            return 115
        } else {
            return 65
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        /*var headerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 50))
        headerView.backgroundColor = UIColor.lightGrayColor()
        
        let mylabel = UILabel(frame: CGRectMake(16, 2, 200, 30))
        mylabel.text = "test"
        let seperator = CALayer()
        seperator.frame = CGRectMake(0, 49, UIScreen.mainScreen().bounds.width, 1)
        seperator.backgroundColor = UIColor.lightGrayColor().CGColor
        
        let myButton = UIButton(frame:CGRectMake(0, 0, 320, 50))
        
        myButton.addTarget(self, action: "tapHeader:", forControlEvents: UIControlEvents.TouchUpInside)
        myButton.tag = section

        
        headerView.addSubview(mylabel)
        headerView.addSubview(myButton)
        headerView.layer.addSublayer(seperator)
        
        return headerView*/
        
        

    
        let (groupname, groupmember) = groups[section]
        if seletedSection != nil && seletedSection == section {
            let cell = tableView.dequeueReusableCellWithIdentifier("sectionCellClicked") as SectionCellClicked
            cell.groupName.text = groupname
            
            let button = cell.openGroup
            button.tag = section
            button.addTarget(self, action: "tapHeader:", forControlEvents: UIControlEvents.TouchUpInside)
            
            let openOptionButton = cell.groupOption
            openOptionButton.tag = section
            openOptionButton.addTarget(self, action: "tapOption:", forControlEvents: UIControlEvents.TouchUpInside)
            
            let editGroupButton = cell.EditGroup
            editGroupButton.tag = section
            
            let removeButton = cell.removeGroup
            removeButton.tag = section
            removeButton.addTarget(self, action: "deleteGroup:", forControlEvents: UIControlEvents.TouchUpInside)
            
            while(cell.contentView.gestureRecognizers?.count > 0){
                cell.contentView.gestureRecognizers?.removeAll(keepCapacity: false)
            }
            let seperator = UIView()
            seperator.frame = CGRectMake(0, 59.5, UIScreen.mainScreen().bounds.width, 0.5)
            seperator.backgroundColor = tableView.separatorColor
            cell.contentView.addSubview(seperator)
            
            let seperator2 = UIView()
            seperator2.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 0.5)
            seperator2.backgroundColor = tableView.separatorColor
            cell.contentView.addSubview(seperator2)
            
            let background = UIImageView()
            background.frame = CGRectMake(0, 60, UIScreen.mainScreen().bounds.width, 49)
            //background.image = UIImage(named: "arrawBg.png")
            background.backgroundColor = UIColor.grayColor()
            cell.contentView.addSubview(background)
            cell.contentView.sendSubviewToBack(background)
            

            return cell.contentView
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("sectionCell") as SectionCell
            cell.groupName.text = groupname
            let button = cell.openGroup
            button.tag = section
            button.addTarget(self, action: "tapHeader:", forControlEvents: UIControlEvents.TouchUpInside)
            let openOptionButton = cell.groupOption
            openOptionButton.tag = section
            openOptionButton.addTarget(self, action: "tapOption:", forControlEvents: UIControlEvents.TouchUpInside)
            while(cell.contentView.gestureRecognizers?.count > 0){
                cell.contentView.gestureRecognizers?.removeAll(keepCapacity: false)
            }
            let seperator = UIView()
            seperator.frame = CGRectMake(0, 59.5, UIScreen.mainScreen().bounds.width, 0.5)
            seperator.backgroundColor = tableView.separatorColor
            cell.contentView.addSubview(seperator)
            
            let seperator2 = UIView()
            seperator2.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 0.5)
            seperator2.backgroundColor = tableView.separatorColor
            cell.contentView.addSubview(seperator2)
            
            return cell.contentView
        }

        
    }
    
    func tapOption(sender:UIButton){
        if seletedSection == nil {
            seletedSection = sender.tag
            tableView.reloadSections(NSIndexSet(index: sender.tag), withRowAnimation: UITableViewRowAnimation.Automatic)
        } else {
            if seletedSection == sender.tag {
                seletedSection = nil
                tableView.reloadSections(NSIndexSet(index: sender.tag), withRowAnimation: UITableViewRowAnimation.Automatic)
            } else {
                var tmp:Int = seletedSection!
                seletedSection = nil
                tableView.reloadSections(NSIndexSet(index: tmp), withRowAnimation: UITableViewRowAnimation.Automatic)
                seletedSection = sender.tag
                tableView.reloadSections(NSIndexSet(index: sender.tag), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }
    
    func deleteGroup(sender:UIButton){
        let section = sender.tag
        let (groupName,groupMember) = groups[section]
        let fetchRequest = NSFetchRequest(entityName: "Groups")
        let predicate = NSPredicate(format: "name == %@", groupName)
        fetchRequest.predicate = predicate
        var fetchResults = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as [Groups]
        println(fetchResults.count)
        for g in fetchResults{
            managedObjectContext?.deleteObject(g)
        }
        managedObjectContext?.save(nil)
        
        if seleted != nil && seleted?.section == section{
            seleted = nil
        }
        
        if seletedSection != nil && seletedSection == section {
            seletedSection = nil
        }
        
        if let index = find(openedGroup, groupName){
            openedGroup.removeAtIndex(index)
        }
        
        groups.removeAtIndex(section)
        self.tableView.reloadData()
        
    }
    
    func tapHeader(sender:UIButton){
        let (groupname,grouper) = groups[sender.tag]
        if let index = find(openedGroup, groupname){
            openedGroup.removeAtIndex(index)
        } else {
            openedGroup.append(groupname)
        }
        tableView.reloadSections(NSIndexSet(index: sender.tag), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if seletedSection != nil && section == seletedSection{
            return 109
        } else {
             return 60
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditGroupMember" {
            if let button = sender as? UIButton {
                let destinationViewController:SelectGroupMemberController = segue.destinationViewController as SelectGroupMemberController
                destinationViewController.information = groups[button.tag]
                destinationViewController.delegate = self
                
            }
        }
            
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
