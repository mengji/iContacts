//
//  ClickedTableViewCell.swift
//  iContacts
//
//  Created by Xiangrui on 4/2/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit

class ClickedTableViewCell: UITableViewCell {
    var phoneNumber:String?
    var emailAddress:String?

    @IBOutlet var name: UILabel!
    @IBOutlet var thumbnail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func mail(sender: UIButton) {
        if emailAddress != nil {
            var url = NSURL(string: "mailto://\(emailAddress)")
            if url != nil {
                let webview = UIWebView()
                webview.loadRequest(NSURLRequest(URL: url!))
                self.window?.addSubview(webview)
                //UIApplication.sharedApplication().openURL(url)
            } else {
                println("cannot send mail")
            }
            
        }
    }
    @IBAction func phoneCall(sender: UIButton) {
        if phoneNumber != nil{
            var url = NSURL(string: "tel://\(phoneNumber)")
            if url != nil {
                let webview = UIWebView()
                webview.loadRequest(NSURLRequest(URL: url!))
                self.window?.addSubview(webview)
                //UIApplication.sharedApplication().openURL(url)
            } else {
                println("cannot make phone call")
            }
            //UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNumber)")!)
        }
        
    }

    @IBAction func text(sender: UIButton) {
        if phoneNumber != nil{
            var url = NSURL(string: "sms://\(phoneNumber)")
            if url != nil {
                let webview = UIWebView()
                webview.loadRequest(NSURLRequest(URL: url!))
                self.window?.addSubview(webview)
                //UIApplication.sharedApplication().openURL(url)
            } else {
                println("cannot send text")
            }
            //UIApplication.sharedApplication().openURL(NSURL(string: "sms://\(phoneNumber)")!)
        }
        
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
        if contact.phones != nil && contact.phones?.count > 0{
            self.phoneNumber = contact.phones?.first
        }
        if contact.email != nil && contact.email?.count > 0{
            self.emailAddress = contact.email?.first
        }

        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.thumbnail.layer.masksToBounds = true
        self.thumbnail.layer.cornerRadius = self.thumbnail.bounds.size.width / 2
        self.thumbnail.layer.borderWidth = 2
        self.thumbnail.layer.borderColor = UIColor.grayColor().CGColor
        self.thumbnail.highlighted = true
    }
}
