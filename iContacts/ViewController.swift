//
//  ViewController.swift
//  iContacts
//
//  Created by Xiangrui on 3/20/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit



class ViewController: UIViewController, ViewControllerDataSource{
    var local:APContact? = nil {
        didSet{
            if local != nil{
                thumbnail.image = local?.thumbnail
                phone.text = String(local?.phones[0] as NSString)
                name.text = local?.compositeName
            }
        }
    }
    
    func userSelectedContact(contact: APContact) {
        self.local = contact
    }

    @IBOutlet weak var name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        var model = selectPersonViewController()
        model.delegate = self

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
    @IBOutlet weak var datePicker: UIDatePicker!
}

