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
        let exp = expectation(description: "sfds")
        var result: TimeInterval!
        self.entriesService.total.asObservable().skip(2).subscribe(onNext: { (total) in
            result = total
            exp.fulfill()
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
    
    func test_WorkHours_1SecondWorkHours_AccountedFor() {
        let obs = self.entriesService.total.asObservable().subscribeOn(self.scheduler)
        let enterDate = Date()
        let exitDate = enterDate.addingTimeInterval(4.0)
        self.entriesService.entryAction.value = EntriesService.EntryAction.enter(enterDate);
        self.entriesService.entryAction.value = EntriesService.EntryAction.exit(exitDate)
        XCTAssertEqual(3.0, try! obs.toBlocking().first()!)
    }
    
    func test_WorkHours_2CompleteEventsInOneDay_AccountedFor() {
        let obs = self.entriesService.total.asObservable().skip(1).subscribeOn(self.scheduler)
        self.createEntries(count: 2)
        XCTAssertEqual(7.0, try! obs.toBlocking().first()!)
    }
    
    func test_WorkHours_multiCompleteEventsInOneDay_AccountedFor() {
        let obs = self.entriesService.total.asObservable().skip(1).subscribeOn(self.scheduler)
        self.createEntries(count: 5)
        XCTAssertEqual(19.0, try! obs.toBlocking().first()!)
    }
    
    fileprivate func createEntries(count: Int, completeEvents: Bool = true) {
        if count == 0 { return }
        var enterDate = Date().beginning(of: .day)!
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
