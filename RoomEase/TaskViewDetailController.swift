//
//  TaskViewDetailController.swift
//  RoomEase
//
//  Created by Jessica Aboukasm on 3/19/16.
//  Copyright © 2016 RoomEase - EECS 441. All rights reserved.
//

import Foundation
import UIKit

class TaskViewDetailController: UITableViewController {
    
    var task:Task?
    let shareData = ShareData.sharedInstance
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var pointTextField: UITextField!
    
    
    required init?(coder aDecoder: NSCoder) {
        print("init PlayerDetailsViewController")
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("deinit PlayerDetailsViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            nameTextField.becomeFirstResponder()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveTaskDetail" {
            task = Task(name: nameTextField.text, assigner:shareData.currentUser, assignee: "", points: 5)            
        }
//        if segue.identifier == "PickRoommate" {
//            if let RoommatePickerViewController = segue.destinationViewController as? RoommatePickerViewController {
//                RoommatePickerViewController.selectedRoommate = assignee
//            }
//        }
    }
}
