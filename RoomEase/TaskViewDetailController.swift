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
    var assignee:String = ""
    let shareData = ShareData.sharedInstance
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var pointTextField: UITextField!
    
    
    required init?(coder aDecoder: NSCoder) {
        print("init TaskDetails")
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("deinit TaskDetails")
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
        if segue.identifier == "PickRoommate" {
            print("ENTERED THE PICKROOMMATE SEGUE")
            if let RoommatePickerViewController = segue.destinationViewController as? RoommatePickerViewController {
                RoommatePickerViewController.selectedRoommate = assignee
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "SaveTaskDetail" {
            if(nameTextField.text == "") {
                let alert = UIAlertView()
                alert.title = "Whoa there!"
                alert.message = "You can't assign a blank task."
                alert.addButtonWithTitle("Ok")
                alert.show()
                return false
            }
            else if(pointTextField.text == "") {
                let alert = UIAlertView()
                alert.title = "Whoops!"
                alert.message = "Please assign a point value to this task."
                alert.addButtonWithTitle("Ok")
                alert.show()
                return false
            }
            task = Task(name: nameTextField.text, assigner:self.shareData.currentUser, assignee: self.assignee, points: Int(pointTextField.text!)!)
            return true
        }
        else if(identifier == "PickRoommate") {
            print("going to prepare pickRoommate segue")
            
            performSegueWithIdentifier("PickRoommate", sender: self)
        }

        
        
        
        return false
    }







} // TaskDetailViewController



