//
//  UserViewController.swift
//  RoomEase
//
//  Created by Jessica Aboukasm on 2/25/16.
//  Copyright (c) 2016 RoomEase - EECS 441. All rights reserved.
//

import Firebase
import FBSDKLoginKit
import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FBSDKLoginButtonDelegate  {
    
    // MARK: Properties
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPoints: UILabel!
    @IBOutlet weak var userTaskTable: UITableView!
    
    @IBOutlet weak var fbButton: FBSDKLoginButton!
    
    var shareData = ShareData.sharedInstance
    
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
    
    var localAssignedTasks: [Task] = []
    var currentPoints: Int = 0

    /* Conformation for UIViewController Protocol */
    
    override func viewDidLoad() {
        /*sets label auto size adjustments*/
        userPoints.adjustsFontSizeToFitWidth=true
        userPoints.minimumScaleFactor=0.5
        userNameLabel.adjustsFontSizeToFitWidth=true
        userNameLabel.minimumScaleFactor=0.5
        
        fbButton.delegate = self
        
        // Load up the image
        if let data = NSData(contentsOfURL: NSURL(string: self.shareData.currentUserPhotoUrl)!) {
            userProfileImage.image = UIImage(data: data)!.circle
        }
        
        // Populate the name label
        userNameLabel.text = self.shareData.currentUser
        
        // This reference will persist even after loading the view and update 
        // automatically. We just need to animate when it has changed.
        let pointsRef = Firebase(url: self.shareData.getPointsUrl())
        pointsRef.observeEventType(FEventType.Value, withBlock: { latestPointsSnapshot in
            print("Snapshot value: \(latestPointsSnapshot)")
            self.currentPoints = latestPointsSnapshot.value as! Int
            self.userPoints.text = "+" + String(self.currentPoints)
        })
        
        // Set Firebase up to observe the list of assigned tasks
        let personalTasksRef = Firebase(url: self.shareData.getPersonalTasksUrl())
        personalTasksRef.observeEventType(FEventType.Value, withBlock: { assignedTasks in
            
            // When we get new tasks for the home, clear the ones we have
            self.localAssignedTasks.removeAll()
            
            for task in assignedTasks.children {
                // Rebuild our local copy of the list
                let taskTitle:String = task.value!!.objectForKey("title") as! String
                let taskPoints:Int = task.value!!.objectForKey("points") as! Int
                let taskID:String = task.key!! as String
                
                self.localAssignedTasks.append(
                    Task(title: taskTitle,
                        points: taskPoints,
                        taskId:  taskID))
            }
            
            // Re-sort the list
            self.retrieveTaskRankings()
            
            // Refresh the table
            self.userTaskTable.reloadData()
        })
        
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "stairsLoft.jpg")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imageViewBackground.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        imageViewBackground.addSubview(blurEffectView)
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)

        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        // We should check if their points total has updated since they last 
        // came here and animate the change.
        userTaskTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Conformation for FBSDKLoginDelegate Protocol */
    
    // Shouldn't be called because the user should only be here if they logged in
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {}
    
    // Called after logout button pressed
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        print("Logout complete. Should begin segue.")
        self.performSegueWithIdentifier("LoggedOutSegue", sender: nil)
    }
    
    /* Conformation for UITableViewDelebate Protocol */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.localAssignedTasks.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)

        let pointValue = String(self.localAssignedTasks[indexPath.row].points)
        let cellText = self.localAssignedTasks[indexPath.row].title
        myCell.textLabel!.text = cellText
        myCell.detailTextLabel!.text = pointValue + " points"
        return myCell
    }
    
    // Sorts list of assigned tasks by point value
    func retrieveTaskRankings(){
//        let sortedArray = self.shareData.userSelectedTasks.sort({$0.0 < $1.0})
//        let tasks: [String] = sortedArray.map {return $0.0 }
//        return tasks
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {}
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let task = UITableViewRowAction(style: .Normal, title: "Mark as Complete") { action, index in
            print("Completed Button Tapped")
            
            // Find out your new point total
            let pointsGained = self.localAssignedTasks[indexPath.row].points
            let newPoints = self.currentPoints + pointsGained
            
            // Update it on Firebase
            let pointsRef = Firebase(url: self.shareData.getPointsUrl())
            pointsRef.setValue(newPoints)
            
            // Update it in the UI
            self.currentPoints = newPoints
            
            // Update rankings?
            self.shareData.roommateRankings[self.userNameLabel.text!] = newPoints
            self.shareData.roommateRankingsChanged = true
            self.shareData.bestRoommate = true // TODO implement logic for determining best roommate
            
            // Animate the change
            UIView.transitionWithView(self.userPoints, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                    self.userPoints.text = "+" +  String(newPoints)
                }, completion: {
                    (value: Bool) in
            })
            
            // Remove from Firebase
            let assignedTaskRef = Firebase(url: self.shareData.getPersonalTasksUrl() + "/" + self.localAssignedTasks[indexPath.row].taskId)
            assignedTaskRef.removeValue()
            
            // Remove from local queue
            self.localAssignedTasks.removeAtIndex(indexPath.row)
            
            // Remove from table
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

func maskRoundedImage(image: UIImage, radius: Float) -> UIImage {
    let imageView: UIImageView = UIImageView(image: image)
    var layer: CALayer = CALayer()
    layer = imageView.layer
    
    layer.masksToBounds = true
    layer.cornerRadius = CGFloat(radius)
    
    UIGraphicsBeginImageContext(imageView.bounds.size)
    layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return roundedImage
}

extension UIImage {
    var rounded: UIImage? {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = min(size.height/2, size.width/2)
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}





