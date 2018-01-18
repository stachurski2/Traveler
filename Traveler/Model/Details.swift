//
//  Details.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 09/12/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import Foundation
import SwiftSoup

class Details {
    
    var hints:[Int:String] = [:]
    var subConnections:[SubConnection] = []
    var intermediateStops:[[Int:[String]]] = []

    
    
    init(htmlContent:String){
        hints = [Int:String]()
        intermediateStops = [[Int:[String]]]()
        do {
                 let document = try SwiftSoup.parse(htmlContent)
                 let hintContent = try document.select("div.hint-item")
                  var index = 1
                  for hint in hintContent {
                        let className =  try hint.className()
                        if className == "hint-item hint-item-\(index)" {
                          let result = try hint.text()
                           hints.updateValue(result, forKey: index)
                            
                          
                           
                    }
                        index+=1
                    }
                let edgesContent = try document.select("div")
                self.subConnections.removeAll()
                var subC = SubConnection()
                var connectionIndex = 1
            
            
                var stopIndex = 1
                var connectionStops = [Int:[String]]()
            
            
            
                for edge in edgesContent {
                    
                    
                    let className =  try edge.className()
                    if className == "route-details-container firstStop"  {
                        subC = SubConnection()
                        
                        var type = try edge.select("span.type-line").select("span.icon").attr("class")
                        let kind = try edge.select("span.type-line").text()
                        let time = try edge.select("span.route-time").text()
                        let date = try edge.select("span.route-day").text()
                        let stop = try edge.select("span.stop-name").text()
                        let comp = try edge.select("a").text()
                    
                       
                        index+=1
                        
                        type.extractType()
                        
                        subC.start = stop
                        subC.startTime = time
                        subC.startDate = date
                        subC.type = type
                        subC.kind = kind
                        subC.company = comp
                        
                        
                        
                        connectionStops.removeAll()
                        stopIndex = 0
            
                        connectionStops.updateValue([stop,time,date], forKey: stopIndex)
                        
                        
                    }
                    else if className == "route-details-container lastStop" {
                       
                      
                        let time = try edge.select("span.route-time").text()
                        let date = try edge.select("span.route-day").text()
                        let stop = try edge.select("span.stop-name").text()
                      
                        subC.end = stop
                        subC.endTime = time
                        subC.endDate = date
                        self.subConnections.append(subC)
        
                        connectionIndex+=1
                       
                        
                        //print("End at:\(stop) at:\(time),:\(date)")
                        stopIndex+=1
                        connectionStops.updateValue([stop,time,date], forKey: stopIndex)
                        intermediateStops.append(connectionStops)
                        
                        
                        
                      
                    }
                    else if className == "route-details-container intermediateStops" {
                        let stops = try edge.select("div.stop-item")
                   
                        for stop in stops {
                            let name = try stop.select("span.stop-name").text()
                            let time = try stop.select("span.route-time").text()
                            let date = try stop.select("span.route-day").text()
                             // print(" Stopaa at:\(name) at:\(time),:\(data)")
                             stopIndex+=1
                            connectionStops.updateValue([name,time,date], forKey: stopIndex)
                            
                            
                          
                        }
                        
                        
                        
                        
                        
                        
                    }
                    
 

                    
            }
         
            

                    
                
            
            
            
            
            
            
            
        }
        
        catch {
            
                print("Sorry sth went wrong :(")
            
        }
        
        
        
        
        
        
    }
    
    func getSubs()->[SubConnection]{
        return subConnections
    }
    
    func getHints()->[Int:String] {
        return hints
    }
    
    func getIntStops()->[[Int:[String]]] {
        return intermediateStops
    }
    
    
    
}
