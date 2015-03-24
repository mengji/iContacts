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
                if local?.thumbnail != nil{
                    thumbnail.image = local?.thumbnail
                } else {
                    thumbnail.image = UIImage(named: "placeholder")
                }
                phone.text = String(local?.phones[0] as NSString)
                name.text = local?.compositeName
            }
        }
    }
    

    func userSelectedContact(contact: APContact) {
        self.local = contact
        self.view.setNeedsDisplay()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.thumbnail.layer.masksToBounds = true
        self.thumbnail.layer.cornerRadius = self.thumbnail.bounds.size.width / 2
        self.thumbnail.layer.borderWidth = 2
        self.thumbnail.layer.borderColor = UIColor.grayColor().CGColor
        self.thumbnail.highlighted = true
    }


    
    @IBOutlet weak var name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        


        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    @IBAction func createNewEvents(sender: UIButton) {
    }

    @IBOutlet weak var thumbnail: UIImageView!

    

    @IBOutlet weak var reason: UITextField!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectPerson" {
            let destinationViewController:selectPersonViewController = segue.destinationViewController as selectPersonViewController
            destinationViewController.delegate = self
        }
    }
}

