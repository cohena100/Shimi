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
    
    func db() -> Realm {
        return try! Realm()
    }
}
