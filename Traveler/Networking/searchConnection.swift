//
//  searchConnection.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 08/10/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import Foundation
import SwiftSoup

enum State { case off, fetching,failed, ended}

class SearchConnection {
    var state:State = .off

    func request(task:Task)->String{
        self.state = .fetching
        var finalResult:String = ""
        let queue = DispatchQueue(label: "fetchConnection")
        queue.async {
            self.postRequest(task:task) { result in
                if result != "result unavailable" {self.state = .ended; finalResult = result}
                else {self.state = .failed; finalResult = result}
            }
        }
        
        while self.state == .fetching {sleep(UInt32(0.1))}
        
        return finalResult
        
    }
    
    
    private func postRequest(task: Task, completion:@escaping ((String)->Void)){
        var urlC = URLComponents()
        urlC.scheme = "https"
        urlC.host = "www.e-podroznik.pl"
        urlC.path = "/public/searchingResults.do"
        urlC.queryItems = [URLQueryItem(name: "method", value: "task")]
        urlC.queryItems?.append(URLQueryItem(name: "tseVw", value: "regularP"))
        urlC.queryItems?.append(URLQueryItem(name: "tabToken", value: task.getTabToken()))
        urlC.queryItems?.append(URLQueryItem(name: "fromV", value: task.getStartPoint()))
        urlC.queryItems?.append(URLQueryItem(name: "toV", value: task.getEndPoint()))
        urlC.queryItems?.append(URLQueryItem(name: "formCompositeSearchingResults.formCompositeSearcherFinalH.fromCityId", value: ""))
        urlC.queryItems?.append(URLQueryItem(name: "formCompositeSearchingResults.formCompositeSearcherFinalH.toCityId", value: ""))
        urlC.queryItems?.append(URLQueryItem(name: "fromV", value: task.getStartPoint()))
        if task.directConnectionPrefer() {
            urlC.queryItems?.append(URLQueryItem(name: "preferDirects", value: "on")) }
     
        urlC.queryItems?.append(URLQueryItem(name: "toV", value: task.getEndPoint()))
         urlC.queryItems?.append(URLQueryItem(name: "tripType", value: "one-way"))
        urlC.queryItems?.append(URLQueryItem(name: "formCompositeSearchingResults.formCompositeSearcherFinalH.fromText", value:task.getStartPointName()))
        urlC.queryItems?.append(URLQueryItem(name: "formCompositeSearchingResults.formCompositeSearcherFinalH.toText", value:task.getEndPointName()))
        urlC.queryItems?.append(URLQueryItem(name: "formCompositeSearchingResults.formCompositeSearcherFinalH.dateV", value: task.showDate()))
        if task.directConnectionPrefer() {   urlC.queryItems?.append(URLQueryItem(name: "formCompositeSearchingResults.formCompositeSearcherFinalH.timeV", value: "--:--")) }
        else {
            urlC.queryItems?.append(URLQueryItem(name: "formCompositeSearchingResults.formCompositeSearcherFinalH.timeV", value: task.showTime()))}
           urlC.queryItems?.append(URLQueryItem(name: "formCompositeSearchingResults.formCompositeSearcherFinalH.arrivalV", value: "DEPARTURE"))
           urlC.queryItems?.append(URLQueryItem(name: "formCompositeSearchingResults.formCompositeSearcherFinalH.ommitTime", value:"on"))
        urlC.queryItems?.append(URLQueryItem(name:"formCompositeSearchingResults.formCompositeSearcherFinalH.returnArrivalV", value: "DEPARTURE"))
        if task.directConnectionPrefer() {
            urlC.queryItems?.append(URLQueryItem(name: "formCompositeSearchingResults.formCompositeSearcherFinalH.ommitReturnTime", value: "on"))
        }
        guard let url = urlC.url else {return}
        print("URL: \(url.absoluteString)")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let URLS = URLSession(configuration: .default)
        let task =  URLS.dataTask(with: urlRequest){ data, response, error in
            do {
                if error != nil { throw error! }
            else {
                let respon = response as! HTTPURLResponse
                print("Server answered with code: \(respon.statusCode)")
                    let html:String =  try String(contentsOf: url, encoding: .utf8)
                    completion(html)
                    
                        
            }
            }
            catch {
                completion("result unavailable")
            }
       
        }
        task.resume()
    }
    
    private func getRequest(task: Task)->String {
        
        
        return ""
    }
    
    
    
    

}
