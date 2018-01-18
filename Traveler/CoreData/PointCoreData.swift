//
//  PointCoreData.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 19/11/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import UIKit
import CoreData



class PointCoreData:CoreData {

    func fetchData()->[Point] {
        var points:[Point] = []
        if state == .succeded {
            let start = records.count - 1
          
            for index in stride(from: start, to: -1, by: -1) {
                    let record = records[index]
                    guard let name =  record.value(forKey: "name") as! String! else {return points}
                    guard let description =  record.value(forKey: "descripton") as! String! else {return points}
                    guard let id = record.value(forKey:"id") as! String! else {return points}
                    guard let lon = record.value(forKey:"lon") as! String! else {return points}
                    guard let lat = record.value(forKey:"lat") as! String! else {return points}
                    guard let type = record.value(forKey:"type") as! String! else {return points}
                    let point = Point(name: name, description: description, id: id, lon: lon, la: lat, type: type)
                    points.append(point)
                }
        }
        return points
    }
    
    func addPoint(_ point:Point)->Void{
        do {
            guard let managedContext = managedContext else {throw saveErr.entityError}
            guard let entity = NSEntityDescription.entity(forEntityName: "CorePoint",in: managedContext) else {
                throw saveErr.entityError
            }
            let ppoint = NSManagedObject(entity: entity, insertInto: managedContext)
            
            
            
            ppoint.setValuesForKeys(["name": point.getName() ,"id":point.fetchID(),"descripton":point.getDesc(),"lon":point.getLon(),"lat":point.getLat(),"type":point.getType()])
          
            try managedContext.save()
            records.append(ppoint)
        }
        catch  {
            let error = error as NSError
              print("Could not save. \(error), \(error.userInfo)")
        }
    }
    

    

    
    
}
