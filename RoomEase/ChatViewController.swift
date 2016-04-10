//
//  ChatViewController.swift
//  RoomEase
//
//  Created by Jessica Aboukasm on 2/25/16.
//  Copyright (c) 2016 RoomEase - EECS 441. All rights reserved.
//

import Firebase

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKMessengerShareKit

class ChatViewController: UIViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.darkGrayColor()
        
        // Facebook Messenger button
        let messageButton : UIButton = FBSDKMessengerShareButton.circularButtonWithStyle(FBSDKMessengerShareButtonStyle.Blue, width: 50)
        messageButton.addTarget(self, action: "openMessenger", forControlEvents: UIControlEvents.TouchUpInside)
        messageButton.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
        self.view.addSubview(messageButton)
    }

    func openMessenger() {}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

