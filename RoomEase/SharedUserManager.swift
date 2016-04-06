//
//  SharedUserManager.swift
//  RoomEase
//
//  Created by Jessica Aboukasm on 3/8/16.
//  Copyright © 2016 RoomEase - EECS 441. All rights reserved.
//

import Firebase
import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class ShareData {
    
    class var sharedInstance: ShareData {
        struct Static {
            static var instance: ShareData?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ShareData()
        }
        
        return Static.instance!
    }
    
    
    

    let ROOT_URL:String = "https://fiery-heat-3695.firebaseio.com/"
    var userSelectedTasks:[String:Int] = [:]
    var roommateRankings:[String:Int] = [
        "Mitch Gildenberg":15,"Lindsay Smith":10, "Jessi Aboukasm":10, "Gabriel Aguilera":20
    ]
    
    var roommateRankingsChanged = false
    var bestRoommate = false
    var currentUser:String = ""
    var currentUserId:String = ""
    var currentUserPhotoUrl:String = ""
    
    var taskList:[String:Int] = ["Clean kitchen after party":50, "Clean upstairs bathroom":35]
    var rootRef = Firebase(url: "https://fiery-heat-3695.firebaseio.com/")
    
    
    func getUserFacebookName() -> String? {
        var username:String?
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: FBSDKAccessToken.currentAccessToken().tokenString, version: nil, HTTPMethod: "GET")
        req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
            if(error == nil)
            {
                print("result \(result)")
                let callMeMaybe = result["name"]! as? String?
                username = callMeMaybe!!
                print("returning the user name as: \(username!)")
                
            }
            else
            {
                print("error \(error)")
            }
        })
        return username
    }
    

    
    
//    Usage example
//    -------------
//    ShareData().get_open_tasks("home1", callback: { (openTasks:[String:NSDictionary]) in
//        print(openTasks)
//    })
    func get_open_tasks(homeID:String, callback:([String:NSDictionary]) -> Void) {
        let ref = Firebase(url: self.ROOT_URL + "tasks")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var tasks = [String:NSDictionary]()
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? FDataSnapshot {
                let task = child.value as! NSDictionary
                if (String(task["homeId"]!) == homeID && task["assignedTo"] == nil){
                    tasks[child.key!] = task
                }
            }
            callback(tasks)
        })
    }
    
//    Gives tasks as (unique_key, dictionary)
//    Usage example
//    -------------
//    ShareData().get_user_tasks("mgild", callback: { (tasks:[String: NSDictionary]) in
//        print(tasks)
//    })
    func get_user_tasks(username:String, callback:([String: NSDictionary]) -> Void) {
        let ref = Firebase(url: self.ROOT_URL + "tasks")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var tasks = [String: NSDictionary]()
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? FDataSnapshot {
                let task = child.value as! NSDictionary
                if (task["assignedTo"] != nil && String(task["assignedTo"]!) == username){
                    tasks[child.key!] = task
                }
            }
            callback(tasks)
        })
    }
    
    
    //    Usage example
    //    -------------
    //    ShareData().get_user("mgild,{ (user:NSDictionary) in
    //      //Prints the last task in the task array
    //      print(user!)
    //    })
    //TODO: Username should likely be switched to FacebookID
    func get_user(fbid:String, callback:(NSDictionary) -> Void) {
        let ref = Firebase(url: self.ROOT_URL + "users/" + fbid)
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if (!snapshot.exists()) {
                //gives empty dictionary if user does not exist
                callback(NSDictionary())
            } else {
                callback(snapshot.value as! NSDictionary)
            }
        })
    }
    
    //example
    //---------
    //ShareData().add_user_points("mgild", points_to_add: 5)
    func add_user_points(username:String, points_to_add:Int) {
        let ref = Firebase(url: self.ROOT_URL + "users/" + username)
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let user = snapshot.value as! NSDictionary
//           AnyObject to String to int conversion below (dont know how to do Anyobject to int)
            let new_points: [String:Int] = ["points": Int(String(user["points"]!))! + points_to_add]
            ref.updateChildValues(new_points)
        })
    }
    
    //for some reason could not get the firebase sort to work
    //sorting by value myself
    //currently uses callback that returns an array of tuples (User, score) pairs
    //example call
    //-----------
//  ShareData().get_roomate_rankings("home1", callback: { (roomates:[(String,Int)]) in
//      print(roomates)
//  })
    func get_roomate_rankings(homeID:String, callback:([(String, Int)]) -> Void) {
        let ref = Firebase(url: self.ROOT_URL + "users")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var roomate_scores = [String:Int]()
            //This loop builds the array from the Firebase snap
            for item in snapshot.children {
                let user = item as! FDataSnapshot
                
                let user_home = String(user.childSnapshotForPath("homeId").value)
                if (homeID == user_home) {
                    //get the username from the tuple
                    let user_name = user.key
                    //get the users points from the child value
                    let user_points = Int(String(user.childSnapshotForPath("points").value))
                    roomate_scores[user_name] = user_points
                }
            }
            //function for sorting by value
            let byValue = {
                (elem1:(key: String, val: Int), elem2:(key: String, val: Int))->Bool in
                if elem1.val > elem2.val {
                    return true
                } else {
                    return false
                }
            }
            //sorts roomates by value
            let sorted_roomate_scores = roomate_scores.sort(byValue)
            callback(sorted_roomate_scores)
        })
    }
    
    
    //example usage:
    //-------------
    //ShareData().push_user("test_user", values: ["fid":"111111", "name": "Testy McTester", "photo_url": "https://img0.etsystatic.com/028/0/6829852/il_570xN.638618646_4qjl.jpg","homeId":"home2"])
    func push_user(username:String, var values:[String:String]) {
        let ref = Firebase(url: self.ROOT_URL + "users")
        //TODO: throw error here
        if (values["username"] == nil || values["homeId"] == nil || values["name"] == nil || values["photo_url"] == nil) {
            assert(false)
        }
        values["points"] = "0"
        ref.childByAppendingPath(username).setValue(values)
    }
    
    
    //example usage:
    //--------------
    //ShareData().push_task(["homeId":"home1", "points": "5", "title": "test"])
    func push_task(var values:[String:String]) {
        let ref = Firebase(url: self.ROOT_URL + "tasks")
        //TODO: throw error here
        if (values["homeId"] == nil || values["points"] == nil || values["title"] == nil) {
            assert(false)
        }
        //automatically creates a unique ID for the task
        ref.childByAutoId().setValue(values)
    }
    

    //example usage:
    //--------------
    //ShareData().assign_task("-KESJq2Rxv8AhbIjjDNE", user: "mgild")
    func assign_task(task_key:String, user:String) {
        let ref = Firebase(url: self.ROOT_URL + "tasks/" + task_key)
        ref.updateChildValues(["assignedTo": user])
    }
}