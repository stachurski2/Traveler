//
//  CoreHint+CoreDataProperties.swift
//  
//
//  Created by Stanisaw Sobczyk on 08/01/2018.
//
//

import Foundation
import CoreData


extension CoreHint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreHint> {
        return NSFetchRequest<CoreHint>(entityName: "CoreHint")
    }

    @NSManaged public var hint: String?
    @NSManaged public var number: Int16
    @NSManaged public var owner: CoreConnection?

}
