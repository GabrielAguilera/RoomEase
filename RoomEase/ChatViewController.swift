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
        
        /** Firebase test stuff **/
        // Create a reference to a Firebase location
//        var myRootRef = Firebase(url: "")
        // Write data to Firebase
//        myRootRef.setValue("Do you have data? You'll love Firebase. Maybe.")
//        myRootRef.observeEventType(.Value, withBlock: {
//            snapshot in
//            print("\(snapshot.key) -> \(snapshot.value)")
//        })

        // Facebook Messenger button
        let messageButton : UIButton = FBSDKMessengerShareButton.circularButtonWithStyle(FBSDKMessengerShareButtonStyle.Blue, width: 50)
        messageButton.addTarget(self, action: "openMessenger", forControlEvents: UIControlEvents.TouchUpInside)
        messageButton.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
        self.view.addSubview(messageButton)
    }

    func openMessenger() {
        // FYI, the url can break at anytime if fb feels like changing it
        // fb-messenger://groupthreadfbid/%s could work in the future???
        UIApplication.sharedApplication().openURL(NSURL(string: "fb-messenger://")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

