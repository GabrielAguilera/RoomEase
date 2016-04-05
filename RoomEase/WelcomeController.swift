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
    
    /*
     * Conformation for UIView Controller 
     */
    override func viewDidLoad() {
        super.viewDidLoad()

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
            print("No token found.")
        } else{
            print("Token found. Starting segue.")
            self.performSegueWithIdentifier("LoggedInSegue", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {}
    
    /*
     * Conformation for FBSDKLoginDelegate Protocol 
     */
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil {
            print("Log in successful.")
        } else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){}
    
    /*
     * Misc
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LoggedInSegue" {
            print("Preparing for segue to home view.")
        }
    }
    
}
