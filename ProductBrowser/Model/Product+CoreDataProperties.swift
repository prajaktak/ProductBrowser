//
//  Product+CoreDataProperties.swift
//  ProductBrowser
//
//  Created by Prajakta Kulkarni on 03/07/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//
//

import Foundation
import CoreData

extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var category: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var imageURL: String?
    @NSManaged public var itemsRemaining: Int16
    @NSManaged public var name: String?
    @NSManaged public var productDescription: String?

}
