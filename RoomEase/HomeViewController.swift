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
    @IBOutlet weak var welcomeHomeLabel: UILabel!
    
    let shareData = ShareData.sharedInstance
    
    struct Task {
        let title : String
        let points : Int
        let taskId : String
        
        init(title: String, points: Int, taskId: String){
            self.title = title
            self.points = points
            self.taskId = taskId
        }
    }
    
    var localTaskList: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskTableView.delegate = self
        
        let username:String = self.shareData.currentUser
        var nameArray = username.componentsSeparatedByString(" ")
        let firstName = nameArray[0]
        
        self.welcomeHomeLabel.text = "Welcome Home \(firstName)!"

        // Comment the line below back in when you need some tasks
//        self.populateTasks()
        
        // Set Firebase up to observe the list of open tasks
        let taskRef = Firebase(url: self.shareData.getHomeTasksUrl())
        taskRef.observeEventType(FEventType.Value, withBlock: { openTasks in
            
            // When we get new tasks for the home, clear the ones we have
            self.localTaskList.removeAll()
            
            for task in openTasks.children {
                // Rebuild our local copy of the list
                
                let taskTitle:String = task.value!!.objectForKey("title") as! String
                let taskPoints:Int = task.value!!.objectForKey("points") as! Int
                let taskID:String = task.key!! as String
                
                self.localTaskList.append(
                    Task(title: taskTitle,
                        points: taskPoints,
                        taskId:  taskID)
                )
            }
            
            // Re-sort the list
            self.retrieveTaskRankings()
            
            // Refresh the table
            self.taskTableView.reloadData()
        })
        
        self.shareData.get_roomate_rankings({(pulled_rankings) in
            for tuple in pulled_rankings {
                self.shareData.roommateRankings[tuple.0] = tuple.1
            }
            self.taskTableView.reloadData()
        })
        self.taskTableView.reloadData()
    }
    
    // Helper function for when I need some tasks in the house.
    func populateTasks() {
        let lTaskList: NSMutableArray = []
        let task1 = ["title": "Clean kitchen after party", "points": 50]
        let task2 = ["title": "Clean upstairs bathroom", "points": 35]
        
        lTaskList.addObject(task1)
        lTaskList.addObject(task2)
        
        let taskRef = Firebase(url: self.shareData.getHomeTasksUrl())
        
        for task in lTaskList {
            let newTaskRef = taskRef.childByAutoId()
            newTaskRef.setValue(task)
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if(self.homeSegmentedControl.selectedSegmentIndex == 0) {
            self.shareData.get_roomate_rankings({(pulled_rankings) in
                for tuple in pulled_rankings {
                    self.shareData.roommateRankings[tuple.0] = tuple.1
                }
                self.taskTableView.reloadData()
            })
            self.taskTableView.reloadData()
            tableUpdateForRoommateRankings()
        }
        taskTableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var returnValue = 0
        switch(homeSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            returnValue = self.shareData.roommateRankings.count
            break
        case 1:
            returnValue = self.localTaskList.count
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
    
    // Called for every index in the UITableView and returns a constructed 
    // UITableViewCell to present to the user
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
//        // Returns a dummy cell if there's more cells visible than there is 
//        // useful data to display.
//        if (indexPath.row >= self.shareData.roommateRankings.count) {
//            return myCell
//        }
        let sortedNames = retrieveRoommateRankings()

        switch(homeSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            let pointValue = String(self.shareData.roommateRankings[sortedNames[indexPath.row]]!)
            let cellText = pointValue + "  |   " + sortedNames[indexPath.row]
            myCell.textLabel!.text = cellText
            addTaskButton.hidden = true
            if(self.shareData.bestRoommate) {
                bestRoommateLabel.hidden = false
            }
            else {
                bestRoommateLabel.hidden = true
            }
            break
            
        case 1:
            let pointValue = String(self.localTaskList[indexPath.row].points)
            let cellText = pointValue + "  |   " + self.localTaskList[indexPath.row].title
            myCell.textLabel!.text = cellText
            addTaskButton.hidden = false
            bestRoommateLabel.hidden = true
            break
            
        default:
            break
        }
        
        return myCell
    }
    
    // The return value of this function determines whether or not a cell
    // will be editable. We only want task cells to have this functionality.
    // This is called by each cell when it is displayed.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if(self.homeSegmentedControl.selectedSegmentIndex == 1) {
            return true
        }
        else {
            return false;
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {}

    // This function is called when you swipe left on a cell and reveals the
    // UITableViewRowAction which in this case is "Add to My Tasks".
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let task = UITableViewRowAction(style: .Normal, title: "Add to My Tasks") { action, index in
            print("Add Task button tapped")
            
            // Add to personal queue
            let personalTasksRef = Firebase(url: self.shareData.getPersonalTasksUrl())
            let newPersonalTaskRef = personalTasksRef.childByAutoId()
            let personalTask = [ "title": self.localTaskList[indexPath.row].title, "points": self.localTaskList[indexPath.row].points]
            newPersonalTaskRef.setValue(personalTask)
            
            // Remove from home queue
            let homeTaskRef = Firebase(url: self.shareData.getHomeTasksUrl() + "/" + self.localTaskList[indexPath.row].taskId)
            homeTaskRef.removeValue()
            
            // Remove from local queue
            self.localTaskList.removeAtIndex(indexPath.row)
            
            // Remove from table
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        task.backgroundColor = UIColor.lightGrayColor()
        
        return [task]
    }
    
    
    @IBAction func segmentedControlActionChanged(sender: AnyObject) {
        if(homeSegmentedControl.selectedSegmentIndex == 0) {
            addTaskButton.hidden = true
        }
        if(homeSegmentedControl.selectedSegmentIndex == 1) {
            addTaskButton.hidden = false
        }
        
        
        if(self.shareData.roommateRankingsChanged) {
            tableUpdateForRoommateRankings()
        }
        else {
            self.taskTableView.reloadData()
        }
    }
    
    // Sorts roommates by current amount of points
    func retrieveRoommateRankings() -> Array<String> {
        let sortedArray = self.shareData.roommateRankings.sort({$0.1 > $1.1})
        let nameList: [String] = sortedArray.map {return $0.0 }
        return nameList
    }

    // Sorts tasks by point value
    func retrieveTaskRankings() {
//        let sortedArray = self.localTaskList.sort({$0.1 > $1.1})
//        let tasks: [String] = sortedArray.map {return $0.0 }
//        return tasks
    }

    // Animation when roommate rankings change
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
    }

    
    // Mark Unwind Segues
    @IBAction func cancelToHomeViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func saveTaskDetail(segue:UIStoryboardSegue) {
        if let taskViewDetailController = segue.sourceViewController as? TaskViewDetailController {
            
            // error handling for duplicate tasks
            if let task = taskViewDetailController.task {
                // Check all the titles
                for existingTask in self.localTaskList {
                    if existingTask.title == task.name {
                        let alert = UIAlertView()
                        alert.title = "Whoops!"
                        alert.message = "We think this is already a task in the house."
                        alert.addButtonWithTitle("Ok")
                        alert.show()
                        return
                    }
                }

                let newTask = ["title": task.name!, "points": task.pointVal]
                let taskRef = Firebase(url: self.shareData.getHomeTasksUrl())
                let newTaskRef = taskRef.childByAutoId()
                newTaskRef.setValue(newTask)
            }
        }
    }
}





