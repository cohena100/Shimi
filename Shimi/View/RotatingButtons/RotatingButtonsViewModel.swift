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
    var isOn: Variable<Bool> { get }
    var state: RotatingButtonsViewController.State { get set }
}

class RotatingButtonsViewModel: NSObject {
    
    init(vc: RotatingButtonsViewModelDelegate) {
        super.init()
        vc.state = .left
        vc.isOn.asObservable().skip(1).subscribe(onNext: { (isOn) in
            let realm = try! Realm()
            let entries = realm.objects(Entry.self).sorted(byKeyPath: "enter", ascending: false)
            if entries.count == 0 {
                if isOn {
                    try! realm.write {
                        realm.add(Entry())
                    }
                }
            } else if isOn {
                if let _ = entries[0].exit {
                    try! realm.write {
                        realm.add(Entry())
                    }
                } else {
                    try! realm.write {
                        entries[0].enter = NSDate()
                    }
                }
            } else {
                try! realm.write {
                    entries[0].exit = NSDate()
                }
            }
            print(entries)
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(self.rx_disposeBag)
    }
    
}
