//
//  EntriesServiceTests.swift
//  Shimi
//
//  Created by Pango-mac on 03/07/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import XCTest
import RealmSwift
import RxSwift
import RxTest
import RxBlocking
import RxSwiftExt
import SwifterSwift

@testable import Shimi

class EntriesServiceTests: XCTestCase {
    
    var db: Realm!
    var entriesService: EntriesService!
    var scheduler: ConcurrentDispatchQueueScheduler!
    
    override func setUp() {
        super.setUp()
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        self.db = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: self.name))
        self.entriesService = EntriesService(db: self.db)
        let mySettings = Settings(workHoursADay: 1.0)
        try! self.db.write {
            self.db.add(mySettings)
        }
    }
    
    override func tearDown() {
        self.db = nil
        self.entriesService = nil
        super.tearDown()
    }
    
    
    func test_WorkHours_1SecondWorkHours_AccountedFor_naive() {
        let disposeBag = DisposeBag()
        let exp = expectation(description: "")
        exp.isInverted = true
        var result: TimeInterval!
        self.entriesService.total.asObservable().subscribe(onNext: { (total) in
            result = total
        }).disposed(by: disposeBag)
        let enterDate = Date()
        let exitDate = enterDate.addingTimeInterval(4.0)
        self.entriesService.entryAction.value = EntriesService.EntryAction.enter(enterDate);
        self.entriesService.entryAction.value = EntriesService.EntryAction.exit(exitDate)
        waitForExpectations(timeout: 1.0) { (error) in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
        }
        XCTAssertEqual(result, 3.0)
    }
    
    func test_WorkHours_2CompleteEventsInOneDay_AccountedFor() {
        let disposeBag = DisposeBag()
        let exp = expectation(description: "")
        exp.isInverted = true
        var result: TimeInterval!
        self.entriesService.total.asObservable().subscribe(onNext: { (total) in
            result = total
        }).disposed(by: disposeBag)
        self.createEntries(days: 1, eventsInADay: 2)
        waitForExpectations(timeout: 1.0) { (error) in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
        }
        XCTAssertEqual(result, 7.0)
    }
    
    func test_WorkHours_multiCompleteEventsInOneDay_AccountedFor() {
        let disposeBag = DisposeBag()
        let exp = expectation(description: "")
        exp.isInverted = true
        var result: TimeInterval!
        self.entriesService.total.asObservable().subscribe(onNext: { (total) in
            result = total
        }).disposed(by: disposeBag)
        self.createEntries(days: 1, eventsInADay: 5)
        waitForExpectations(timeout: 1.0) { (error) in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
        }
        XCTAssertEqual(result, 19.0)
    }
    
    func test_WorkHours_multiDays_AccountedFor() {
        let disposeBag = DisposeBag()
        let exp = expectation(description: "")
        exp.isInverted = true
        var result: TimeInterval!
        self.entriesService.total.asObservable().subscribe(onNext: { (total) in
            result = total
        }).disposed(by: disposeBag)
        self.createEntries(days: 2, eventsInADay: 3, completeEvents: false)
        waitForExpectations(timeout: 1.0) { (error) in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
        }
        XCTAssertEqual(result, 14.0)
    }
    
    fileprivate func createEntries(days: Int, eventsInADay: Int, completeEvents: Bool = true) {
        if days == 0 {
            return
        }
        var startDate = Date().beginning(of: .day)!
        for _ in 0 ..< days {
            createEntries(startDate: startDate, count: eventsInADay, completeEvents: completeEvents)
            startDate.add(.day, value: 1)
        }
    }
    
    fileprivate func createEntries(startDate: Date, count: Int, completeEvents: Bool = true) {
        if count == 0 { return }
        var enterDate = startDate
        var exitDate = enterDate.addingTimeInterval(4.0)
        for _ in 0 ..< count - 1 {
            self.entriesService.entryAction.value = EntriesService.EntryAction.enter(enterDate);
            self.entriesService.entryAction.value = EntriesService.EntryAction.exit(exitDate)
            enterDate = enterDate.addingTimeInterval(10.0)
            exitDate = enterDate.addingTimeInterval(4.0)
        }
        self.entriesService.entryAction.value = EntriesService.EntryAction.enter(enterDate);
        if completeEvents {
            self.entriesService.entryAction.value = EntriesService.EntryAction.exit(exitDate)
        }
    }
    
}
