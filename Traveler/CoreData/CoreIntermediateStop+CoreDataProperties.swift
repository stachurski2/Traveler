//
//  CoreIntermediateStop+CoreDataProperties.swift
//  
//
//  Created by Stanisaw Sobczyk on 08/01/2018.
//
//

import Foundation
import CoreData


extension CoreIntermediateStop {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreIntermediateStop> {
        return NSFetchRequest<CoreIntermediateStop>(entityName: "CoreIntermediateStop")
    }

    @NSManaged public var number: Int16
    @NSManaged public var pontName: String?
    @NSManaged public var pointDeparture: String?
    @NSManaged public var pointDate: String?
    @NSManaged public var owner: CoreConnection?

}
