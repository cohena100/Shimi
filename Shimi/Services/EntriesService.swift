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

class EntriesService: NSObject {
    
    enum EntryAction {
        case enter(NSDate)
        case exit(NSDate)
    }
    
    let db: Realm
    let entryAction = Variable(EntriesService.EntryAction.enter(NSDate()))
    
    init(db: Realm) {
        self.db = db
        super.init()
        self.entryAction.asObservable().skip(1).subscribe(onNext: { (action) in
            self.handleEntry(action)
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(self.rx_disposeBag)
        
    }
    
    func isEnterState() -> Bool {
        let entries = db.objects(Entry.self).sorted(byKeyPath: #keyPath(Entry.enter), ascending: false)
        return (entries.count > 0 && entries[0].exit == nil) ? false : true
        
    }
    
    fileprivate func handleEntry(_ action: EntryAction) {
        let entries = fetchEntries()
        if entries.count == 0 {
            if case .enter(let date) = action  {
                try! db.write {
                    db.add(Entry(enter: date))
                }
            }
        } else {
            switch action {
            case .enter(let date):
                if let _ = entries[0].exit {
                    try! db.write {
                        db.add(Entry(enter: date))
                    }
                } else {
                    try! db.write {
                        entries[0].enter = date
                    }
                }
            case .exit(let date):
                try! db.write {
                    entries[0].exit = date
                }
            }
        }
        print(entries)
    }
    
    fileprivate func fetchEntries() -> Results<Entry> {
        return db.objects(Entry.self).sorted(byKeyPath: #keyPath(Entry.enter), ascending: false)
    }
    
}
