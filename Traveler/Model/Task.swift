//
//  Task.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 08/10/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import Foundation
//import SwiftSoup
import JavaScriptCore
import UIKit

enum stageOfTask:Int {
    case none,dataCollected,tokenFetching,tokenFetched,tokenFailed,requestStarted
}

class Task {
    var stage:stageOfTask = .none
    var startPoint:Point?
    var endPoint:Point?
    var directConnection:Bool = false
 
    
    var todayDate:Date
    var calendar: Calendar
    var date: Date
    var token: String?
    
    static let sharedInstance = Task()

    
    private init(){
        self.todayDate = Date()
        self.calendar = Calendar.current
        let minutes = calendar.component(.minute, from: todayDate)
        for _ in 1...minutes { todayDate = calendar.date(byAdding: .minute, value: -1 , to: todayDate)!}
        self.date = todayDate
        
    }

}


extension Task {
    // start and end points defining
    func defineStartPoint(point: Point?) {
        self.startPoint = point
    }
    
    func deleteStartPoint() {
        self.startPoint = nil
    }
    
    func defineEndPoint(point: Point?) {
        self.endPoint = point
    }
    
    func deleteEndPoint() {
        self.endPoint = nil
    }
}



extension Task {
    func showDate()->String {
        var day = ""
        if calendar.component(.day, from: date)<10 { day = "0\(calendar.component(.day, from: date))"}
        else {day = "\(calendar.component(.day, from: date))"}
        var month = ""
        if calendar.component(.month, from: date)<10 { month = "0\(calendar.component(.month, from: date))"}
        else {month = "\(calendar.component(.month, from: date))"}
        
        
        return "\(day).\(month).\(calendar.component(.year, from: date))"
    }
    
    open func showTime()->String {
        if calendar.component(.minute, from: date)<10 {
            return "\(calendar.component(.hour, from: date)):0\(calendar.component(.minute, from: date))"
        }
        else {
            return "\(calendar.component(.hour, from: date)):\(calendar.component(.minute, from: date))"
        }
    }
    
    
    func changeDate(stepper:Double)->Void {
        defer {
        print(stepper)
        }
        date = calendar.date(byAdding: .day, value: Int(stepper) , to: todayDate)! }
    
    func changeTime(stepper:Double)->Void {

        date = calendar.date(byAdding: .hour, value: Int(stepper) , to: todayDate)! }
    
    func changeDateTime(date:Date)->Void {
        self.date = date
    }
    
    
    func changeDirectConnection(value:Bool)->Void {self.directConnection = value}
    
    open func getStartPoint()->String{
        guard let point = self.startPoint?.getID() else {return "c|0"}
        return point
    }
    open func getEndPoint()->String{
        guard let point = self.endPoint?.getID() else {return "c|0"}
        return point
    }
    
    open func getTabToken()->String{
        guard let tabToken = self.token else {return ""}
        return tabToken
    }
    
    open func getStartPointName()->String{
        guard let tabToken = self.startPoint?.getName() else {return ""}
        return tabToken
    }
    open func getEndPointName()->String{
        guard let point = self.endPoint?.getName() else {return ""}
        return point
    }
    open func directConnectionPrefer()->Bool {
        return directConnection
    }
    
}



extension Task {
  
    
    
    func start(viewController:MainViewController)->Void {
        print("prepare to send request to e-podroznik.pl")
            let queue = DispatchQueue(label: "fetch")
             let mainqueue =  DispatchQueue.main
            queue.async {
                guard let _ = self.startPoint, let _ = self.endPoint else {print("No complet data to send request"); self.stage = .dataCollected ;return}
                    let token = Token.sharedInstance
                self.stage = .tokenFetching
                mainqueue.sync {
                    viewController.showLoadComunicate()
                }
                    token.getHTMLContent(){ token, error in
                    if error != nil {
                        print(error?.localizedDescription ?? String.self)
                        self.stage = .tokenFailed
                    }
                    else{
                        print("token:\(token)")
                        self.stage = .tokenFetched}
                    }
                while self.stage == .tokenFetching { sleep(UInt32(0.1))}

                if self.stage == .tokenFetched {
                    let queue = DispatchQueue(label: "searching")
                    queue.async {
                        let con = SearchConnection()
                        let content = con.request(task: self)
                        mainqueue.sync {
                            viewController.hideLoadComunicate()
                            viewController.performSegue(withIdentifier: "showResult", sender: content)
                        }
            
                    }

                }
       
            }
        
        }
    
    }









    

