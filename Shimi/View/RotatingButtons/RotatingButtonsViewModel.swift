//
//  RotatingButtonsViewModel.swift
//  Shimi
//
//  Created by Pango-mac on 20/05/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import Foundation
import RxSwift
import NSObject_Rx
import RxRealm
import RealmSwift

class RotatingButtonsViewModel: NSObject {
    
    var startingState: RotatingButtonsState = .left
    let isOn = Variable(true)
    let db: Realm
    
    init(db: Realm, vc: RotatingButtonsViewModelDelegate?) {
        self.db = db
        let entries = db.objects(Entry.self).sorted(byKeyPath: #keyPath(Entry.enter), ascending: false)
        self.startingState = (entries.count > 0 && entries[0].exit == nil) ? .right : .left
        vc?.state = self.startingState
        super.init()
        self.isOn.asObservable().skip(1).subscribe(onNext: { (isOn) in
            self.handleEnterOrExit(isOn: isOn)
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(self.rx_disposeBag)
    }

    fileprivate func handleEnterOrExit(isOn: Bool) {
        let entries = fetchEntries()
        if entries.count == 0 {
            if isOn {
                try! db.write {
                    db.add(Entry(enter: NSDate()))
                }
            }
        } else if isOn {
            if let _ = entries[0].exit {
                try! db.write {
                    db.add(Entry(enter: NSDate()))
                }
            } else {
                try! db.write {
                    entries[0].enter = NSDate()
                }
            }
        } else {
            try! db.write {
                entries[0].exit = NSDate()
            }
        }
        print(entries)
    }
    
    fileprivate func fetchEntries() -> Results<Entry> {
        return db.objects(Entry.self).sorted(byKeyPath: #keyPath(Entry.enter), ascending: false)
    }
    
}

extension RotatingButtonsViewModel: RotatingButtonsViewControllerDelegate {}

