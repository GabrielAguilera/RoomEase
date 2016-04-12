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
        
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "stairsLoft.jpg")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imageViewBackground.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        imageViewBackground.addSubview(blurEffectView)
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)
    }
}

