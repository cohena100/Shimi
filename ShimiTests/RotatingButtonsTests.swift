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
import RxTest
import RxBlocking

@testable import Shimi

class RotatingButtonsTests: XCTestCase {
    
    var db: Realm!
    var vm: RotatingButtonsViewModel!
    
    override func setUp() {
        super.setUp()
        self.db = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: self.name))
        vm = RotatingButtonsViewModel(db: self.db, vc: nil)
    }
    
    override func tearDown() {
        self.db = nil
        self.vm = nil
        super.tearDown()
    }
    
    func test_isOn_true_1Entry() {
        vm.isOn.value = true
        let entries = db.objects(Entry.self).sorted(byKeyPath: "enter", ascending: false)
        XCTAssert(entries.count == 1)
        let firstEntry = entries[0]
        XCTAssertNil(firstEntry.exit)
    }
    
    func test_isOn_trueAndFalse_1CompleteEntry() {
        createEntries(vm: vm, count: 1)
        let entries = db.objects(Entry.self).sorted(byKeyPath: "enter", ascending: false)
        XCTAssert(entries.count == 1)
        let firstEntry = entries[0]
        XCTAssertNotNil(firstEntry.exit)
    }
    
    func test_isOn_trueAndtrueAndFalse_1CompleteEntry() {
        vm.isOn.value = true
        createEntries(vm: vm, count: 1)
        let entries = db.objects(Entry.self).sorted(byKeyPath: "enter", ascending: false)
        XCTAssert(entries.count == 1)
        let firstEntry = entries[0]
        XCTAssertNotNil(firstEntry.exit)
    }
    
    fileprivate func createEntries(vm: RotatingButtonsViewModel, count: Int) {
        [0 ..< count].forEach { (index) in
            vm.isOn.value = true
            vm.isOn.value = false
        }
    }
    
}