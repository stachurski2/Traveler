//
//  token.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 14/10/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import Foundation
import SwiftSoup

enum QMark:Int {
    case first, second, third
}

enum tokenError:Error {
    case emptyContent
    case tokenUnavailable
    case huskingError
    }


extension tokenError:LocalizedError {
    public var errorDescription: String? {
    switch self {
    case .emptyContent:
    return NSLocalizedString("Fetched Content is empty", comment: "Empty Content")
    
    case .tokenUnavailable:
        return NSLocalizedString("There is no tabToken in fetched data", comment: "Token unavailable")
        
    case .huskingError:
        return NSLocalizedString("Cannot husk token from content", comment: "Husking Error")

        }
    }
    
}
    
    
    

    
    



class Token{
    
  
    static let sharedInstance = Token()
    private init() { }
    
    func fromString(htmlContent:String)throws -> String   {
       // do {
            if htmlContent.count <= 0 { throw tokenError.emptyContent }
        var numberOfCharacters = htmlContent.count - 12 as Int
        var newString = NSString(string: htmlContent)
        var quatationMark:QMark = .first
        
        for value in 0...numberOfCharacters {
            var substring = newString.substring(from: value) as NSString
            substring = substring.substring(to: 8) as NSString
                if substring == "tabToken" {
                    newString = newString.substring(from: value) as NSString as NSString
                    break
                }
                if value == numberOfCharacters {
                  throw tokenError.tokenUnavailable
                }
        }
        numberOfCharacters = newString.substring(from: 0).count - 1
        var firstQmark:Int = 0
  
        for value in 0...numberOfCharacters {
            var substring = newString.substring(from: value) as NSString
            substring = substring.substring(to: 1) as NSString
            if substring == "\""  {
                switch quatationMark {
                    case .first: quatationMark = .second
                                newString = newString.substring(from: value + 1) as NSString
                                firstQmark = value
                    case .second: quatationMark = .third
                    newString  = newString.substring(to: value - firstQmark + 11) as NSString;
                    break
                    case .third: break
                }
            }
            if quatationMark == .third {
                break
            }
            
            if value == numberOfCharacters {
                throw tokenError.huskingError
            }
            
        }
    
        return newString as String
    
    }
    
    
    func get(completion: @escaping((String,Error?)->Void)){
        
        let url = URL(string: "https://www.e-podroznik.pl")
        let request = URLRequest(url: url!)
        let URLS = URLSession(configuration: .default)
        
        let task =  URLS.dataTask(with: request){ data, response, error in
            
            do {
                if error != nil {throw (error)!}
                let html:String =  try String(contentsOf: url!, encoding: .ascii)
                let document = try SwiftSoup.parse(html)
                let content = try document.select("head")
                let next = try content.select("script").attr("type", "text/javascript").attr("script-type", "runBeforeGetScripts")
                var next1 = try next.toString()
                next1 = try self.fromString(htmlContent: next1)
                print(next1)
                completion(next1,nil)
            }
                
            catch let tokenError as tokenError {
               
                completion("", tokenError)
            }
            catch {
                completion("",error)
            }
        
            
            
        }
        
        task.resume()
        
        
    }
    
    
    
    
}
