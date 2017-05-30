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
        let entries = fetchEntries()
        XCTAssert(entries.count == 1)
        let firstEntry = entries[0]
        XCTAssertNil(firstEntry.exit)
    }
    
    func test_isOn_trueAndFalse_1CompleteEntry() {
        createEntries(vm: vm, count: 1)
        let entries = fetchEntries()
        XCTAssert(entries.count == 1)
        let firstEntry = entries[0]
        XCTAssertNotNil(firstEntry.exit)
    }
    
    func test_isOn_trueAndtrueAndFalse_1CompleteEntry() {
        vm.isOn.value = true
        createEntries(vm: vm, count: 1)
        let entries = fetchEntries()
        XCTAssert(entries.count == 1)
        let firstEntry = entries[0]
        XCTAssertNotNil(firstEntry.exit)
    }
    
    func test_isOn_someTrueAndFalse_3CompleteEntry() {
        createEntries(vm: vm, count: 3)
        let entries = fetchEntries()
        XCTAssert(entries.count == 3)
    }
    
    func test_State_SomeEntriesAndNoExit_StateEqualsRight() {
        XCTAssertTrue(vm.startingState == .left)
        createEntries(vm: vm, count: 3)
        vm.isOn.value = true
        vm = RotatingButtonsViewModel(db: self.db, vc: nil)
        XCTAssertTrue(vm.startingState == .right)
    }
    
    fileprivate func createEntries(vm: RotatingButtonsViewModel, count: Int) {
        for _ in 0 ..< count {
            vm.isOn.value = true
            vm.isOn.value = false
        }
    }
    
    fileprivate func fetchEntries() -> Results<Entry> {
        return db.objects(Entry.self).sorted(byKeyPath: "enter", ascending: false)
    }

}
