//
//  CoreConnection.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 09/01/2018.
//  Copyright © 2018 Stanisaw Sobczyk. All rights reserved.
//

import UIKit
import CoreData

class CoreConnections: CoreData {
    
    func fetchData()->[Connection] {
        var cons:[Connection] = []
        if state == .succeded {
            let start = records.count - 1
            
            for index in stride(from: start, to: -1, by: -1) {
                let record = records[index] as! CoreConnection
                let start0 = record.start
                let end = record.end
                let changes = record.numberOfChanges
                let con = Connection(start: start0!, end: end!, changes: Int(changes))
                con.endDate = record.endDate
                con.startDate = record.startDate
                con.startTime = record.startTime
                con.endTime = record.endTime
                con.timeTravel = record.timeTravel
                guard let hints = record.hints else { cons.append(con); return cons}
                con.hints = [Int:String]()
                for hint in hints {
                    let hint = hint as! CoreHint
                    if hint.hint != nil {
                        con.hints?.updateValue(hint.hint!, forKey: Int(hint.number))
                    }
                }
                
                guard let subConections = record.subConections else { cons.append(con); return cons}
                con.subConnections = [SubConnection]()
                
                for index in 0...record.numberOfChanges-1{
                    for sub in subConections {
                        let sub = sub as! CoreSubConnection
                        if sub.connectionNumber == index {
                            let subb = SubConnection()
                            if sub.company != nil {
                                subb.company = sub.company!
                            }
                            if sub.end != nil {
                                subb.end = sub.end!
                            }
                            if sub.start != nil {
                                subb.start = sub.start!
                            }
                            if sub.endDate != nil {
                                subb.endDate = sub.endDate!
                            }
                            if sub.startData != nil {
                                subb.startDate = sub.startData!
                            }
                            if sub.endTime != nil {
                                subb.endTime = sub.endTime!
                            }
                            if sub.startTime != nil {
                                subb.startTime = sub.startTime!
                            }
                            if sub.type != nil {
                                subb.type = sub.type!
                            }
                            if sub.kind != nil {
                                subb.kind = sub.kind!
                            }
                            con.subConnections.append(subb)
                            }
                    }
            }
                
                guard let stops = record.intermediateStops else {cons.append(con); return cons}
                con.intermediateStops = [[Int:[String]]]()
                
                
                
                for index in 0...record.numberOfChanges-1{
                    
                    var numberr = 0
                    var instop = [Int:[String]]()
                     for stop in stops {
                       let stop = stop as! CoreIntermediateStop
                        if stop.pontName != nil && stop.pointDeparture != nil && stop.pointDate != nil && stop.connectionNumber == index && stop.number > numberr {
                          // print("Connection number \(stop.connectionNumber), \(stop.number), \(stop.pontName!), \(stop.pointDeparture)")
                            numberr = Int(stop.number)
                    
                        }
                        
                      
                    }
                    for index0 in 0...numberr {
                        for stop in stops {
                             let stop = stop as! CoreIntermediateStop
                            if stop.pontName != nil && stop.pointDeparture != nil && stop.pointDate != nil && stop.connectionNumber == index && stop.number == index0 {
                                
                                instop.updateValue([stop.pontName!, stop.pointDeparture!, stop.pointDate!], forKey: Int(stop.number))
                                print("Connection number \(stop.connectionNumber), \(stop.number), \(stop.pontName!), \(stop.pointDeparture!)")
                                
                            }
                        }
                    
                        
                        
                        
                        
                    }
                    con.intermediateStops?.append(instop)
                }
               
                
                    
                    
                
                
                        
                      //
                
            
                 
                    
               
                    
                    
                
                
                
                cons.append(con)
            }
        }
        return cons
    }
    
    
    func deleteConnection(indexNumber:Int)->Void{
        do {
            guard let managedContext = managedContext else {throw saveErr.entityError}
            if(indexNumber>records.count){ throw saveErr.entityError}
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreConnection")
            let results = try managedContext.fetch(fetchRequest)
            managedContext.delete(results[indexNumber])
            try managedContext.save()
            records.remove(at: indexNumber)
        }
        catch  {
            let error = error as NSError
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
    
    
}
