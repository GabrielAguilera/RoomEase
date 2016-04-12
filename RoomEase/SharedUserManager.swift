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
    var roommateRankings: [String:Int] = [:]
    
    var roommateIDs: [String:String] = [:]
    
    
    var roommateRankingsChanged = false
    var bestRoommate = false
    var currentUser:String = ""
    var currentUserId:String = ""
    var currentUserPhotoUrl:String = ""
    var currentHomeId:String = ""
        
    func getPointsUrl() -> String {
        return ROOT_URL + "users/" + currentUserId + "/points"
    }
    
    func getPersonalTasksUrl() -> String {
        return ROOT_URL + "users/" + currentUserId + "/tasks"
    }
    
    func getAnotherUsersTaskUrl(roommateName : String) -> String {
        return ROOT_URL + "users/" + roommateIDs[roommateName]! + "/tasks"
    }

    func getHomeTasksUrl() -> String {
        return ROOT_URL + "home/" + currentHomeId + "/tasks"
    }
    
    //for some reason could not get the firebase sort to work
    //sorting by value myself
    //currently uses callback that returns an array of tuples (User, score) pairs
    //example call
    //-----------
//  ShareData().get_roomate_rankings("home1", callback: { (roomates:[(String,Int)]) in
//      print(roomates)
//  })
    func get_roomate_rankings(callback:([(String, Int)]) -> Void) {
        self.roommateRankings.removeAll()
        let ref = Firebase(url: self.ROOT_URL + "users")
        ref.observeEventType(.Value, withBlock: { snapshot in
           // var roomate_scores = [String:Int]()
            //This loop builds the array from the Firebase snap
            for item in snapshot.children {
                let user = item as! FDataSnapshot
                
                let user_home = String(user.childSnapshotForPath("homeId").value)
                if (self.currentHomeId == user_home) {
                    //get the username from the tuple
                    let user_points = Int(String(user.childSnapshotForPath("points").value))
                    let userName = String(user.childSnapshotForPath("name").value)
                    let userID = String(user.key)
                    self.roommateIDs[userName] = userID
                    self.roommateRankings[userName] = user_points
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
            let sorted_roomate_scores = self.roommateRankings.sort(byValue)
            callback(sorted_roomate_scores)
        })
    }
    
    //example usage:
    //--------------
    //ShareData().push_task(["homeId":"home1", "points": "5", "title": "test"])
    func push_task(values:[String:String]) {
        let ref = Firebase(url: self.ROOT_URL + "tasks")
        //TODO: throw error here
        if (values["homeId"] == nil || values["points"] == nil || values["title"] == nil) {
            assert(false)
        }
        //automatically creates a unique ID for the task
        ref.childByAutoId().setValue(values)
    }
}