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
    var currentUser = "Lindsay Smith"
    
    var taskList:[String:Int] = ["Clean kitchen after party":50, "Clean upstairs bathroom":35]

    
    
    var rootRef = Firebase(url: "https://fiery-heat-3695.firebaseio.com/")
}