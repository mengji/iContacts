//
//  SectionCell.swift
//  iContacts
//
//  Created by Xiangrui on 4/5/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit

class SectionCell: UITableViewCell {

    @IBOutlet var groupName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet var openGroup: UIButton!
    @IBOutlet var groupOption: UIButton!
}
