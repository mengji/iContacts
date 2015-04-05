//
//  MyGroup.swift
//  iContacts
//
//  Created by Xiangrui on 4/4/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class MyGroup: NSObject,NSCoding {
    var name:String?
    var thumbnail:NSData?
    var phones:[String]?
    var email:[String]?
    var record:NSNumber?

    required init(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObjectForKey("name") as String?{
            self.name = name
        }
        if let thumbnail = aDecoder.decodeObjectForKey("thumbnail") as NSData?{
            self.thumbnail = thumbnail
        }
        if let phones = aDecoder.decodeObjectForKey("phones") as [String]?{
            self.phones = phones
        }
        if let email = aDecoder.decodeObjectForKey("email") as [String]?{
            self.email = email
        }
        if let record = aDecoder.decodeObjectForKey("record") as NSNumber?{
            self.record = record
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let name = self.name{
            aCoder.encodeObject(name, forKey: "name")
        }
        if let thumbnail = self.thumbnail{
            aCoder.encodeObject(thumbnail, forKey: "thumbnail")
        }
        if let phones = self.email{
            aCoder.encodeObject(phones, forKey: "phones")
        }
        if let email = self.email{
            aCoder.encodeObject(email, forKey: "email")
        }
        if let record = self.record{
            aCoder.encodeObject(record, forKey: "record")
        }
    }
    

    init(contact:APContact){
        self.name = contact.compositeName
        self.thumbnail = UIImagePNGRepresentation(contact.thumbnail)
        self.phones = contact.phones as? [String]
        self.email = contact.emails as? [String]
        self.record = contact.recordID
    }
}
