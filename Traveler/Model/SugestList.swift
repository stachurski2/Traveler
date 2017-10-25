//
//  Task.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 30/09/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import Foundation
import UIKit




class SugestList {
    
    var source:Bool?  //true - source, false - target
    var points:[Point]? = [Point]()
    let networking = PointFetching.sharedInstance
    var viewController:MainViewController?
    
    func clear()->Void {
        points?.removeAll()
    }

    func updateData(points:[Point]?)->Void {
        self.points?.removeAll()
        guard let points = points else {return}
        for point in points {
            self.points?.append(point)
        }
    }

    func fetch(keyword:String, source:Bool, view:MainViewController) {
        networking.updateData(keyword: keyword, type: source)
        networking.stopFetching()
        networking.startFetching(list: self)
        self.viewController = view
    }
    
    func selectPointAt(index:IndexPath)->Point{
        return points![index.row]
    }
        
    public var count:Int {
        get { guard let number = points?.count else {return 0}; return number}
    }
    
    func title(row:IndexPath)->String {
 
        
            let number = row.row
            let point =  points![number]
            return point.name!
            
        
       
       
      
    }
    
    func description(row:IndexPath)->String {
        let number = row.row
        let point =  points![number]
        return point.destription!
    }
    
    func returnDataToControler()->Void {
        guard let viewController = viewController else {return}
        viewController.reloadData()
    }
    
    func returnErrorToControler(errorMesssage:String?)->Void {
        guard let viewController = viewController,
               let  errorMesssage = errorMesssage else {return}
        let alert = UIAlertController(title: "Error", message: errorMesssage , preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default , handler: nil)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
        
    }
}

