//
//  RotatingButtonsTests.swift
//  Shimi
//
//  Created by Pango-mac on 29/05/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import XCTest
import RealmSwift
import RxSwift

@testable import Shimi

class RotatingButtonsTests: XCTestCase {
    
    var db: Realm!
    
    override func setUp() {
        super.setUp()
        self.db = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: self.name))
    }
    
    override func tearDown() {
        self.db = nil
        super.tearDown()
    }
    
    func test_isOn_true_1Entry() {
        let vm = RotatingButtonsViewModel(db: self.db, vc: nil)
        vm.isOn.value = true
        let entries = db.objects(Entry.self).sorted(byKeyPath: "enter", ascending: false)
        XCTAssert(entries.count == 1)
        let firstEntry = entries[0]
        XCTAssertNil(firstEntry.exit)
    }
    
    func test_isOn_trueAndFalse_1CompleteEntry() {
        let vm = RotatingButtonsViewModel(db: self.db, vc: nil)
        vm.isOn.value = true
        vm.isOn.value = false
        let entries = db.objects(Entry.self).sorted(byKeyPath: "enter", ascending: false)
        XCTAssert(entries.count == 1)
        let firstEntry = entries[0]
        XCTAssertNotNil(firstEntry.exit)
    }
    
}
