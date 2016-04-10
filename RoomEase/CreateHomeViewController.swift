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
    
    @IBAction func createButtonPressed(sender: AnyObject) {
        if homeNameTextBox.text!.isEmpty {
            let alertController = UIAlertController(title: "No Home Name", message: "Please enter a homename to continue!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            
            let newHome = ["members": self.shareData.currentUserId, "name": homeNameTextBox.text!]
            
            // send request to firebase to get a new homecode
            // the slash at the end is super important. If you omit it, you 
            // overwrite the whole endpoint
            let ref = Firebase(url: self.shareData.ROOT_URL + "home/")
            let newHomeRef = ref.childByAutoId()
            newHomeRef.setValue(newHome)
            
            self.shareData.currentHomeId = newHomeRef.key
        }
    }
}
