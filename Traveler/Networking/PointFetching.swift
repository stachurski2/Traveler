//
//  PointFetching.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 30/09/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import Foundation
import UIKit

public enum StateFetch:String {
    case Ready, Executing, Finished, Failed, Stopped
}

class PointFetching {
    
    static let sharedInstance = PointFetching()
    
    var url:URLRequest
    var urls:URLSession
    var task:URLSessionDataTask
    
    var keyword:String
    var type:Bool

    let queue = DispatchQueue(label: "view")
    
    public var state = StateFetch.Ready
    
    func stopFetching()->Void {
        if state == .Executing {
            queue.suspend()
            task.cancel()
            state = .Stopped
        }
    }
    
    func startFetching(list: SugestList )->Void {
        
        if state == .Stopped { queue.resume()}
        if state == .Executing { return }
        state = .Executing
        var points = [Point]()
        var errorMessage:String?
        requestServer() { (error, data) in
            if (error != nil && self.state != .Stopped) {
                print("error occured")
                self.state = .Failed
                errorMessage = error?.localizedDescription
                let err = error! as NSError
                let code = err.code
                
                let mainqueue =  DispatchQueue.main
                mainqueue.sync {
                    list.returnErrorToControler(errorMesssage: errorMessage,code:code)
                }
                
            }
            
            guard let data = data else {return}
            //API control content
            let control = data["status"] as! String
            if control != "0" {return }
            // if is OK
            let content = data["suggestions"] as? [AnyObject]
            for substract in content! {
                let title = substract["n"] as! String
                let descs = substract["a"] as! [String]
                let descritpion = descs.first!
                let id = substract["id"] as! String
                let lat = substract["la"] as! String
                let lon = substract["lo"] as! String
                let type = substract["t"] as! String
                let point = Point(name: title, description: descritpion, id: id, lon: lon, la: lat, type:type)
                points.append(point)
            }
            self.state = .Finished
            
            self.queue.async {
                while(true) {
                    if self.state == .Finished {
                        let mainqueue =  DispatchQueue.main
                        mainqueue.sync {
                            list.updateData(points: points)
                            list.returnDataToControler()
                        }
                        break;
                    }
                    if self.state == .Failed  {
                        let mainqueue =  DispatchQueue.main
                        mainqueue.sync {
                            //list.returnErrorToControler(errorMesssage: errorMessage)
                        }
                        break;
                    }
                    else {
                        sleep(UInt32(0.01))
                    }
                }
            }
        }
    }
    
    
    func updateData(keyword:String, type:Bool)->Void{
        
        self.keyword = keyword
        self.type = type
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.e-podroznik.pl"
        urlComponents.path = "/public/suggest.do"
        urlComponents.queryItems = [URLQueryItem(name: "query", value: "")]
        if type {
            urlComponents.queryItems?.append(URLQueryItem(name: "requestKind", value: "SOURCE"))
        }
        else {
            urlComponents.queryItems?.append(URLQueryItem(name: "requestKind", value: "DESTINATION"))
        }
        urlComponents.queryItems?.append(URLQueryItem(name: "type", value: "AUTO"))
        guard let url = urlComponents.url else {return}
        self.url  = URLRequest(url: url)
        self.urls = URLSession(configuration: .default)
    }

    private init() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "www.e-podroznik.pl"
        urlComponents.path = "/public/suggest.do"
        urlComponents.queryItems = [URLQueryItem(name: "query", value: "")]
        self.url = URLRequest(url: urlComponents.url!)
        self.urls = URLSession(configuration: .default)
        self.task = urls.dataTask(with: url)
        self.keyword = ""
        self.type = true
        self.url.httpMethod = "POST"
        self.url.addValue("application/json", forHTTPHeaderField: "content-type")
    }
    
    private func requestServer(completion: @escaping((Error?,[String:AnyObject]?)->Void)){
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.e-podroznik.pl"
        urlComponents.path = "/public/suggest.do"
        urlComponents.queryItems = [URLQueryItem(name: "query", value: self.keyword)]
        if self.type {
            urlComponents.queryItems?.append(URLQueryItem(name: "requestKind", value: "SOURCE"))
        }
        else {
            urlComponents.queryItems?.append(URLQueryItem(name: "requestKind", value: "DESTINATION"))
        }
        urlComponents.queryItems?.append(URLQueryItem(name: "type", value: "AUTO"))
        guard let url = urlComponents.url else {return}
        self.url = URLRequest(url: url)
        self.url.httpMethod = "POST"
        self.url.addValue("application/json", forHTTPHeaderField: "content-type")
        self.urls = URLSession(configuration: .default)
        self.task =  self.urls.dataTask(with: self.url){ data, response, error in
            do {
                if let response = response as! HTTPURLResponse? {
                    print("Server answered with code: \(response.statusCode)")
                }
                if  error != nil {
                    let error = error! as NSError
                     completion(error,nil)
                }
                else {
                    
                    print(data!)
                    let values:[String:AnyObject] = (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject])!
                        completion(error,values)
                }
            }
            catch {
                completion(error,nil)
            }
        }
        task.resume()
    
    }

}
    

