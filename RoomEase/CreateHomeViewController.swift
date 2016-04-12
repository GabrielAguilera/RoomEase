//
//  CreateHomeViewController.swift
//  RoomEase
//
//  Created by Gabriel Aguilera on 4/9/16.
//  Copyright © 2016 RoomEase - EECS 441. All rights reserved.
//

import Firebase
import UIKit

class CreateHomeViewController: UIViewController {
    
    @IBOutlet weak var homeNameTextBox: UITextField!
    
    let shareData = ShareData.sharedInstance
    
    
    override func viewDidAppear(animated: Bool) {
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
    

    
    
    
    @IBAction func createButtonPressed(sender: AnyObject) {
        if homeNameTextBox.text!.isEmpty {
            let alertController = UIAlertController(title: "No Home Name", message: "Please enter a homename to continue!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            createHome()
        }
    }
    
    func createHome()
    {
        let homeId = homeNameTextBox.text!
        // send request to firebase to get a new homecode
        // the slash at the end is super important. If you omit it, you
        // overwrite the whole endpoint
        let ref = Firebase(url: self.shareData.ROOT_URL + "home/" + homeId)
        ref.observeSingleEventOfType(FEventType.Value, withBlock: { homeObj in
            if homeObj.value is NSNull {
                // Home doesn't exist so create it!
                let newHome = ["members": [self.shareData.currentUserId], "name": homeId]
                let newHomeRef = Firebase(url: self.shareData.ROOT_URL + "home/" + homeId)
                newHomeRef.setValue(newHome)

                let joinRef = Firebase(url: self.shareData.ROOT_URL + "users/" + self.shareData.currentUserId + "/homeId")
                joinRef.setValue(homeId)
                self.shareData.currentHomeId = homeId
                
                self.performSegueWithIdentifier("HomeCreatedSegue", sender: nil)
            } else {
                // Alert user that this home already exists
                let alertController = UIAlertController(title: "Home Exists!", message: "Please enter a different home name to continue!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            }
        })
    }
}
