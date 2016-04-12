//
//  Task.swift
//  RoomEase
//
//  Created by Jessica Aboukasm on 3/19/16.
//  Copyright © 2016 RoomEase - EECS 441. All rights reserved.
//

import Foundation

import UIKit


struct Task {
    let title : String
    var assignee: String = ""
    let points : Int
    let taskId : String
    
    init(title: String, assignee: String, points: Int, taskId: String){
        self.title = title
        self.assignee = assignee
        self.points = points
        self.taskId = taskId
    }
}
    