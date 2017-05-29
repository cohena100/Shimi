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

protocol RotatingButtonsViewModelDelegate: class {
    var state: RotatingButtonsViewModel.State { get set }
}

class RotatingButtonsViewModel: NSObject {
    enum State {
        case left
        case right
    }

    let isOn = Variable(true)
    let db: Realm
    
    init(db: Realm, vc: RotatingButtonsViewModelDelegate?) {
        self.db = db
        vc?.state = .left
        super.init()
        self.isOn.asObservable().skip(1).subscribe(onNext: { (isOn) in
            self.handleEnterOrExit(isOn: isOn)
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(self.rx_disposeBag)
    }

    fileprivate func handleEnterOrExit(isOn: Bool) {
        let entries = db.objects(Entry.self).sorted(byKeyPath: "enter", ascending: false)
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
    
}
