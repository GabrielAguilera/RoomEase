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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var homeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var addTaskButton: UIButton!
    
    let roommateRankings:[String:Int] = [
        "Mitch":15,"Soloway":10
    ]
    
    let taskList:[String:Int] = ["Clean kitchen after party":50, "Clean upstairs bathroom":35, "Pick up toilet paper":15]
    
    var userSelectedTasks:[String:Int]!
    

    //let taskList:[String] = ["Pay Mitch $2.25","Charge Jessi $32.00", "Pay Gabriel $16.75"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            print("Not logged in")
        } else {
            print("Logged in")
        }
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        
        loginButton.delegate = self
        //self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil {
            print("login complete")
//            self.performSegueWithIdentifier("shownew", sender: self)
        } else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var returnValue = 0
        print("inside table view")
        switch(homeSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            returnValue = roommateRankings.count
            break
        case 1:
            returnValue = taskList.count
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
        print("inside cell for row whatever view")
        
        let myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        let sortedNames = retrieveRoommateRankings()
        let sortedTasks = retrieveTaskRankings()
        switch(homeSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            let pointValue = String(roommateRankings[sortedNames[indexPath.row]]!)
            let cellText = pointValue + "  |   " + sortedNames[indexPath.row]
            myCell.textLabel!.text = cellText
            addTaskButton.hidden = true
            break
        case 1:
            let pointValue = String(taskList[sortedTasks[indexPath.row]]!)
            let cellText = pointValue + "  |   " + sortedTasks[indexPath.row]
            myCell.textLabel!.text = cellText
            addTaskButton.hidden = false
            break
            
        default:
            break
            
        }
        
        return myCell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let sortedTasks = retrieveTaskRankings()
        let task = UITableViewRowAction(style: .Normal, title: "Add to My Tasks") { action, index in
            print("Add Task button tapped")
            self.userSelectedTasks[sortedTasks[indexPath.row]] = self.taskList[sortedTasks[indexPath.row]]
        }
        task.backgroundColor = UIColor.lightGrayColor()
        
        return [task]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    @IBAction func segmentedControlActionChanged(sender: AnyObject) {
        
        taskTableView.reloadData()
    }
    
    func retrieveRoommateRankings() -> Array<String> {
        let sortedArray = roommateRankings.sort({$0.0 < $1.0})
        let nameList: [String] = sortedArray.map {return $0.0 }
        return nameList
    }

    func retrieveTaskRankings() -> Array<String> {
        let sortedArray = taskList.sort({$0.0 < $1.0})
        let tasks: [String] = sortedArray.map {return $0.0 }
        return tasks
    }

    
    


}

