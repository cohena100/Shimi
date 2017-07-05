//
//  ProxiesMock.swift
//  Shimi
//
//  Created by Pango-mac on 31/05/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import Foundation
import RealmSwift

class ProxiesMock: ProxiesProvider {
    
    lazy var db: Realm = {
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "ui tests"))
        let mySettings = Settings(workHoursADay: 1.0)
        try! realm.write {
            realm.add(mySettings)
        }
        return realm
    }()

}
