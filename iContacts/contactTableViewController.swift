//
//  contactTableViewController.swift
//  iContacts
//
//  Created by Xiangrui on 3/21/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI

class contactTableViewController: UITableViewController, ABPersonViewControllerDelegate, ABNewPersonViewControllerDelegate{
    
    var myBook = Array<Dictionary<String,AnyObject>>()
    let ap = APAddressBook()
    var addressBook:ABAddressBookRef?

    
    func getSysContacts() -> [[String:AnyObject]] {
        var error:Unmanaged<CFError>?
        addressBook = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
        
        let sysAddressBookStatus = ABAddressBookGetAuthorizationStatus()
        
        if sysAddressBookStatus == .Denied || sysAddressBookStatus == .NotDetermined {
            // Need to ask for authorization
            var authorizedSingal:dispatch_semaphore_t = dispatch_semaphore_create(0)
            var askAuthorization:ABAddressBookRequestAccessCompletionHandler = { success, error in
                if success {
                    ABAddressBookCopyArrayOfAllPeople(self.addressBook).takeRetainedValue() as NSArray
                    dispatch_semaphore_signal(authorizedSingal)
                }
            }
            ABAddressBookRequestAccessWithCompletion(addressBook, askAuthorization)
            dispatch_semaphore_wait(authorizedSingal, DISPATCH_TIME_FOREVER)
        }
        
        func analyzeSysContacts(sysContacts:NSArray) -> [[String:AnyObject]] {
            var allContacts:Array = [[String:AnyObject]]()
            
            func analyzeContactProperty(contact:ABRecordRef, property:ABPropertyID) -> [AnyObject]? {
                var propertyValues:ABMultiValueRef? = ABRecordCopyValue(contact, property)?.takeRetainedValue()
                if propertyValues != nil {
                    var values:Array<AnyObject> = Array()
                    for i in 0 ..< ABMultiValueGetCount(propertyValues) {
                        var value = ABMultiValueCopyValueAtIndex(propertyValues, i)
                        switch property {
                            // 地址
                        case kABPersonAddressProperty :
                            var valueDictionary:Dictionary = [String:String]()
                            
                            var addrNSDict:NSMutableDictionary = value.takeRetainedValue() as NSMutableDictionary
                            valueDictionary["_Country"] = addrNSDict.valueForKey(kABPersonAddressCountryKey) as? String ?? ""
                            valueDictionary["_State"] = addrNSDict.valueForKey(kABPersonAddressStateKey) as? String ?? ""
                            valueDictionary["_City"] = addrNSDict.valueForKey(kABPersonAddressCityKey) as? String ?? ""
                            valueDictionary["_Street"] = addrNSDict.valueForKey(kABPersonAddressStreetKey) as? String ?? ""
                            valueDictionary["_Contrycode"] = addrNSDict.valueForKey(kABPersonAddressCountryCodeKey) as? String ?? ""
                            
                            // 地址整理
                            var fullAddress:String = (valueDictionary["_Country"]! == "" ? valueDictionary["_Contrycode"]! : valueDictionary["_Country"]!) + ", " + valueDictionary["_State"]! + ", " + valueDictionary["_City"]! + ", " + valueDictionary["_Street"]!
                            values.append(fullAddress)
                            
                            // SNS
                        case kABPersonSocialProfileProperty :
                            var valueDictionary:Dictionary = [String:String]()
                            
                            var snsNSDict:NSMutableDictionary = value.takeRetainedValue() as NSMutableDictionary
                            valueDictionary["_Username"] = snsNSDict.valueForKey(kABPersonSocialProfileUsernameKey) as? String ?? ""
                            valueDictionary["_URL"] = snsNSDict.valueForKey(kABPersonSocialProfileURLKey) as? String ?? ""
                            valueDictionary["_Serves"] = snsNSDict.valueForKey(kABPersonSocialProfileServiceKey) as? String ?? ""
                            
                            values.append(valueDictionary)
                            // IM
                        case kABPersonInstantMessageProperty :
                            var valueDictionary:Dictionary = [String:String]()
                            
                            var imNSDict:NSMutableDictionary = value.takeRetainedValue() as NSMutableDictionary
                            valueDictionary["_Serves"] = imNSDict.valueForKey(kABPersonInstantMessageServiceKey) as? String ?? ""
                            valueDictionary["_Username"] = imNSDict.valueForKey(kABPersonInstantMessageUsernameKey) as? String ?? ""
                            
                            values.append(valueDictionary)
                            // Date
                        case kABPersonDateProperty :
                            var date:String? = (value.takeRetainedValue() as? NSDate)?.description
                            if date != nil {
                                values.append(date!)
                            }
                        default :
                            var val:String = value.takeRetainedValue() as? String ?? ""
                            values.append(val)
                        }
                    }
                    return values
                }else{
                    return nil
                }
            }
            
            for contact in sysContacts {
                var currentContact:Dictionary = [String:AnyObject]()
                /*
                部分单值属性
                */
                
                currentContact["abrecord"] = contact
                // 姓、姓氏拼音
                var FirstName:String = ABRecordCopyValue(contact, kABPersonFirstNameProperty)?.takeRetainedValue() as String? ?? ""
                currentContact["FirstName"] = FirstName
                currentContact["FirstNamePhonetic"] = ABRecordCopyValue(contact, kABPersonFirstNamePhoneticProperty)?.takeRetainedValue() as String? ?? ""
                // 名、名字拼音
                var LastName:String = ABRecordCopyValue(contact, kABPersonLastNameProperty)?.takeRetainedValue() as String? ?? ""
                currentContact["LastName"] = LastName
                currentContact["LirstNamePhonetic"] = ABRecordCopyValue(contact, kABPersonLastNamePhoneticProperty)?.takeRetainedValue() as String? ?? ""
                // 昵称
                currentContact["Nikename"] = ABRecordCopyValue(contact, kABPersonNicknameProperty)?.takeRetainedValue() as String? ?? ""
                
                // 姓名整理
                currentContact["fullName"] = LastName + FirstName
                
                // 公司（组织）
                currentContact["Organization"] = ABRecordCopyValue(contact, kABPersonOrganizationProperty)?.takeRetainedValue() as String? ?? ""
                // 职位
                currentContact["JobTitle"] = ABRecordCopyValue(contact, kABPersonJobTitleProperty)?.takeRetainedValue() as String? ?? ""
                // 部门
                currentContact["Department"] = ABRecordCopyValue(contact, kABPersonDepartmentProperty)?.takeRetainedValue() as String? ?? ""
                // 备注
                currentContact["Note"] = ABRecordCopyValue(contact, kABPersonNoteProperty)?.takeRetainedValue() as String? ?? ""
                // 生日（类型转换有问题，不可用）
                //currentContact["Brithday"] = ((ABRecordCopyValue(contact, kABPersonBirthdayProperty)?.takeRetainedValue()) as NSDate).description
                
                /*
                部分多值属性
                */
                // 电话
                var Phone:Array<AnyObject>? = analyzeContactProperty(contact, kABPersonPhoneProperty)
                if Phone != nil {
                    currentContact["Phone"] = Phone
                }
                
                // 地址
                var Address:Array<AnyObject>? = analyzeContactProperty(contact, kABPersonAddressProperty)
                if Address != nil {
                    currentContact["Address"] = Address
                }
                
                // E-mail
                var Email:Array<AnyObject>? = analyzeContactProperty(contact, kABPersonEmailProperty)
                if Email != nil {
                    currentContact["Email"] = Email
                }
                // 纪念日
                var Date:Array<AnyObject>? = analyzeContactProperty(contact, kABPersonDateProperty)
                if Date != nil {
                    currentContact["Date"] = Date
                }
                // URL
                var URL:Array<AnyObject>? = analyzeContactProperty(contact, kABPersonURLProperty)
                if URL != nil{
                    currentContact["URL"] = URL
                }
                // SNS
                var SNS:Array<AnyObject>? = analyzeContactProperty(contact, kABPersonSocialProfileProperty)
                if SNS != nil {
                    currentContact["SNS"] = SNS
                }
                
                if ABPersonHasImageData(contact){
                    let data = ABPersonCopyImageDataWithFormat(contact, kABPersonImageFormatThumbnail).takeRetainedValue() as NSData
                    currentContact["Thumbnail"] = UIImage(data: data)
                } else {
                    currentContact["Thumbnail"] = UIImage(named: "placeholder")
                }
                allContacts.append(currentContact)
            }
            allContacts = sorted(allContacts,mcp)
            return allContacts
        }
        return analyzeSysContacts( ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray )
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func mcp(dict1: Dictionary<String,AnyObject>, dict2:Dictionary<String,AnyObject>) -> Bool{
        let firstname1 = dict1["FirstName"] as String
        let firstname2 = dict2["FirstName"] as String
        let lastname1 = dict1["LastName"] as String
        let lastname2 = dict2["LastName"] as String
        if firstname1 == firstname2 {
            return lastname1 < lastname2
        } else {
            return firstname1 < firstname2
        }

    }
    
    func refresh(){
        myBook = getSysContacts()
        
        //test()
        self.tableView.reloadData()
    }
    
    @IBAction func sync(sender: UIBarButtonItem) {
        refresh()
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
        return myBook.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as contact

        cell.myimage.image = myBook[indexPath.row]["Thumbnail"] as? UIImage
        cell.name.text = myBook[indexPath.row]["fullName"] as? String

        return cell
    }
    
    func test(){
        self.ap.loadContacts(
            { (contacts: [AnyObject]!, error: NSError!) in
                if contacts != nil{
                    for contact in contacts {
                        let c = contact as APContact
                        println(c.firstName)
                    }
                }
                else if error != nil {
                    // show error
                }
        })
    }
    
    @IBAction func addNewPerson(sender: UIBarButtonItem) {
        let npvc = ABNewPersonViewController()
        npvc.newPersonViewDelegate = self
        let nc = UINavigationController(rootViewController:npvc)
        self.presentViewController(nc, animated:true, completion:nil)
    }

    func personViewController(personViewController: ABPersonViewController!, shouldPerformDefaultActionForPerson person: ABRecord!, property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
        return false
    }
    
    func newPersonViewController(newPersonView: ABNewPersonViewController!, didCompleteWithNewPerson person: ABRecord!) {
        refresh()
        self.dismissViewControllerAnimated(true, completion:nil)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let record: ABRecordRef! = myBook[indexPath.row]["abrecord"] as ABRecordRef!
        let vc = ABPersonViewController()
        vc.addressBook = self.addressBook
        vc.displayedPerson = record
        vc.personViewDelegate = self
        vc.displayedProperties = [Int(kABPersonEmailProperty),Int(kABPersonPhoneProperty)]
        vc.allowsEditing = false
        vc.allowsActions = true
        self.showViewController(vc, sender: self)
        
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
