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
    var name: String?
    var assigner: String?
    var assignee: String?
    var pointVal: Int
    
    init(name: String?, assigner: String?, assignee: String?, points: Int) {
        self.name = name
        self.assigner = assigner
        self.assignee = assignee
        self.pointVal = points
    }
}
