//
//  CoreDataManager.swift
//  ProductBrowser
//
//  Created by Prajakta Kulkarni on 29/06/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    static let sharedInstance = CoreDataManager()
    var persistentContainer: NSPersistentContainer
    var managedObjectContext: NSManagedObjectContext
    private override init() {
        persistentContainer = {
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
             */
            let container = NSPersistentContainer(name: "ProductBrowser")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // swiftlint:disable line_length
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    //// swiftlint:enable line_length
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     // swiftlint:disable next line_length
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                } else {
                    print(storeDescription)
                }
            })
            return container
        }()
        managedObjectContext =  persistentContainer.viewContext
    }

    func createPhotoEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = managedObjectContext
        if let productEntity = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as? Product {
            productEntity.name = dictionary["name"] as? String
            productEntity.category = dictionary["category"] as? String
            productEntity.imageURL =  dictionary["image_url"] as? String
            if (productEntity.imageURL?.isEmpty)! {
                print("URL not present")
            } else {
                let http = URL(string: productEntity.imageURL!)
                var components =  URLComponents(url: http!, resolvingAgainstBaseURL: false)
                components?.scheme = "https"
                let https =  components?.url
                productEntity.imageURL =  https?.absoluteString
            }
            if let remainingItems = dictionary["items_remaining"] as? NSNumber {
                productEntity.itemsRemaining = remainingItems.int16Value
            }
            productEntity.productDescription = dictionary["description"] as? String
            return productEntity
        }
        return nil
    }
    func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = CoreDataManager.sharedInstance.persistentContainer.viewContext.deletedObjects
        _ = array.map {self.createPhotoEntityFrom(dictionary: $0)}
        do {
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    func clearData() {
        do {
            let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map {$0.map {context.delete($0)}}
                CoreDataManager.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
