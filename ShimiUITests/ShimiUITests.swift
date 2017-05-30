//
//  ShimiUITests.swift
//  ShimiUITests
//
//  Created by Pango-mac on 20/05/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import XCTest

class ShimiUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments.append("-test")
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testExample() {
        let app = XCUIApplication()
        createEntries(app: app, count: 4)
    }
    
    fileprivate func createEntries(app: XCUIApplication, count: Int) {
        for _ in 0 ..< count {
            app.buttons["Enter"].tap()
            app.buttons["Exit"].tap()
        }
    }
    
}
