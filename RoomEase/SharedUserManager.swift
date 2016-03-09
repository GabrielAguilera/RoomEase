//
//  SharedUserManager.swift
//  RoomEase
//
//  Created by Jessica Aboukasm on 3/8/16.
//  Copyright © 2016 RoomEase - EECS 441. All rights reserved.
//

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
    
}