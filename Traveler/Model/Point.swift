
//  Point.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 29/09/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import Foundation
import CoreLocation

enum pointType:Int {
    case bigCity, city, street, groupStop, busStop, urbanStop, railStop;
}

class Point {
    var name:String?
    var destription: String?
    var id:Int?
    var coordinates: CLLocationCoordinate2D?
    var type:pointType?
    
    init(name:String, description:String, id:String, lon:String, la:String){
        self.name = name
        self.destription = description
        self.id = Int(id)
        self.coordinates = CLLocationCoordinate2D(latitude: Double(la)!, longitude: Double(lon)!)
    }
    
    init(name:String, description:String, id:String, lon:String, la:String, type:String){
        self.name = name
        self.destription = description
        self.id = Int(id)
    
        switch type {
            case "BUS_STOP":
                self.type = .busStop
                break;
            case "URBAN_STOP":
                self.type = .urbanStop
                break;
            case "RAIL_STOP":
                self.type = .railStop
                break;
            case "GROUP_STOP":
                self.type = .groupStop
                break;
            case "STREET":
                self.type = .street
                break;
            case "BIG_CITY":
                self.type = .bigCity
                break;
            default:
                self.type = .city
                break
        }
        
        guard let la = Double(la), let lon = Double(lon) else { self.coordinates = CLLocationCoordinate2D(latitude: Double(0), longitude: Double(0)); return}
            
        self.coordinates = CLLocationCoordinate2D(latitude: Double(la), longitude: Double(lon))
        
        
    }
    
    open func getID()->String {
        guard let id = self.id else {return "c|0"}
        guard self.type != nil else {return "c|\(String(describing: id))"}
        
        switch self.type {
        case .busStop?,.railStop?:
             return "s|\(String(describing: id))"
        case .groupStop?:
             return "gs|\(String(describing: id))"
        case .city?, .bigCity?:
            return "c|\(String(describing: id))"
        case .street?:
            return "st|\(String(describing: id))";
        case .urbanStop?:
            return "sg|\(String(describing: id))"
        case .none:
             return "c|\(String(describing: id))"
            }
            
            
      
    }
    
    open func fetchID()->String {
          guard let id = self.id else {return "0"}
                    return String(describing:id)
    }
    
    open func getName()->String {
        guard let n = name else {return ""}
        return n
    }
    
    open func getType()->String {
        switch self.type {
        case .busStop?:
            return "BUS_STOP"
        case .groupStop?:
            return "GROUP_STOP"
        case .city?:
            return "CITY"
        case .bigCity?:
            return "BIG_CITY"
        case .street?:
            return "STREET";
        case .urbanStop?:
            return "URBAN_STOP"
        case .railStop?:
            return "RAIL_STOP"
        case .none:
            return "CITY"
        }
    }
    
    open func getLat()->String {
        return String(describing: self.coordinates?.latitude)
    }
    
    open func getLon()->String {
        return String(describing: self.coordinates?.longitude)
    }
    
    open func getDesc()->String {
        guard let dectrition = destription else {return ""}
        return dectrition
    }
    
    
    
    
}


