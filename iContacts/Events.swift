//
//  Events.swift
//  iContacts
//
//  Created by Xiangrui on 3/25/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import Foundation
import CoreData

@objc(Events)
class Events: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var phone: String
    @NSManaged var thumbnail: NSData
    @NSManaged var date: NSDate
    @NSManaged var id: String
    @NSManaged var reason: String
    
    class func createInManagedObjectContext(moc:NSManagedObjectContext, contact:APContact,date:NSDate, phone:String,id:String,reason:String) -> Events {
        let newEvent = NSEntityDescription.insertNewObjectForEntityForName("Events", inManagedObjectContext: moc) as Events
        newEvent.name = contact.compositeName
        newEvent.phone = phone
        newEvent.thumbnail = UIImagePNGRepresentation(contact.thumbnail) ?? UIImagePNGRepresentation(UIImage(named: "placeholder"))
        newEvent.date = date
        newEvent.id = id
        newEvent.reason = reason
        return newEvent
    }

}
