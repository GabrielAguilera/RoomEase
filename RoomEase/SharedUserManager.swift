//
//  SharedUserManager.swift
//  RoomEase
//
//  Created by Jessica Aboukasm on 3/8/16.
//  Copyright © 2016 RoomEase - EECS 441. All rights reserved.
//

import Firebase
import Foundation

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
    
    var userSelectedTasks:[String:Int] = [:]
    var roommateRankings:[String:Int] = [
        "Mitch Gildenberg":15,"Lindsay Smith":10, "Jessi Aboukasm":10, "Gabriel Aguilera":20
    ]
    
    var roommateRankingsChanged = false
    var bestRoommate = false
    
    var rootRef = Firebase(url: "https://fiery-heat-3695.firebaseio.com/")
    
//    Usage example
//    -------------
//    ShareData().get_tasks({ (tasks:[NSDictionary]) in
//      //Prints the last task in the task array
//      print(tasks.last!)
//      //x = string (username) of the last task in the array is assigned to (is an optional type)
//      var x:String = String(tasks.last!["assignedTo"])
//    })
    func get_tasks(homeID:String, callback:([NSDictionary]) -> Void) {
        let ref = Firebase(url: "https://fiery-heat-3695.firebaseio.com/tasks")
        // sync down from server
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            var tasks = [NSDictionary]()
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? FDataSnapshot {
                let task = child.value as! NSDictionary
                if (String(task["homeId"]) == homeID){
                    tasks.append(task)
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
    func get_user(username:String, callback:(NSDictionary) -> Void) {
        let ref = Firebase(url: "https://fiery-heat-3695.firebaseio.com/users/" + username)
        ref.observeEventType(.Value, withBlock: { snapshot in
            callback(snapshot.value as! NSDictionary)
        })
    }
    
    //example
    //---------
    //ShareData().add_user_points("mgild", 5)
    func add_user_points(username:String, points_to_add:Int) {
        let ref = Firebase(url: "https://fiery-heat-3695.firebaseio.com/users/" + username)
        ref.observeEventType(.Value, withBlock: { snapshot in
            let user = snapshot.value as! NSDictionary
            let new_points: [String:Int] = ["points": Int(String(user["points"]))! + points_to_add]
            ref.updateChildValues(new_points)
        })
    }
    
    //for some reason could not get the firebase sort to work
    //sorting by value myself
    //currently uses callback that returns an array of tuples (User, score) pairs
    func get_roomate_rankings(homeID:String, callback:([(String, Int)]) -> Void) {
        let ref = Firebase(url: "https://fiery-heat-3695.firebaseio.com/users")
        ref.observeEventType(.Value, withBlock: { snapshot in
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
    
    
    
    //    func get_user_tasks(user:String, callback:([NSDictionary]) -> Void) {
    //        self.get_tasks({(var tasks:[NSDictionary]) in
    //            for (i,_) in tasks.enumerate().reverse() {
    //                if let owner:String = tasks[i]["assignedTo"] as? NSString {
    //
    //                }
    //                if ( != user){
    //                    tasks.removeAtIndex(i)
    //                }
    //            }
    //        })
    //    }
    //
}