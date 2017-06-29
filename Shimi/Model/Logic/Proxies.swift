//
//  Proxies.swift
//  Shimi
//
//  Created by Pango-mac on 31/05/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import Foundation
import RealmSwift

class Proxies: ProxiesProvider {
    
    lazy var db: Realm = {
        let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmExists = try? defaultURL.checkResourceIsReachable()
        if realmExists == true {
        } else {
            let bundleRealmPath = Bundle.main.path(forResource: "default-compact", ofType: "realm")!
            let bundleRealmURL = URL(fileURLWithPath: bundleRealmPath)
            try! FileManager.default.copyItem(at: bundleRealmURL, to: defaultURL)
        }
        return try! Realm()
    }()
    
}
