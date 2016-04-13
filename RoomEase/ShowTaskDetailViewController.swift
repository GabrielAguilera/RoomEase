//
//  ShowTaskDetailViewController.swift
//  RoomEase
//
//  Created by Jessica Aboukasm on 4/13/16.
//  Copyright © 2016 RoomEase - EECS 441. All rights reserved.
//

import Foundation
import UIKit

class showTaskDetailViewController : UITableViewController {
    
    @IBOutlet weak var taskTitle: UITextField!
    
    @IBOutlet weak var assignedTo: UILabel!
    @IBOutlet weak var pointValue: UITextField!
    @IBAction func cancelToUserViewController(segue:UIStoryboardSegue) {
    }
    
    
}