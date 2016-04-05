//
//  WelcomeController.swift
//  RoomEase
//
//  Created by Gabriel Aguilera on 3/19/16.
//  Copyright © 2016 RoomEase - EECS 441. All rights reserved.
//

import CoreData
import FBSDKLoginKit
import UIKit

class WelcomeViewController : UIViewController, FBSDKLoginButtonDelegate {
    
    let shareData = ShareData.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Remove when a logout button has been added to profile page
        FBSDKLoginManager().logOut()
        
        let fbBtn = FBSDKLoginButton()
        fbBtn.readPermissions = ["public_profile", "email", "user_friends"]
        fbBtn.center = self.view.center
        fbBtn.delegate = self
        self.view.addSubview(fbBtn)
    }
    
    // We should wait until the view has actually appeared before we check login
    // status and segue
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            print("Not logged in")
        } else {
            print("Logged in")
            self.performSegueWithIdentifier("LoggedInSegue", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LoggedInSegue" {
            print("Preparing for segue to home view.")
        }
    }
    
    // Functions to conform to FBSDKLoginDelegate protocol
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {}
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){}
}
