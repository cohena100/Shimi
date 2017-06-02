//
//  Entry.swift
//  Shimi
//
//  Created by Pango-mac on 27/05/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import Foundation
import RealmSwift

class Entry: Object {
    dynamic var enter = Date()
    dynamic var exit: Date? = nil
    
    override static func indexedProperties() -> [String] {
        return ["entered"]
    }
    
    convenience init(enter: Date) {
        self.init()
        self.enter = enter
    }

}
