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
    
    @IBAction func joinButtonPressed(sender: AnyObject) {
        if homeIdTextBox.text!.isEmpty {
            let alertController = UIAlertController(title: "No Home Name", message: "Please enter a homename to continue!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            joinHome()
            self.performSegueWithIdentifier("HomeJoinedSegue", sender: nil)
        }
    }
    
    func joinHome()
    {
        // We could check to see if the home exists before we update the user
        let ref = Firebase(url: self.shareData.ROOT_URL + "users/" + self.shareData.currentUserId + "/homeId")
        ref.setValue(homeIdTextBox.text!)
        self.shareData.currentHomeId = homeIdTextBox.text!
    }
}
