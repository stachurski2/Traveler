//
//  CoreSubConnection+CoreDataProperties.swift
//  
//
//  Created by Stanisaw Sobczyk on 08/01/2018.
//
//

import Foundation
import CoreData


extension CoreSubConnection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreSubConnection> {
        return NSFetchRequest<CoreSubConnection>(entityName: "CoreSubConnection")
    }

    @NSManaged public var company: String?
    @NSManaged public var end: String?
    @NSManaged public var endDate: String?
    @NSManaged public var endTime: String?
    @NSManaged public var kind: String?
    @NSManaged public var start: String?
    @NSManaged public var startData: String?
    @NSManaged public var startTime: String?
    @NSManaged public var type: String?
    @NSManaged public var owner: CoreConnection?

}
