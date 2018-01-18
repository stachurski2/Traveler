//
//  CoreConnection+CoreDataProperties.swift
//  
//
//  Created by Stanisaw Sobczyk on 08/01/2018.
//
//

import Foundation
import CoreData


extension CoreConnection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreConnection> {
        return NSFetchRequest<CoreConnection>(entityName: "CoreConnection")
    }

    @NSManaged public var end: String?
    @NSManaged public var endDate: String?
    @NSManaged public var endTime: String?
    @NSManaged public var numberOfChanges: Int16
    @NSManaged public var start: String?
    @NSManaged public var startDate: String?
    @NSManaged public var startTime: String?
    @NSManaged public var timeTravel: String?
    @NSManaged public var hints: NSSet?
    @NSManaged public var intermediateStops: NSSet?
    @NSManaged public var subConections: NSSet?

}

// MARK: Generated accessors for hints
extension CoreConnection {

    @objc(addHintsObject:)
    @NSManaged public func addToHints(_ value: CoreHint)

    @objc(removeHintsObject:)
    @NSManaged public func removeFromHints(_ value: CoreHint)

    @objc(addHints:)
    @NSManaged public func addToHints(_ values: NSSet)

    @objc(removeHints:)
    @NSManaged public func removeFromHints(_ values: NSSet)

}

// MARK: Generated accessors for intermediateStops
extension CoreConnection {

    @objc(addIntermediateStopsObject:)
    @NSManaged public func addToIntermediateStops(_ value: CoreIntermediateStop)

    @objc(removeIntermediateStopsObject:)
    @NSManaged public func removeFromIntermediateStops(_ value: CoreIntermediateStop)

    @objc(addIntermediateStops:)
    @NSManaged public func addToIntermediateStops(_ values: NSSet)

    @objc(removeIntermediateStops:)
    @NSManaged public func removeFromIntermediateStops(_ values: NSSet)

}

// MARK: Generated accessors for subConections
extension CoreConnection {

    @objc(addSubConectionsObject:)
    @NSManaged public func addToSubConections(_ value: CoreSubConnection)

    @objc(removeSubConectionsObject:)
    @NSManaged public func removeFromSubConections(_ value: CoreSubConnection)

    @objc(addSubConections:)
    @NSManaged public func addToSubConections(_ values: NSSet)

    @objc(removeSubConections:)
    @NSManaged public func removeFromSubConections(_ values: NSSet)

}
