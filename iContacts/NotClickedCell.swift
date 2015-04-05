//
//  NotClickedCell.swift
//  iContacts
//
//  Created by Xiangrui on 4/2/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit

class NotClickedCell: UITableViewCell {


    
    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func makeCell(contact:MyGroup){
        name.text = contact.name
        if let image = contact.thumbnail{
            thumbnail.image = UIImage(data: image)
        } else {
            thumbnail.image = UIImage(named: "placeholder")
        }
        
    }

}
