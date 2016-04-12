//
//  WelcomeController.swift
//  RoomEase
//
//  Created by Gabriel Aguilera on 3/19/16.
//  Copyright © 2016 RoomEase - EECS 441. All rights reserved.
//

import CoreData
import Firebase
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
            print("Token found.")
            requestAndStoreUserData()
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
    
    func requestAndStoreUserData() {
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,name,picture.type(large).redirect(false)"], tokenString: FBSDKAccessToken.currentAccessToken().tokenString, version: nil, HTTPMethod: "GET")
        req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
            if(error == nil)
            {
                print("result \(result)")

                // If we're gonna use core data, this is where it'd help!
                let userId = result["id"]! as? String
                self.shareData.currentUserId = userId!
                
                let name = result["name"]! as? String
                self.shareData.currentUser = name!
                
                let userPhotoUrl = result["picture"]?!["data"]?!["url"] as? String
                self.shareData.currentUserPhotoUrl = userPhotoUrl!
                
                // Examine the new data.
                self.checkUserStatus()
            }
            else
            {
                print("error \(error)")
            }
        })
    }
    
    func checkUserStatus() {
        let userId = self.shareData.currentUserId
        let ref = Firebase(url: self.shareData.ROOT_URL + "users/" + userId)
        ref.observeSingleEventOfType(FEventType.Value, withBlock: { snapshot in
            print("Snapshot value: \(snapshot)")
            if snapshot.value is NSNull {
                print("This is a new user to the application.")
                self.createUser()
                // Push the new user object with inHome(false) and then segue
                self.performSegueWithIdentifier("LoggedInNewSegue", sender: nil)
            } else {
                print("This user has been in the application before.")

                // Check if they're in a home already on firebase                
                if snapshot.hasChild("homeId") {
                    print("This user is in already in a home.")
                    self.shareData.currentHomeId = snapshot.value.objectForKey("homeId") as! String
                    self.performSegueWithIdentifier("LoggedInExistingSegue", sender: nil)
                } else {
                    print("This user is not in a home yet.")
                    self.performSegueWithIdentifier("LoggedInNewSegue", sender: nil)
                }
            }
        })
    }
    
    func createUser()
    {
        let data = ["name": self.shareData.currentUser, "photo_url": self.shareData.currentUserPhotoUrl, "points": 0]
        let ref = Firebase(url: self.shareData.ROOT_URL + "users/" + self.shareData.currentUserId)
        ref.setValue(data)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){}
    
    /*
    * Misc
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
}
