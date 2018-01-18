//
//  CoreData.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 03/01/2018.
//  Copyright © 2018 Stanisaw Sobczyk. All rights reserved.
//

import UIKit
import CoreData

enum saveErr:Error{
    case delegateError,entityError,wrappingError
    
    func type()->String {
        switch self{
        case .delegateError: return "DelegateError"
        case .entityError: return "entityError"
        case .wrappingError: return "Wrapping error"
        }
        
    }
}


enum CoreDataStatus:Int {
    case failed, succeded
}

class CoreData {
    var state:CoreDataStatus = .failed
    var managedContext:NSManagedObjectContext?
    var records = [NSManagedObject]()
    
    init(_ entityName:String){
        do {
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                throw saveErr.delegateError
            }
            self.managedContext = delegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            guard let record = try managedContext?.fetch(fetchRequest) else {
                throw  saveErr.entityError
            }
            self.records = record
            state = .succeded
        }
            
        catch {
            let error = error as! saveErr
            print("Error during CoreData initialization: \(error.type())")
        }
        
    }
    
    func clearData(_ entityName:String){
        do {
            guard let managedContext = managedContext else {throw saveErr.entityError}
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            fetchRequest.includesPropertyValues = false
            let results = try managedContext.fetch(fetchRequest)
            for result in results {
                managedContext.delete(result)
            }
            try managedContext.save()
            records.removeAll()
        }
        catch  {
            let error = error as NSError
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func count()->Int {
        return records.count
    }
    
    
    
}
