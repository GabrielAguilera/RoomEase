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
        if segue.identifier == "PickRoommate" {
            assignee = "Jessi Aboukasm"
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
            else if(identifier == "PickRoommate") {
                performSegueWithIdentifier("PickRoommate", sender: self)
            }
            task = Task(name: nameTextField.text, assigner:self.shareData.currentUser, assignee: self.assignee, points: Int(pointTextField.text!)!)
            return true
        }
        return false
    }







} // TaskDetailViewController



