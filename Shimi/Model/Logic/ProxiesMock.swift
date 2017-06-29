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
        return try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "ui tests"))
    }()

}
