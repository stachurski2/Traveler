//
//  Entity+CoreDataProperties.swift
//  
//
//  Created by Stanisaw Sobczyk on 16/11/2017.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Point")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: String?
    @NSManaged public var descripton: String?

}
