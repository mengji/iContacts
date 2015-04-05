//
//  Groups.swift
//  iContacts
//
//  Created by Xiangrui on 4/3/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import Foundation
import CoreData

@objc(Groups)
class Groups: NSManagedObject {

    @NSManaged var groupmember: AnyObject
    @NSManaged var name: String
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, name:String, people:[MyGroup]) -> Groups {
        let newEvent = NSEntityDescription.insertNewObjectForEntityForName("Groups", inManagedObjectContext: moc) as Groups
        newEvent.name = name
        newEvent.groupmember = people
        moc.save(nil)        
        return newEvent
        
    }
}
