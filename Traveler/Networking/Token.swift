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


class Token{
    
  
    static let sharedInstance = Token()
    private init() { }
    
    func fromString(htmlContent:String)->String{
        do {
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
                    newString  = newString.substring(to: value - firstQmark + 11) as NSString;                             break
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
        catch tokenError.emptyContent  {
            
            return "Content is empty"
        }
        catch tokenError.huskingError {
            return "Can't find quatation marks"
        }
        catch tokenError.tokenUnavailable {
            return "Can't find tabToken definiton"
        }
        catch {
            return ""
        }
    
    }
    
    
    func getHTMLContent(completion: @escaping((String,Error?)->Void)){
        
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
                next1 = self.fromString(htmlContent: next1)
                completion(next1,nil)
            }
            catch {
                let message = "Problem with connect serwer: \(error.localizedDescription) or HTML parse is impossible"
                completion(message,error)
            }
        
            
            
        }
        task.resume()
        
    }
    
}
