//
//  UserViewController.swift
//  RoomEase
//
//  Created by Jessica Aboukasm on 2/25/16.
//  Copyright (c) 2016 RoomEase - EECS 441. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPoints: UILabel!
    @IBOutlet weak var userTaskTable: UITableView!
    
    let shareData = ShareData.sharedInstance

    
    override func viewDidLoad() {
         // Do any additional setup after loading the view, typically from a nib.
        
        userNameLabel.text = self.shareData.currentUser
        if let data = NSData(contentsOfURL: NSURL(fileURLWithPath: "http://graph.facebook.com/\(self.shareData.currentUserId)/picture?type=large")) {
            self.userProfileImage.image = UIImage(data: data)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        userTaskTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.shareData.userSelectedTasks.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let sortedTasks = retrieveTaskRankings()
        let myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)

        let pointValue = String(self.shareData.userSelectedTasks[sortedTasks[indexPath.row]]!)
        let cellText = pointValue + "  |   " + sortedTasks[indexPath.row]
        myCell.textLabel!.text = cellText
        return myCell
    }
    

    func retrieveTaskRankings() -> Array<String> {
        let sortedArray = self.shareData.userSelectedTasks.sort({$0.0 < $1.0})
        let tasks: [String] = sortedArray.map {return $0.0 }
        return tasks
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let sortedTasks = retrieveTaskRankings()
        
        let task = UITableViewRowAction(style: .Normal, title: "Mark as Complete") { action, index in
            print("Completed Button Tapped")
            let pointValue = self.shareData.userSelectedTasks[sortedTasks[indexPath.row]]!
            var pointsNum:Int = (self.userPoints.text! as NSString).integerValue
            
            pointsNum += pointValue
            self.shareData.roommateRankings[self.userNameLabel.text!] = pointsNum
            self.shareData.roommateRankingsChanged = true
            self.shareData.bestRoommate = true // TODO implement logic for determining best roommate
            
            UIView.transitionWithView(self.userPoints, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                    self.userPoints.text = "+" +  String(pointsNum)
                }, completion: {
                    (value: Bool) in
            })
            
                self.shareData.userSelectedTasks.removeValueForKey(sortedTasks[indexPath.row])
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        task.backgroundColor = UIColor.lightGrayColor()
        return [task]
    }
}

extension Dictionary {
    func merge(dict: Dictionary<Key,Value>) -> Dictionary<Key,Value> {
        var mutableCopy = self
        for (key, value) in dict {
            // If both dictionaries have a value for same key, the value of the other dictionary is used.
            mutableCopy[key] = value
        }
        return mutableCopy
    }
}

