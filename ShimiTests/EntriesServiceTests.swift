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
    
    
    func test_WorkHours_1SecondWorkHours_AccountedFor() {
        let exp = expectation(description: "sfds")
        let _ = self.entriesService.total.asObservable().skip(2).subscribe(onNext: { (total) in
            print("total: \(total)")
            exp.fulfill()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        let enterDate = Date()
        let exitDate = enterDate.addingTimeInterval(4.0)
        self.entriesService.entryAction.value = EntriesService.EntryAction.enter(enterDate);
        self.entriesService.entryAction.value = EntriesService.EntryAction.exit(exitDate)
        waitForExpectations(timeout: 1.0) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }
    
}
