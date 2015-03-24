//
//  ViewController.swift
//  iContacts
//
//  Created by Xiangrui on 3/20/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit

protocol newEventDelegate {
    func userSelectedContact(sender : ViewController) -> APContact?
}

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBOutlet weak var thumbnail: UIImageView!

    @IBOutlet weak var reason: UITextField!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    @IBAction func createNewEvent(sender: UIButton) {
    }
    @IBOutlet weak var datePicker: UIDatePicker!
}

