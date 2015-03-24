//
//  selectPersonViewController.swift
//  iContacts
//
//  Created by Xiangrui on 3/23/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit
protocol ViewControllerDataSource : class {
    func userSelectedContact(contact:APContact)
}
class selectPersonViewController: UITableViewController, UISearchBarDelegate{
    
    var delegate:ViewControllerDataSource?
    
    @IBOutlet weak var searchBar: UISearchBar!
    let addressBook = APAddressBook()
    var contacts = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        getContacts()
    }


    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        getContacts(search: searchText)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        getContacts()
        searchBar.resignFirstResponder()
    }
    
    
    func getContacts(search:String = ""){
        self.addressBook.fieldsMask = APContactField.Default | APContactField.Thumbnail | APContactField.CompositeName
        self.addressBook.sortDescriptors = [NSSortDescriptor(key: "compositeName", ascending: true)]
        self.addressBook.filterBlock = {
            (contact:APContact!) -> Bool in
            var isValid = contact.phones.count > 0 && contact.compositeName != nil
            
            if (countElements(search) > 0 && isValid){
                isValid = contact.compositeName.lowercaseString.rangeOfString(search) != nil
            }
            return isValid
        }
        self.addressBook.loadContacts(
            { (contacts: [AnyObject]!, error: NSError!) in
                if contacts != nil{
                    self.contacts = contacts
                    self.tableView.reloadData()
                }
                else if error != nil {
                    // show error
                }
        })
        
    }
    
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("selectCell", forIndexPath: indexPath) as contact
        let seletedContact = contacts[indexPath.row] as APContact
        if let thumbnail = seletedContact.thumbnail {
            cell.myimage.image = thumbnail
        } else {
            cell.myimage.image = UIImage(named: "placeholder")
        }
        
        let firstName = seletedContact.firstName
        let lastName = seletedContact.lastName
        cell.name.text = (firstName ?? "") + " " + (lastName ?? "")
        return cell
    }
    

    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("selectCell", forIndexPath: indexPath) as contact
        let seletedContact = contacts[indexPath.row] as APContact
        cell.myimage.image = seletedContact.thumbnail
        let firstName = seletedContact.firstName
        let lastName = seletedContact.lastName
        cell.name.text = (firstName ?? "") + " " + (lastName ?? "")
        return cell
    }*/
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.userSelectedContact(contacts[indexPath.row] as APContact)
        self.navigationController?.popViewControllerAnimated(true)

        
    }
    

}
