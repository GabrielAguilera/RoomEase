//
//  WelcomeController.swift
//  RoomEase
//
//  Created by Gabriel Aguilera on 3/19/16.
//  Copyright © 2016 RoomEase - EECS 441. All rights reserved.
//

import CoreData
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import UIKit

class WelcomeViewController : UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    let shareData = ShareData.sharedInstance

    
    override func viewDidLoad() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.dataController.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "User")
        do {
            let user:NSArray =
            try managedContext.executeFetchRequest(fetchRequest)
            
            if (user.count == 1) {
                print("Existing user found. Logging in with old credentials.")
                self.performSegueWithIdentifier("LoggedInSegue", sender: nil)
            }
            print("No user data was saved to core data.")
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidAppear(animated: Bool) {}
    
    override func didReceiveMemoryWarning() {}
    
    @IBAction func loginPressed(sender: AnyObject) {
        print("Login button pressed.")
        
        let ref = Firebase(url: "https://fiery-heat-3695.firebaseio.com/")
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self, handler: {
            (facebookResult, facebookError) -> Void in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                // Successful login! Store some data then segue.
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        
                        if error != nil {
                            print("Login failed. \(error)")
                            
                        } else {
                            print("Logged in! \(authData)")
                            
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            let managedContext = appDelegate.dataController.managedObjectContext
                            let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedContext)
                            
                            let user = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                            user.setValue(authData.uid, forKey: "uid")
                            user.setValue(authData.providerData["displayName"], forKey: "name")
                            
                            do {
                                try managedContext.save()
                                
                                
                                
                            } catch { print("Couldn't save to core data.") }
                            
//                            user.setValue(authData.token, forKey: "firebaseToken")
//                            print(authData.providerData["profileImageURL"])
//                            print(authData.providerData["displayName"])
//                            print(authData.uid)
//                            print(authData.provider)
                            
                            self.performSegueWithIdentifier("LoggedInSegue", sender: nil)
                        }
                })
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LoggedInSegue" {
            print("Preparing for segue to home view.")
        }
    }
    
    // Functions to implement if we use FBSDKLoginButtonDelegate protocol:
    /* func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
     * func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
     */
}
