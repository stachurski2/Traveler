//
//  TravelerTests.swift
//  TravelerTests
//
//  Created by Stanisaw Sobczyk on 29/09/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import XCTest
@testable import Traveler

class TravelerTests: XCTestCase {
    var stringToken:String? = nil

 
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testToken() {
        
        
        var errorMessage:String = ""
        
        let token0 = Token.sharedInstance
        token0.get(){ token, error in
            
            if error == nil {
                self.stringToken = token
            }
            else {
               errorMessage = (error?.localizedDescription)!
            }
            
        }
        let pred = NSPredicate(format: "stringToken != nil")
        let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
        let res = XCTWaiter.wait(for: [exp], timeout: 10.0)
        
    
       if res == XCTWaiter.Result.completed {
        
        guard let stringToken = stringToken else { XCTAssert(false, "Failed to unwrap optional"); return }
        print("Completion Handler completed, fetched token \(String(describing: stringToken))")
        XCTAssert(true,"Completion Handler completed, fetched token \(String(describing: stringToken))")
        
        }
       else {
        XCTAssert(stringToken != nil, "Failed to fetch, \(String(describing: errorMessage))")
        
        }
        
    }
    
}
