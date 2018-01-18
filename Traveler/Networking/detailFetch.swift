//
//  detailFetch.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 04/12/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import Foundation




class DetailFetch {
    var state:State = .off
    
    public func getDetail(_ link:String?, _ id:String?)->String {
        var finalresult = ""
        guard var link = link, let id = id else { state = .failed
                                    return finalresult}
        link.removePath()
        state = .fetching
        let queue = DispatchQueue(label: "fetchConnection")
        queue.async {
            self.detailRequest(link: link, id: id) { (results) in
                finalresult = results
                self.state = .ended
            }
        }
            
         while self.state == .fetching {sleep(UInt32(0.1))}
        
        return finalresult
        
        
    }
    
    
    
    private func detailRequest(link:String,id:String, completion:@escaping ((String) ->Void)){
        var urlC = URLComponents()
        urlC.scheme = "https"
        urlC.host = "en.e-podroznik.pl"
        urlC.path = "/public/searchingResultExtended.do"
        urlC.query = link
        urlC.queryItems?.append(URLQueryItem(name: "_", value: id))
        guard let url = urlC.url else {return}
        print("URL: \(url.absoluteString)")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
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
    
    
}
