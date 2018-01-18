//
//  Connection.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 27/10/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Connection  {
    

    
    
    var start:String?
    var end:String?
    var numberOfChanges: Int?
    var startTime:String?
    var endTime:String?
    var startDate:String?
    var endDate:String?
    var timeTravel: String?
    var link:String?
    var detailid:String?
    var hints:[Int:String]?
    var intermediateStops:[[Int:[String?]]]?
    var subConnections:[SubConnection] = [SubConnection]()
    
    
    init(start:String, end:String, changes: Int){
        self.start = start
        self.end = end
        self.numberOfChanges = changes
    }
    
    func defineTime(startTime:String, endTime:String, startDate:String, endDate:String,_ timeTravel:String = "test")->Void {
         self.startTime = startTime
         self.endTime = endTime
         self.startDate = startDate
         self.endDate = endDate
         self.timeTravel = timeTravel
    }
    
    func defineLink(link:String)->Void{
        self.link = link
    }
    
    func addSubConnection( _ start:String, _ end:String, _ type:String)->Void {
        let subConnection  = SubConnection()
        subConnection.start = start
        subConnection.end = end
        subConnection.type = type
        subConnections.append(subConnection)
    }
    
    func getSubConnection(_ i:Int)->SubConnection{
        if i < subConnections.count {
            return subConnections[i]
        }
        else {
            let subConnection = SubConnection()
            subConnection.start = "ERR"
            subConnection.end = "ERR"
            subConnection.type = "ERR"
            
            return subConnection
        }
    }
    
    
    func getDetail(_ controller:ResultViewController?)->Void {
        let queue = DispatchQueue(label: "DetailFetch")
        let mainqueue = DispatchQueue.main
        queue.async {
        if controller != nil {
            mainqueue.sync {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        controller?.showLoadingComunicate()        }
            }}
     
        let networking = DetailFetch()
     
            let result = networking.getDetail(self.link, self.detailid)
        
        if result == "result unavailable" {
            if controller != nil {
                mainqueue.sync {
                    controller?.hideLoadingComunicate()
                    controller?.showError("Detail is unavailable") }
            }
        }
        else {
            
        let detail = Details(htmlContent: result)
            self.subConnections = detail.getSubs()
            self.hints = detail.getHints()
            self.intermediateStops = detail.getIntStops()
            self.updateSubconections(self.subConnections)
         if controller != nil && self.subConnections.count > 0 {
                mainqueue.sync {
                    controller?.hideLoadingComunicate()
                    controller?.performSegue(withIdentifier:"showDetails", sender: self)
                }
            }
        }
       
        }
    }
    
    
    
    private func updateSubconections(_ subs:[SubConnection])->Void {
        subConnections.removeAll()
        for sub in subs {
            subConnections.append(sub)
        }
    }
    
    
    func getSubStopsNumber(i:Int)->Int {
        
        guard let stops = self.intermediateStops else {return 0}
        
        return stops[i].count
    }
    
    
    func getStopName(x:Int, y:Int)->String {
      
        guard let stops = self.intermediateStops else {return ""}
        
        let stopBoard = stops[x]
        guard let board = stopBoard[y] else {return ""}
        guard let result = board[0] else {return ""}
        
        return result
    }
    
    
    func getStopTime(x:Int, y:Int)->String {
        
        guard let stops = self.intermediateStops else {return ""}
        
        let stopBoard = stops[x]
        guard let board = stopBoard[y] else {return ""}
        guard let result = board[1] else {return ""}
        
        return result
    }
    
    func getStopDate(x:Int, y:Int)->String {
        
        guard let stops = self.intermediateStops else {return ""}
        
        let stopBoard = stops[x]
        guard let board = stopBoard[y] else {return ""}
        guard let result = board[2] else {return ""}
        
        return result
    }
    
    
    
    
    
}

            class SubConnection {
                    var start:String = ""
                    var end:String = ""
                    var type:String = ""
                    var kind:String = ""
                    var company:String = ""
                    var startTime:String = ""
                    var endTime:String = ""
                    var startDate:String = ""
                    var endDate:String = ""
            }


extension Connection {
    func saveConnectionToCoreData()->Void {
        do {
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                throw saveErr.delegateError
            }
            let managedContext = delegate.persistentContainer.viewContext 
            guard let entity = NSEntityDescription.entity(forEntityName: "CoreConnection",in: managedContext) else {
                throw saveErr.entityError
            }
            print("OK")
             let core = CoreConnection(entity: entity, insertInto: managedContext)
            
            guard let start = start, let end = end, let startTime = startTime, let endTime = endTime, let startDate =  startDate, let endDate = endDate, let timeTravel = timeTravel, let numberOfChanges = numberOfChanges else {return}
            core.start = start
            core.end = end
            core.startTime = startTime
            core.endTime = endTime
            core.startDate = startDate
            core.endDate = endDate
            core.timeTravel = timeTravel
            core.numberOfChanges = Int16(numberOfChanges)
            
            
            var ii = 0
            for sub in subConnections {
                guard let subEntity = NSEntityDescription.entity(forEntityName: "CoreSubConnection",in: managedContext) else {
                    throw saveErr.entityError
                }
                let subCore = CoreSubConnection(entity: subEntity , insertInto: managedContext)
                subCore.company = sub.company
                subCore.start = sub.start
                subCore.end = sub.end
                subCore.startTime = sub.startTime
                subCore.endTime = sub.endTime
                subCore.startData = sub.startDate
                subCore.endDate = sub.endDate
                subCore.kind = sub.kind
                subCore.connectionNumber = Int16(ii)
                subCore.owner = core
                core.addToSubConections(subCore)
                
                ii+=1
            }
            
            guard let intermediateStops = intermediateStops else {return}
            
            var index = 0
            var index0 = 0
            
        
            
            for stops in intermediateStops {
                guard let stopEntity = NSEntityDescription.entity(forEntityName: "CoreIntermediateStop",in: managedContext) else {
                    throw saveErr.entityError
                }
                    for stop in stops {
                        let stopsCore = CoreIntermediateStop(entity: stopEntity , insertInto: managedContext)
                        stopsCore.connectionNumber =  Int16(index)
                        stopsCore.number = Int16(index0)
                  
                        if stop.value[0] != nil {stopsCore.pontName = self.getStopName(x: index, y: index0 )}
                        if stop.value[1] != nil {stopsCore.pointDeparture = self.getStopTime(x: index, y: index0)}
                        if stop.value[2] != nil {stopsCore.pointDate = self.getStopDate(x: index, y: index0)}
                        stopsCore.owner = core
                        core.addToIntermediateStops(stopsCore)
                        index0+=1
                    }
                index0 = 0
                index+=1
            }
            guard let hints = hints else {return}
            for hint in hints {
        
                    guard let hintEntity = NSEntityDescription.entity(forEntityName: "CoreHint",in: managedContext) else {
                        throw saveErr.entityError
                    }
                    let hintc = CoreHint(entity: hintEntity, insertInto: managedContext)
                hintc.number = Int16(hint.key)
                    hintc.hint = hint.value
                    hintc.owner = core
                    core.addToHints(hintc)
            }
            
             try managedContext.save()
        }
        catch  {
            let error = error as! saveErr
            print("Error during CoreData initialization: \(error.type())")
        }
       
        
        
    }
    
 
    
}


