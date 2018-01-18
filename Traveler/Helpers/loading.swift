//
//  loading.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 29/12/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import Foundation


protocol loading {
    func showLoadingComunicate()->Void
    func hideLoadingComunicate()->Void
    func showError(_ message:String)
}
