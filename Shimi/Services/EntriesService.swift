//
//  EntriesService.swift
//  Shimi
//
//  Created by Pango-mac on 31/05/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import NSObject_Rx
import RxRealm

class EntriesService: NSObject {
    
    enum EntryAction {
        case enter(Date)
        case exit(Date)
    }
    
    let db: Realm
    let entryAction = Variable(EntriesService.EntryAction.enter(Date()))
    let total = Variable(0)
    
    init(db: Realm) {
        self.db = db
        super.init()
        self.entryAction.asObservable().skip(1).subscribe(onNext: { (action) in
            self.handleEntry(action)
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(self.rx_disposeBag)
        let entries = self.db.objects(Entry.self)
        Observable.array(from: entries)
            .map { entries in
                let sum = entries.reduce(0.0, { (soFar, nextEntry) -> TimeInterval in
                    if let exitDate = nextEntry.exit {
                        return soFar + exitDate.timeIntervalSince(nextEntry.enter)
                    } else {
                        return soFar
                    }
                })
                return Int(sum)
            }.subscribe(onNext: { sum  in
                self.total.value = sum
            }).addDisposableTo(rx_disposeBag)
    }
    
    func isEnterState() -> Bool {
        let entries = db.objects(Entry.self).sorted(byKeyPath: #keyPath(Entry.enter), ascending: false)
        return (entries.count > 0 && entries[0].exit == nil) ? false : true
        
    }
    
    fileprivate func handleEntry(_ action: EntryAction) {
        let entries = fetchEntries()
        switch action {
        case .enter(let enterDate):
            if entries.count == 0 {
                try! db.write {
                    let newEntry = Entry(enter: enterDate)
                    db.add(newEntry)
                }
            } else if let _ = entries[0].exit {
                try! db.write {
                    let newEntry = Entry(enter: enterDate)
                    db.add(newEntry)
                }
            } else {
                try! db.write {
                    let currentEntry = entries[0]
                    currentEntry.enter = enterDate
                }
            }
        case .exit(let exitDate):
            try! db.write {
                let currentEntry = entries[0]
                currentEntry.exit = exitDate
            }
        }
    }
    
    fileprivate func fetchEntries() -> Results<Entry> {
        return db.objects(Entry.self).sorted(byKeyPath: #keyPath(Entry.enter), ascending: false)
    }
    
}
