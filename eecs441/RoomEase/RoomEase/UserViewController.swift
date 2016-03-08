//
//  UserViewController.swift
//  RoomEase
//
//  Created by Jessica Aboukasm on 2/25/16.
//  Copyright (c) 2016 RoomEase - EECS 441. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var userProfileImage: UIImageView!
   
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPoints: UILabel!
    @IBOutlet weak var userTaskTable: UITableView!
    @IBOutlet weak var userTableInfoControl: UISegmentedControl!
    
    
    let privateList:[String] = ["Private item 1","Private item 2"]
    let friendsAndFamily:[String] = ["Friend item 1","Friend item 2", "Friends item 3"]
    let publicList:[String] = ["Public item 1", "Public item 2", "Public item 3", "Public item 4"]
    
  
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
        
        switch(userTableInfoControl.selectedSegmentIndex)
        {
        case 0:
            returnValue = privateList.count
            break
        case 1:
            returnValue = friendsAndFamily.count
            break
            
        default:
            break
            
        }
        
        return returnValue
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
        switch(userTableInfoControl.selectedSegmentIndex)
        {
        case 0:
            myCell.textLabel!.text = privateList[indexPath.row]
            break
        case 1:
            myCell.textLabel!.text = friendsAndFamily[indexPath.row]
            break
            
        default:
            break
            
        }
        
        return myCell
    }
    
    
    @IBAction func segmentedControlActionChanged(sender: AnyObject) {
        
        userTaskTable.reloadData()
    }
    
    
}
