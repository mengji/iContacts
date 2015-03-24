//
//  contact.swift
//  iContacts
//
//  Created by Xiangrui on 3/21/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit

class contact: UITableViewCell {

    
    @IBOutlet weak var myimage: UIImageView!
        
    
    @IBOutlet var name: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.myimage.layer.masksToBounds = true
        self.myimage.layer.cornerRadius = self.myimage.bounds.size.width / 2
        self.myimage.layer.borderWidth = 2
        self.myimage.layer.borderColor = UIColor.grayColor().CGColor
        self.myimage.highlighted = true
    }




}
		