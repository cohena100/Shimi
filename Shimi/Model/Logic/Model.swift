//
//  Model.swift
//  Shimi
//
//  Created by Pango-mac on 31/05/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import Foundation
import RealmSwift

class Model {
    
    static let sharedInstance = Model()
    var proxies: ProxiesProvider!
    
    convenience init() {
        self.init(proxies: Proxies())
    }
    
    init(proxies: ProxiesProvider) {
        self.proxies = proxies
    }
    
    func entriesService() -> EntriesService {
        let db = self.dbProxy()
        return EntriesService(db: db)
    }
    
    func dbProxy() -> Realm {
        return proxies.db()
    }
    
}
