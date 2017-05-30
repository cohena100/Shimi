//
//  BaseBuilder.swift
//  Shimi
//
//  Created by Pango-mac on 30/05/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import Foundation
import RealmSwift

class BaseBuilder: NSObject {
    
    let db: Realm
    
    override init() {
        self.db = try! Realm()
        super.init()
    }
    
}
