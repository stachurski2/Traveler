//
//  Connection.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 26/10/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import Foundation
import SwiftSoup


class Connections {

    var connect:[Connection] = [Connection]()
    
    func conectionCount()->Int {
      return connect.count
    }
    
    func startPoint(_ index:IndexPath)->String {
        let i = index.row
        guard let value =  connect[i].start else {return ""}
        return value
    }
   
    func endPoint(_ index:IndexPath)->String {
        let i = index.row
        guard let value =  connect[i].end else {return ""}
        return value
        
    }
    
    func startTime(_ index:IndexPath)->String {
        let i = index.row
        guard let value = connect[i].startTime else {return "err"}
        return value
    }
    
    func endTime(_ index:IndexPath)->String {
        let i = index.row
        guard let value = connect[i].endTime else {return "err"}
        return value
    }
    
    func startDate(_ index:IndexPath)->String {
        let i = index.row
        guard let value = connect[i].startDate else {return "err"}
        return value
    }
    
    func endDate(_ index:IndexPath)->String {
        let i = index.row
        guard let value = connect[i].endDate else {return "err"}
        return value
    }
    
    func changes(_ index:IndexPath)->Int {
        let i = index.row
        guard let value = connect[i].numberOfChanges else {return 0}
        return value-1
    }
    
    func travelTime(_ index:IndexPath)->String {
        let i = index.row
        guard let value = connect[i].timeTravel else {return "err"}
        return value
    }
    
    
    open func huskFromHtmlString(htmlContent:String)->Void {
        
        do {
            let document = try SwiftSoup.parse(htmlContent)
            let next = try document.select("body")
            let primaryData = try next.select("div.searching-result")
            let edges = try primaryData.select("span.edge-stops-names")
            let starts:Elements  = try edges.select("span.departure")
            let ends:Elements = try edges.select("span.arrival")
            
            let times = try primaryData.select("span.edge-date-time")
            let departureDateTime = try times.select("span.departure")
            let departureTime = try departureDateTime.select("span.time")
            let departureDate = try  departureDateTime.select("span.date")
            
            let arrivalDateTime = try times.select("span.arrival")
            let arrivalTime = try arrivalDateTime.select("span.time")
            let arrivalDate = try  arrivalDateTime.select("span.date")
            
            let summaryInfo = try primaryData.select("div.summary-info")
            let travelTimes = try summaryInfo.select("div.journey-time")
            
            
            var numb = 1
        
            let travelData = Elements()
            
            for data in primaryData {
                let className =  try data.className()
                if className != "searching-result fake-result" {  travelData.add(data) }
            }
    
            for data in travelData {
                
            var ttime =  try "\(travelTimes.get(numb-1).select("span.hours").html()) \(travelTimes.get(numb-1).select("span.minutes").html())"
            ttime.removeNbsp()
                print("Time travel: \(ttime)")
            let connection = try Connection(start: starts.get(numb-1).html(), end: ends.get(numb-1).html(), changes: Int(data.attr("data-connectionscount"))!)
            try connection.defineTime(startTime: departureTime.get(numb-1).html(), endTime: arrivalTime.get(numb-1).html(), startDate: departureDate.get(numb-1).html(), endDate: arrivalDate.get(numb-1).html(),ttime)
                
            try print("Number of subconections:\(data.attr("data-connectionscount"))")
                let numberofConnections = try Int(data.attr("data-connectionscount"))!
                let subData0 = try data.select("div.travel-part")
                let subData1 = Elements()
                for sdata in subData0 {
                     let className =  try sdata.className()
                    if className == "travel-part"  { subData1.add(sdata)}
                }
               print("Number of datas: \(subData1.size())")
                let numberofDatatas = subData1.size()
                if numberofDatatas == numberofConnections {
                    for i in 1...numberofDatatas {
                       // print("Subconnection number: \(i)")
                        let subData = subData1.eq(i-1)
                        //try print(" From: \(subData.select("div.travel-part").attr("data-source-admin-path")) to: \(subData.select("div.travel-part").attr("data-target-admin-path"))")
                        
                        let start = try subData.select("div.travel-part").attr("data-source-admin-path")
                        let end = try subData.select("div.travel-part").attr("data-target-admin-path")
                        var type = try subData.select("span.icon").attr("class")
                        type.extractType()
                        connection.addSubConnection(start, end, type)
                        
                        var time =  try (" Duration time: \(subData.select("span.hours").html()) \(subData.select("span.minutes").html()) ")
                        time.removeNbsp()
                       // print(time)
                        
    
                        
                     //   try print(" Company: \(subData.select("span.show-on-hover").html())")
                        
                        
                        
                      
                        
                        
                        
                      //   print(" Type: \(type.extractType())")
                      
                        if try subData.select("span.integer-part").size() == 1 {
                        //    try print(" price: \(subData.select("span.integer-part").html())\(subData.select("span.decimal-separator").html())\(subData.select("span.decimal-part").html()) \(subData.select("span.currency").html())")
                        }
                    }
                  

                    
                    
                }
                else if numberofDatatas == 0 {
                        
                        print("Another connection info:")
                        let durationShort = try subData0.select("span.durationShort")
                        var time = try ("Multi Connection time:\(durationShort.select("span.hours").html()) \(durationShort.select("span.minutes").html())")
                        time.removeNbsp()
                        print(time)
                        try print("Company name: \(subData0.select("span.carrier-name").html())")
                      let subData1 = Elements()
                        for sdata in subData0 {
                            let className =  try sdata.className()
                            if className != "travel-part" { subData1.add(sdata)}
                        }
                    let changeData = try subData1.select("div.travel-part")
                      var numb = 1
                        for change in changeData {
                            let classN = try change.className()
                            if classN == "travel-part connection-info" {
                                print("Subconnection number: \(numb)")
                                try print("from: \(change.attr("data-source-admin-path")) to: \(change.attr("data-target-admin-path"))")
                                let start = try change.attr("data-source-admin-path")
                                let end = try change.attr("data-target-admin-path")
                                var type = try change.select("span.icon").attr("class")
                                type.extractType()
                                connection.addSubConnection(start, end, type)

                                numb += 1
                            }
                            
                        }
                    
                }
                else if numberofDatatas != 0 {
            
                    let changeData = try subData0.select("div.travel-part")
                    var numb = 1
                    for change in changeData {
                        let classN = try change.className()
                        if classN == "travel-part connection-info" {
                            print("Subconnection number: \(numb)")
                            try print("from: \(change.attr("data-source-admin-path")) to: \(change.attr("data-target-admin-path"))")
                            let start = try change.attr("data-source-admin-path")
                            let end = try change.attr("data-target-admin-path")
                            
                           // try print("type:\(change.select("span.show-on-hover").html())")
                            var type = try change.select("span.icon").attr("class")
                            
                            type.extractType()
                            connection.addSubConnection(start, end, type)
                            try print("Connection data:\(change.html())")
                            numb += 1
                        }
                    }
                    
                    
                    
                }
               // try print("More info link: \(data.attr("data-detailspath"))")
                let link = try data.attr("data-detailspath")
                let id = try data.attr("data-departure-timestamp")
                connection.detailid = id
                connection.defineLink(link: link)
                connect.append(connection)
                numb = numb + 1

            }
        
            
            }
        catch {
          print("error with parse")
        }
         print("Data count:\(connect.count)")
    }
    
    
    func connection(_ index:IndexPath)->Connection {
        let i = index.row
        return connect[i]
    }
    

    
    
    
   
    
}






