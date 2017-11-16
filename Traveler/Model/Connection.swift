//
//  Connection.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 27/10/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import Foundation


class Connection {
    
    let start:String
    let end:String
    var numberOfChanges: Int?
    var startTime:String?
    var endTime:String?
    var startDate:String?
    var endDate:String?
    var timeTravel: String?
    var link:String?
    
    var subConnections:[SubConnection] = [SubConnection]()
    
    
    init(start:String, end:String, changes: Int){
        self.start = start
        self.end = end
        self.numberOfChanges = changes
    }
    
    func defineTime(startTime:String, endTime:String, startDate:String, endDate:String,_ timeTravel:String = "test") {
         self.startTime = startTime
         self.endTime = endTime
         self.startDate = startDate
         self.endDate = endDate
         self.timeTravel = timeTravel
    }
    
    func defineLink(link:String){
        self.link = link
    }
    
    
}


class SubConnection {
    
    var start:String?
    var end:String?
    var type:String?
    
  //  var startTime:String?
  //  var endTime:String?
    
  //  var startDate:String?
  //  var endDate:String?
    
  //  var timeTravel: String?
    
    
}

