//
//  CustomTabBarController.swift
//  RoomEase
//
//  Created by Gabriel Aguilera on 4/5/16.
//  Copyright © 2016 RoomEase - EECS 441. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        let fbInstalled = UIApplication.sharedApplication().canOpenURL(NSURL(string: "fb-messenger://")!)
        
        if fbInstalled {
            let messengerView = ChatViewController()
            let messengerItem = UITabBarItem(title: "Messenger", image: UIImage(named: "Messenger"), selectedImage: UIImage(named: "Messenger"))
            messengerView.tabBarItem = messengerItem
            self.viewControllers?.insert(messengerView, atIndex: 1)
        }
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.title == "Messenger" {
            print("Messenger button was pressed.")
            UIApplication.sharedApplication().openURL(NSURL(string: "fb-messenger://")!)
        } else {
            print("Regular tab selected.")
        }
    }
}