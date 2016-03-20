//
//  WelcomeController.swift
//  RoomEase
//
//  Created by Gabriel Aguilera on 3/19/16.
//  Copyright © 2016 RoomEase - EECS 441. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import UIKit

class WelcomeViewController : UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
        
    override func viewDidLoad() {}
    
    override func viewDidAppear(animated: Bool) {}
    
    override func didReceiveMemoryWarning() {}
    
    @IBAction func loginPressed(sender: AnyObject) {
        print("Login button pressed.")
        
        let ref = Firebase(url: "https://fiery-heat-3695.firebaseio.com/")
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self, handler: {
            (facebookResult, facebookError) -> Void in
            
            if facebookError != nil {
                
            } else if facebookResult.isCancelled {
                
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        
                        if error != nil {
                            print("Login failed. \(error)")
                            
                        } else {
                            print("Logged in! \(authData)")
                        }
                })
            }
        })
    }
}
