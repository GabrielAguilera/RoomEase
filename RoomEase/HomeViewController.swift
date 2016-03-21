//
//  HomeViewController.swift
//  RoomEase
//
//  Created by Jessica Aboukasm on 2/25/16.
//  Copyright (c) 2016 RoomEase - EECS 441. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var homeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var bestRoommateLabel: UILabel!
    
    let shareData = ShareData.sharedInstance
    let facebookLogin = FBSDKLoginManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskTableView.delegate = self
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if(self.shareData.roommateRankingsChanged && self.homeSegmentedControl.selectedSegmentIndex == 0) {
            tableUpdateForRoommateRankings()
        }
        else {
            taskTableView.reloadData()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var returnValue = 0
        print("inside table view")
        switch(homeSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            returnValue = self.shareData.roommateRankings.count
            break
        case 1:
            returnValue = self.shareData.taskList.count
            break
            
        default:
            break
            
        }
        
        return returnValue
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        var sortedNames = [String]()
        let sortedTasks = retrieveTaskRankings()
        switch(homeSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            let ref = Firebase(url: "https://fiery-heat-3695.firebaseio.com/users")
            ref.observeEventType(.Value, withBlock: { snapshot in
                var roomate_scores = [String:Int]()
                //This loop builds the array from the Firebase snap
                for item in snapshot.children {
                    let user = item as! FDataSnapshot
                    //get the username from the tuple
                    let user_name = user.key
                    //get the users points from the child value
                    let user_points = Int(String(user.childSnapshotForPath("points").value))
                    roomate_scores[user_name] = user_points
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
                //converts dict to string array to be inserted into ist view
                for (key, value) in sorted_roomate_scores {
                    sortedNames.append("\(key)  |   \(value)")
                }
                
                //inserts the strings into cells in listview
                let cellText = sortedNames[indexPath.row]
                myCell.textLabel!.text = cellText
                self.addTaskButton.hidden = true
            })

            break
        case 1:
            let pointValue = String(self.shareData.taskList[sortedTasks[indexPath.row]]!)
            let cellText = pointValue + "  |   " + sortedTasks[indexPath.row]
            myCell.textLabel!.text = cellText
            addTaskButton.hidden = false
            bestRoommateLabel.hidden = true
            break
            
        default:
            break
            
        }
        
        return myCell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if(self.homeSegmentedControl.selectedSegmentIndex == 1) {
            return true
        }
        else {
            return false;
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let sortedTasks = retrieveTaskRankings()
        let task = UITableViewRowAction(style: .Normal, title: "Add to My Tasks") { action, index in
            print("Add Task button tapped")
            self.shareData.userSelectedTasks[sortedTasks[indexPath.row]] = self.shareData.taskList[sortedTasks[indexPath.row]]
            self.shareData.taskList.removeValueForKey(sortedTasks[indexPath.row])
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        task.backgroundColor = UIColor.lightGrayColor()
        
        return [task]
    }
    
    
    @IBAction func segmentedControlActionChanged(sender: AnyObject) {
        if(self.shareData.roommateRankingsChanged) {
            tableUpdateForRoommateRankings()
        }
        else {
            self.taskTableView.reloadData()
        }
    }
    
    func retrieveRoommateRankings() -> Array<String> {
        let sortedArray = self.shareData.roommateRankings.sort({$0.1 > $1.1})
        let nameList: [String] = sortedArray.map {return $0.0 }
        return nameList
    }

    func retrieveTaskRankings() -> Array<String> {
        let sortedArray = self.shareData.taskList.sort({$0.1 > $1.1})
        let tasks: [String] = sortedArray.map {return $0.0 }
        return tasks
    }

    func tableUpdateForRoommateRankings() {
            UIView.transitionWithView(taskTableView,
                duration:1.2,
                options:.TransitionCrossDissolve,
                animations:
                { () -> Void in
                    self.taskTableView.reloadData()
                },
                completion: nil);
            shareData.roommateRankingsChanged = false
        if(self.homeSegmentedControl.selectedSegmentIndex == 0 && self.shareData.bestRoommate) {
            bestRoommateLabel.hidden = false
            self.shareData.bestRoommate = false
        }
    }

    
    // Mark Unwind Segues
    @IBAction func cancelToHomeViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func saveTaskDetail(segue:UIStoryboardSegue) {
        if let taskViewDetailController = segue.sourceViewController as? TaskViewDetailController {
            
            // error handling for duplicate tasks
            if let task = taskViewDetailController.task {
                if((self.shareData.taskList[task.name!]) != nil) {
                    let alert = UIAlertView()
                    alert.title = "Whoops!"
                    alert.message = "We think this is already a task in the house."
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                }
                else {
                    self.shareData.taskList[task.name!] = task.pointVal
                    //update the tableView
                    let indexPath = NSIndexPath(forRow: self.shareData.taskList.count-1, inSection: 0)
                taskTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        }
    }

    
    
    
    
}





