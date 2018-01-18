//
//  StringNbsp.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 01/11/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import Foundation

extension String {
    
    public mutating func removeNbsp()->Void {
        
        self = self.replacingOccurrences(of: "&nbsp;", with: "")
    
    
    }
    
    
    public mutating func extractType()->Void {
        let keyword = self.index(after: "icon icon-round icon-left icon-transport".endIndex)
        
        self = String(self[keyword...])
    
    }
    
    public mutating func removePath()->Void {
        
        let keyword = self.index(after: "/public/searchingResultExtended.do".endIndex)
        
        self = String(self[keyword...])

        
    }

}
