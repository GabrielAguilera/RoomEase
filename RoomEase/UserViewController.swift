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
    @IBOutlet weak var userTableInfoControl: UISegmentedControl!
    
    let moneyList:[String] = ["Pay Mitch $2.25","Charge Jessi $32.00", "Pay Gabriel $16.75"]
    
    let taskList:[String:Int] = ["Clean kitchen after party":50, "Clean upstairs bathroom":35, "Pick up toilet paper":15]
    
  
    override func viewDidLoad() {
         // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var returnValue = 0
        print("inside table view")
        switch(userTableInfoControl.selectedSegmentIndex)
        {
        case 0:
            returnValue = taskList.count
            break
        case 1:
            returnValue = moneyList.count
            break
            
        default:
            break
            
        }
        
        return returnValue
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let sortedTasks = retrieveTaskRankings()
        let myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
        switch(userTableInfoControl.selectedSegmentIndex)
        {
        case 0:
            let pointValue = String(taskList[sortedTasks[indexPath.row]]!)
            let cellText = pointValue + "  |   " + sortedTasks[indexPath.row]
            myCell.textLabel!.text = cellText
            break

        case 1:
            myCell.textLabel!.text = moneyList[indexPath.row]
            break
            
        default:
            break
            
        }
        
        myCell.textLabel!.textColor = UIColor.whiteColor()
        
        return myCell
    }
    
    
    @IBAction func segmentedControlActionChanged(sender: AnyObject) {
        
        userTaskTable.reloadData()
    }
    
    func retrieveTaskRankings() -> Array<String> {
        let sortedArray = taskList.sort({$0.0 < $1.0})
        let tasks: [String] = sortedArray.map {return $0.0 }
        return tasks
    }
    
    
}
