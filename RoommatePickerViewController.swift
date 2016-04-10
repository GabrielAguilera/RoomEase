//
//  RoommatePickerViewController.swift
//  RoomEase
//
//  Created by Jessica Aboukasm on 4/8/16.
//  Copyright © 2016 RoomEase - EECS 441. All rights reserved.
//

import Foundation
import UIKit


let shareData = ShareData.sharedInstance

class RoommatePickerViewController: UITableViewController {

var roommates = Array(shareData.roommateRankings.keys)
    
var selectedRoommate:String? {
didSet {
    if(selectedRoommate != "") {
        if let roommate = selectedRoommate {
        selectedRoommateIndex = roommates.indexOf(roommate)!
        }
    }
    }
}
var selectedRoommateIndex:Int?

// MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roommates.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RoommateCell", forIndexPath: indexPath)
        cell.textLabel?.text = roommates[indexPath.row]
        
        if indexPath.row == selectedRoommateIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedRoommateIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedRoommate = roommates[indexPath.row]
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveSelectedRoommate" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                if let index = indexPath?.row {
                    selectedRoommate = roommates[index]
                }
            }
        }
    }
}
