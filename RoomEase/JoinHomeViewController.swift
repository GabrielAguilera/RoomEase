//
//  CreateHomeViewController.swift
//  RoomEase
//
//  Created by Gabriel Aguilera on 4/9/16.
//  Copyright © 2016 RoomEase - EECS 441. All rights reserved.
//

import Firebase
import UIKit

class JoinHomeViewController: UIViewController {

    @IBOutlet weak var homeIdTextBox: UITextField!
    
    let shareData = ShareData.sharedInstance
    
   
    
    
    override func viewDidLoad() {
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
    
    
    @IBAction func joinButtonPressed(sender: AnyObject) {
        if homeIdTextBox.text!.isEmpty {
            let alertController = UIAlertController(title: "No Home Name", message: "Please enter a homename to continue!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            joinHome()
        }
    }
    
    func joinHome()
    {
        let homeId = homeIdTextBox.text!
        let homeRef = Firebase(url: self.shareData.ROOT_URL + "home/" + homeId)
        homeRef.observeSingleEventOfType(FEventType.Value, withBlock: { homeObj in
            if homeObj.value is NSNull {
                let alertController = UIAlertController(title: "Home doesn't exist!", message: "Please enter a different home name to continue!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                // Update user homeid
                let userRef = Firebase(url: self.shareData.ROOT_URL + "users/" + self.shareData.currentUserId + "/homeId")
                userRef.setValue(homeId)
                self.shareData.currentHomeId = homeId
                
                // Update member array
                let newMembers = homeObj.childSnapshotForPath("members").value as! NSMutableArray
                let num = Int(self.shareData.currentUserId)
                let myNum = NSNumber(integer:num!)
                newMembers.addObject(myNum)
                
                // Push new member array
                let homeRef = Firebase(url: self.shareData.ROOT_URL + "home/" + homeId + "/members/")
                homeRef.setValue(newMembers)
                
                self.performSegueWithIdentifier("HomeJoinedSegue", sender: nil)
            }
        })
    }
}
