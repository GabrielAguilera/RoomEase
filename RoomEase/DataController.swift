//
//  DataController.swift
//  RoomEase
//
//  Created by Gabriel Aguilera on 3/20/16.
//  Copyright © 2016 RoomEase - EECS 441. All rights reserved.
//

// Core Data Object
// 
// Example Usage:
//      let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.dataController.managedObjectContext
//        let fetchRequest = NSFetchRequest(entityName: "User")
//        do {
//            let user:NSArray =
//            try managedContext.executeFetchRequest(fetchRequest)
//
//            if (user.count == 1) {
//                print("Existing user found. Logging in with old credentials.")
//                self.performSegueWithIdentifier("LoggedInSegue", sender: nil)
//            }
//            print("No user data was saved to core data.")
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }

import UIKit
import CoreData
class DataController: NSObject {
    var managedObjectContext: NSManagedObjectContext
    override init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = NSBundle.mainBundle().URLForResource("RoomEaseData", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let docURL = urls[urls.endIndex-1]
            /* The directory the application uses to store the Core Data store file.
            This code uses a file named "DataModel.sqlite" in the application's documents directory.
            */
            let storeURL = docURL.URLByAppendingPathComponent("RoomEase.sqlite")
            do {
                try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
}