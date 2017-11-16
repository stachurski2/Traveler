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

}
